
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[2]
RAW_DIR = BASE_DIR / "data" / "raw"
REPORT_DIR = BASE_DIR / "reports"

REPORT_DIR.mkdir(parents=True, exist_ok=True)

quality_reports = []

for file in RAW_DIR.glob("*.csv"):

    df = pd.read_csv(file)

    total_rows = len(df)

    for column in df.columns:

        missing = df[column].isna().sum()

        quality_reports.append({

            "dataset": file.name,
            "column": column,
            "data_type": str(df[column].dtype),
            "total_rows": total_rows,
            "missing_values": missing,
            "missing_percentage": round(
                (missing / total_rows) * 100, 2
            ),
            "unique_values": df[column].nunique(),
            "duplicate_rows": df.duplicated().sum()

        })

report = pd.DataFrame(quality_reports)

output_file = REPORT_DIR / "data_quality_report.csv"

report.to_csv(output_file, index=False)

print("=" * 60)
print("DATA QUALITY REPORT GENERATED")
print("=" * 60)

print(report.to_string(index=False))

print(f"\nReport saved at: {output_file}")
