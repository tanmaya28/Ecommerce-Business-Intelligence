
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[2]

RAW_DIR = BASE_DIR / "data" / "raw"
PROCESSED_DIR = BASE_DIR / "data" / "processed"

print("=" * 65)
print("PROCESSED DATA VALIDATION")
print("=" * 65)

all_passed = True

for raw_file in RAW_DIR.glob("*.csv"):

    processed_file = PROCESSED_DIR / raw_file.name

    raw_df = pd.read_csv(raw_file)
    clean_df = pd.read_csv(processed_file)

    expected_rows = (
        len(raw_df) - raw_df.duplicated().sum()
    )

    checks = {
        "Row count": len(clean_df) == expected_rows,

        "No exact duplicates":
            not clean_df.duplicated().any(),

        "Missing values preserved":
            raw_df.isna().sum().equals(
                clean_df.isna().sum()
            ),

        "Column structure preserved":
            raw_df.columns.tolist() ==
            clean_df.columns.tolist()
    }

    print(f"\nDataset: {raw_file.name}")

    for check, passed in checks.items():

        status = "PASS" if passed else "FAIL"

        print(f"{status}: {check}")

        if not passed:
            all_passed = False

print("\n" + "=" * 65)

if all_passed:
    print("ALL DATA VALIDATION CHECKS PASSED")
else:
    print("SOME VALIDATION CHECKS FAILED")

print("=" * 65)
