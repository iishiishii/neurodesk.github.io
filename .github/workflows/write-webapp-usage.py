#!/usr/bin/env python3
"""Generate static usage statistics for hosted Neurodesk webapps."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import sys
from pathlib import Path
from typing import Any

import requests


CLOUDFLARE_GRAPHQL_URL = "https://api.cloudflare.com/client/v4/graphql"
CLOUDFLARE_ACCOUNT_ID_ENV = "CLOUDFLARE_ACCOUNT_ID"
CLOUDFLARE_TOKEN_ENV = "CLOUDFLARE_API_TOKEN_WEBAPPS_ANALYTICS"
DEFAULT_PERIOD_DAYS = 30
GROUP_LIMIT = 10000

WEBAPPS = [
    {
        "id": "calmar",
        "name": "CALMaR",
        "host": "calmar.neurodesk.org",
    },
    {
        "id": "musclemap",
        "name": "MuscleMap",
        "host": "musclemap.neurodesk.org",
    },
    {
        "id": "vesselboost",
        "name": "VesselBoost",
        "host": "vesselboost.neurodesk.org",
    },
    {
        "id": "sct",
        "name": "Spinal Cord Toolbox",
        "host": "sct.neurodesk.org",
    },
]

QUERY = """
query WebappUsage($accountTag: string!, $host: string!, $start: Time!, $end: Time!) {
  viewer {
    accounts(filter: { accountTag: $accountTag }) {
      rumPageloadEventsAdaptiveGroups(
        limit: 10000
        orderBy: [date_ASC]
        filter: {
          datetime_geq: $start
          datetime_lt: $end
          requestHost: $host
        }
      ) {
        count
        sum {
          visits
        }
        dimensions {
          date
          countryName
          deviceType
          userAgentBrowser
        }
      }
    }
  }
}
"""


def utc_now() -> dt.datetime:
    return dt.datetime.now(dt.timezone.utc).replace(microsecond=0)


def isoformat_z(value: dt.datetime) -> str:
    return value.isoformat().replace("+00:00", "Z")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Write static/data/webapp-usage.json from Cloudflare RUM GraphQL."
    )
    parser.add_argument(
        "--account-id",
        default=os.environ.get(CLOUDFLARE_ACCOUNT_ID_ENV, ""),
        help="Cloudflare account id passed as the GraphQL accountTag.",
    )
    parser.add_argument(
        "--period-days",
        type=int,
        default=DEFAULT_PERIOD_DAYS,
        help="Number of trailing days to include.",
    )
    parser.add_argument(
        "--output",
        default="static/data/webapp-usage.json",
        help="Path to the generated JSON file.",
    )
    parser.add_argument(
        "--allow-missing-token",
        action="store_true",
        help="Write an unavailable placeholder instead of failing when the token is absent.",
    )
    return parser.parse_args()


def empty_usage(generated_at: str, period_days: int, unavailable: bool = False) -> dict[str, Any]:
    data: dict[str, Any] = {
        "generatedAt": generated_at,
        "periodDays": period_days,
        "apps": [],
    }
    if unavailable:
        data["unavailable"] = True

    for app in WEBAPPS:
        data["apps"].append(
            {
                **app,
                "visits": 0,
                "pageViews": 0,
                "daily": [],
                "countries": [],
                "deviceTypes": [],
                "browsers": [],
            }
        )
    return data


def write_json(path: str, data: dict[str, Any]) -> None:
    output_path = Path(path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(data, indent=2, sort_keys=False) + "\n", encoding="utf-8")
    print(f"Wrote {output_path}")


def metric_to_int(value: Any) -> int:
    if value is None:
        return 0
    return int(round(float(value)))


def normalize_dimension(value: Any, fallback: str) -> str:
    if value is None:
        return fallback
    text = str(value).strip()
    return text if text else fallback


def add_metric(bucket: dict[str, Any], visits: int, page_views: int) -> None:
    bucket["visits"] += visits
    bucket["pageViews"] += page_views


def sorted_metric_rows(rows: dict[str, dict[str, Any]], key_name: str) -> list[dict[str, Any]]:
    return sorted(
        rows.values(),
        key=lambda row: (-row["visits"], -row["pageViews"], str(row[key_name]).lower()),
    )


def summarize_app(app: dict[str, str], groups: list[dict[str, Any]]) -> dict[str, Any]:
    daily: dict[str, dict[str, Any]] = {}
    countries: dict[str, dict[str, Any]] = {}
    device_types: dict[str, dict[str, Any]] = {}
    browsers: dict[str, dict[str, Any]] = {}
    totals = {"visits": 0, "pageViews": 0}

    for group in groups:
        dimensions = group.get("dimensions") or {}
        page_views = metric_to_int(group.get("count"))
        visits = metric_to_int((group.get("sum") or {}).get("visits"))

        totals["visits"] += visits
        totals["pageViews"] += page_views

        date = normalize_dimension(dimensions.get("date"), "unknown")
        if date != "unknown":
            add_metric(daily.setdefault(date, {"date": date, "visits": 0, "pageViews": 0}), visits, page_views)

        country = normalize_dimension(dimensions.get("countryName"), "Unknown")
        add_metric(
            countries.setdefault(country, {"countryName": country, "visits": 0, "pageViews": 0}),
            visits,
            page_views,
        )

        device_type = normalize_dimension(dimensions.get("deviceType"), "Unknown")
        add_metric(
            device_types.setdefault(device_type, {"deviceType": device_type, "visits": 0, "pageViews": 0}),
            visits,
            page_views,
        )

        browser = normalize_dimension(dimensions.get("userAgentBrowser"), "Unknown")
        add_metric(
            browsers.setdefault(browser, {"userAgentBrowser": browser, "visits": 0, "pageViews": 0}),
            visits,
            page_views,
        )

    return {
        **app,
        **totals,
        "daily": sorted(daily.values(), key=lambda row: row["date"]),
        "countries": sorted_metric_rows(countries, "countryName"),
        "deviceTypes": sorted_metric_rows(device_types, "deviceType"),
        "browsers": sorted_metric_rows(browsers, "userAgentBrowser"),
        "groupLimitReached": len(groups) >= GROUP_LIMIT,
    }


def query_cloudflare(
    token: str,
    account_id: str,
    host: str,
    start: str,
    end: str,
) -> list[dict[str, Any]]:
    response = requests.post(
        CLOUDFLARE_GRAPHQL_URL,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        json={
            "query": QUERY,
            "variables": {
                "accountTag": account_id,
                "host": host,
                "start": start,
                "end": end,
            },
        },
        timeout=30,
    )
    if response.status_code != 200:
        raise RuntimeError(
            f"Cloudflare GraphQL returned HTTP {response.status_code}: {response.text[:500]}"
        )

    payload = response.json()
    if payload.get("errors"):
        raise RuntimeError(f"Cloudflare GraphQL errors: {json.dumps(payload['errors'], indent=2)}")

    accounts = (((payload.get("data") or {}).get("viewer") or {}).get("accounts") or [])
    if not accounts:
        raise RuntimeError(
            "Cloudflare GraphQL returned no accounts. Check CLOUDFLARE_ACCOUNT_ID/accountTag."
        )

    return accounts[0].get("rumPageloadEventsAdaptiveGroups") or []


def main() -> int:
    args = parse_args()
    if args.period_days <= 0:
        print("--period-days must be greater than 0", file=sys.stderr)
        return 2

    generated_at = isoformat_z(utc_now())
    token = os.environ.get(CLOUDFLARE_TOKEN_ENV, "").strip()

    if not token:
        if not args.allow_missing_token:
            print(f"{CLOUDFLARE_TOKEN_ENV} is not set", file=sys.stderr)
            return 1
        write_json(args.output, empty_usage(generated_at, args.period_days, unavailable=True))
        return 0

    account_id = args.account_id.strip()
    if not account_id:
        print(f"{CLOUDFLARE_ACCOUNT_ID_ENV} is not set", file=sys.stderr)
        return 1

    end = utc_now()
    start = end - dt.timedelta(days=args.period_days)
    usage = empty_usage(generated_at, args.period_days)
    usage["apps"] = []

    for app in WEBAPPS:
        groups = query_cloudflare(
            token=token,
            account_id=account_id,
            host=app["host"],
            start=isoformat_z(start),
            end=isoformat_z(end),
        )
        usage["apps"].append(summarize_app(app, groups))
        print(f"{app['host']}: {len(groups)} grouped rows")

    write_json(args.output, usage)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
