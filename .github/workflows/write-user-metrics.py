#!/usr/bin/env python3
"""Generate static monthly user statistics from the Google Analytics 4 Data API."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import sys
from pathlib import Path
from typing import Any

import requests


GA4_PROPERTY_ID_ENV = "GA4_PROPERTY_ID"
GA4_SERVICE_ACCOUNT_KEY_ENV = "GA4_SERVICE_ACCOUNT_KEY"
ANALYTICS_SCOPE = "https://www.googleapis.com/auth/analytics.readonly"
# Earliest date the GA4 Data API accepts; months without data return no rows.
EARLIEST_START_DATE = "2015-08-14"


def utc_now() -> dt.datetime:
    return dt.datetime.now(dt.timezone.utc).replace(microsecond=0)


def isoformat_z(value: dt.datetime) -> str:
    return value.isoformat().replace("+00:00", "Z")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Write static/data/user-metrics.json from the GA4 Data API."
    )
    parser.add_argument(
        "--property-id",
        default=os.environ.get(GA4_PROPERTY_ID_ENV, ""),
        help="GA4 property id (numeric).",
    )
    parser.add_argument(
        "--output",
        default="static/data/user-metrics.json",
        help="Path to the generated JSON file.",
    )
    parser.add_argument(
        "--allow-missing-token",
        action="store_true",
        help="Write an unavailable placeholder instead of failing when credentials are absent.",
    )
    return parser.parse_args()


def empty_metrics(generated_at: str, unavailable: bool = False) -> dict[str, Any]:
    data: dict[str, Any] = {
        "generatedAt": generated_at,
        "source": "Google Analytics 4",
        "totalUsers": 0,
        "months": [],
    }
    if unavailable:
        data["unavailable"] = True
    return data


def write_json(path: str, data: dict[str, Any]) -> None:
    output_path = Path(path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(data, indent=2, sort_keys=False) + "\n", encoding="utf-8")
    print(f"Wrote {output_path}")


def get_access_token(service_account_info: dict[str, Any]) -> str:
    # Imported lazily so placeholder mode works without google-auth installed.
    from google.oauth2 import service_account
    import google.auth.transport.requests

    credentials = service_account.Credentials.from_service_account_info(
        service_account_info, scopes=[ANALYTICS_SCOPE]
    )
    credentials.refresh(google.auth.transport.requests.Request())
    return credentials.token


def run_report(token: str, property_id: str) -> list[dict[str, Any]]:
    response = requests.post(
        f"https://analyticsdata.googleapis.com/v1beta/properties/{property_id}:runReport",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        json={
            "dateRanges": [{"startDate": EARLIEST_START_DATE, "endDate": "today"}],
            "dimensions": [{"name": "yearMonth"}],
            "metrics": [{"name": "newUsers"}],
            "orderBys": [{"dimension": {"dimensionName": "yearMonth"}}],
            "limit": 10000,
        },
        timeout=60,
    )
    if response.status_code != 200:
        raise RuntimeError(
            f"GA4 Data API returned HTTP {response.status_code}: {response.text[:500]}"
        )
    return response.json().get("rows") or []


def summarize(rows: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], int]:
    months: list[dict[str, Any]] = []
    cumulative = 0
    for row in rows:
        year_month = (row.get("dimensionValues") or [{}])[0].get("value", "")
        if len(year_month) != 6 or not year_month.isdigit():
            continue
        new_users = int(round(float((row.get("metricValues") or [{}])[0].get("value") or 0)))
        cumulative += new_users
        months.append(
            {
                "month": f"{year_month[:4]}-{year_month[4:]}",
                "newUsers": new_users,
                "cumulativeUsers": cumulative,
            }
        )
    return months, cumulative


def main() -> int:
    args = parse_args()
    generated_at = isoformat_z(utc_now())

    key_json = os.environ.get(GA4_SERVICE_ACCOUNT_KEY_ENV, "").strip()
    property_id = args.property_id.strip()

    if not key_json or not property_id:
        missing = GA4_SERVICE_ACCOUNT_KEY_ENV if not key_json else GA4_PROPERTY_ID_ENV
        if not args.allow_missing_token:
            print(f"{missing} is not set", file=sys.stderr)
            return 1
        print(f"{missing} is not set — writing unavailable placeholder")
        write_json(args.output, empty_metrics(generated_at, unavailable=True))
        return 0

    try:
        service_account_info = json.loads(key_json)
    except json.JSONDecodeError as error:
        print(f"{GA4_SERVICE_ACCOUNT_KEY_ENV} is not valid JSON: {error}", file=sys.stderr)
        return 1

    token = get_access_token(service_account_info)
    rows = run_report(token, property_id)
    months, total_users = summarize(rows)
    print(f"GA4 property {property_id}: {len(months)} months, {total_users} users total")

    data = empty_metrics(generated_at)
    data["months"] = months
    data["totalUsers"] = total_users
    write_json(args.output, data)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
