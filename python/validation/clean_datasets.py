
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[2]

RAW_DIR = BASE_DIR / "data" / "raw"
PROCESSED_DIR = BASE_DIR / "data" / "processed"

PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

# Columns that should be converted to datetime
DATE_COLUMNS = {
    "olist_orders_dataset.csv": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date"
    ],

    "olist_order_items_dataset.csv": [
        "shipping_limit_date"
    ],

    "olist_order_reviews_dataset.csv": [
        "review_creation_date",
        "review_answer_timestamp"
    ]
}

print("=" * 65)
print("OLIST DATA CLEANING PIPELINE")
print("=" * 65)

cleaning_summary = []

for file in RAW_DIR.glob("*.csv"):

    print(f"\nProcessing: {file.name}")

    df = pd.read_csv(file)

    original_rows = len(df)

    # Step 1: Remove exact duplicate rows
    duplicate_count = int(df.duplicated().sum())

    df = df.drop_duplicates().copy()

    # Step 2: Convert date columns
    invalid_dates = 0

    for column in DATE_COLUMNS.get(file.name, []):

        original_values = df[column].notna()

        df[column] = pd.to_datetime(
            df[column],
            errors="coerce"
        )

        invalid_dates += int(
            (original_values & df[column].isna()).sum()
        )

    # Step 3: Preserve missing values
    # No arbitrary filling or deletion.

    # Step 4: Save processed dataset
    output_file = PROCESSED_DIR / file.name

    df.to_csv(output_file, index=False)

    cleaned_rows = len(df)

    cleaning_summary.append({

        "dataset": file.name,
        "original_rows": original_rows,
        "duplicates_removed": duplicate_count,
        "cleaned_rows": cleaned_rows,
        "invalid_dates": invalid_dates,
        "missing_values_remaining": int(
            df.isna().sum().sum()
        )

    })

    print(f"Original rows: {original_rows:,}")
    print(f"Duplicates removed: {duplicate_count:,}")
    print(f"Cleaned rows: {cleaned_rows:,}")
    print(f"Invalid dates: {invalid_dates}")
    print("Saved successfully.")

# Generate cleaning summary
summary = pd.DataFrame(cleaning_summary)

summary_file = (
    BASE_DIR / "reports" / "cleaning_summary.csv"
)

summary.to_csv(summary_file, index=False)

print("\n" + "=" * 65)
print("DATA CLEANING COMPLETED")
print("=" * 65)

print(summary.to_string(index=False))

print(f"\nProcessed files: {PROCESSED_DIR}")
print(f"Cleaning report: {summary_file}")
