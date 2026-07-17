from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path
from unittest import mock


SCRIPT_PATH = (
    Path(__file__).resolve().parents[1]
    / ".github"
    / "workflows"
    / "write-user-metrics.py"
)
SPEC = importlib.util.spec_from_file_location("write_user_metrics", SCRIPT_PATH)
assert SPEC and SPEC.loader
write_user_metrics = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(write_user_metrics)


class BuildMetricsTests(unittest.TestCase):
    def test_users_to_date_uses_all_time_total_users(self) -> None:
        def fake_run_report(
            token: str,
            property_id: str,
            body: dict,
            start_date: str = write_user_metrics.EARLIEST_START_DATE,
            end_date: str = "today",
        ) -> list[dict]:
            del token, property_id, end_date
            metric_names = [metric["name"] for metric in body.get("metrics", [])]
            dimension_names = [
                dimension["name"] for dimension in body.get("dimensions", [])
            ]

            if metric_names == ["newUsers"] and dimension_names == ["yearMonth"]:
                return [
                    {
                        "dimensionValues": [{"value": "202607"}],
                        "metricValues": [{"value": "35"}],
                    }
                ]

            if metric_names == ["totalUsers"] and dimension_names == [
                "countryId",
                "country",
            ]:
                return []

            if metric_names == ["totalUsers"] and start_date == "30daysAgo":
                return [{"metricValues": [{"value": "60"}]}]

            if (
                metric_names == ["totalUsers"]
                and start_date == write_user_metrics.EARLIEST_START_DATE
            ):
                return [{"metricValues": [{"value": "75"}]}]

            if metric_names == ["totalUsers", "sessions", "screenPageViews"]:
                return [
                    {
                        "metricValues": [
                            {"value": "60"},
                            {"value": "103"},
                            {"value": "250"},
                        ]
                    }
                ]

            self.fail(
                f"Unexpected report: metrics={metric_names}, "
                f"dimensions={dimension_names}, start_date={start_date}"
            )

        with mock.patch.object(
            write_user_metrics, "run_report", side_effect=fake_run_report
        ):
            metrics = write_user_metrics.build_metrics("token", "property", 30)

        self.assertEqual(metrics["totalUsers"], 75)
        self.assertEqual(metrics["periodUsers"], 60)
        self.assertEqual(metrics["months"][0]["newUsers"], 35)
        self.assertEqual(metrics["months"][0]["cumulativeUsers"], 35)


if __name__ == "__main__":
    unittest.main()
