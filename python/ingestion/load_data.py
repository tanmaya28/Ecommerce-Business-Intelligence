import logging
from datetime import datetime

from pathlib import Path

import pandas as pd

from python.config.config import engine

# Project paths
ROOT = Path(__file__).resolve().parents[2]
RAW_DATA = ROOT / "data" / "raw"

LOG_DIR = ROOT / "logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

def setup_logging():
    log_file = LOG_DIR / "etl_pipeline.log"

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s | %(levelname)s | %(message)s",
        handlers=[
            logging.FileHandler(log_file, encoding="utf-8"),
            logging.StreamHandler(),
        ],
        force=True,
    )

    return logging.getLogger("ETL")

# CSV filename, SQL table name, date columns
DATASETS = {
    "olist_customers_dataset.csv": ("customers", []),
    "olist_products_dataset.csv": ("products", []),
    "olist_sellers_dataset.csv": ("sellers", []),
    "product_category_name_translation.csv": (
        "product_category_translation", []
    ),
    "olist_orders_dataset.csv": (
        "orders",
        [
            "order_purchase_timestamp",
            "order_approved_at",
            "order_delivered_carrier_date",
            "order_delivered_customer_date",
            "order_estimated_delivery_date",
        ],
    ),
    "olist_order_items_dataset.csv": (
        "order_items",
        ["shipping_limit_date"],
    ),
    "olist_order_payments_dataset.csv": ("order_payments", []),
    "olist_order_reviews_dataset.csv": (
        "order_reviews",
        ["review_creation_date", "review_answer_timestamp"],
    ),
    "olist_geolocation_dataset.csv": ("geolocation", []),
}

READ_CHUNK_SIZE = 10000
SQL_CHUNK_SIZE = 200


def verify_files():
    """Check that all required CSV files exist."""
    missing = [
        filename
        for filename in DATASETS
        if not (RAW_DATA / filename).exists()
    ]

    if missing:
        raise FileNotFoundError(
            f"Missing CSV files: {missing}"
        )

    print("All nine CSV files found.")


def verify_empty_tables():
    """Prevent accidental duplicate loading."""
    with engine.connect() as connection:
        for table, _ in DATASETS.values():
            count = connection.exec_driver_sql(
                f"SELECT COUNT(*) FROM dbo.[{table}]"
            ).scalar_one()

            if count > 0:
                raise RuntimeError(
                    f"Table '{table}' already contains "
                    f"{count} rows. Stop to avoid duplicates."
                )

    print("All destination tables are empty.")



def load_dataset(filename, table, date_columns):
    """Read, transform and load one CSV dataset."""
    file_path = RAW_DATA / filename
    total_rows = 0

    print(f"\nLoading: {filename}")
    logging.info("Starting dataset: %s", filename)
    print(f"Target table: {table}")

    for chunk in pd.read_csv(
        file_path,
        chunksize=READ_CHUNK_SIZE,
        low_memory=False,
    ):
        # Standardize date columns
        for column in date_columns:
            chunk[column] = pd.to_datetime(
                chunk[column],
                errors="coerce",
            )

        # Standardize Olist product column names
        if table == "products":
            chunk.rename(
                columns={
                    "product_name_lenght": "product_name_length",
                    "product_description_lenght": "product_description_length",
                },
                inplace=True,
            )

            # Verify that the rename worked
            print("\nProduct columns after renaming:")
            print(chunk.columns.tolist())

            if (
                "product_name_lenght" in chunk.columns
                or "product_description_lenght" in chunk.columns
            ):
                raise ValueError(
                    "Product column renaming failed."
                )

        # Load into existing SQL Server table
        chunk.to_sql(
            name=table,
            con=engine,
            schema="dbo",
            if_exists="append",
            index=False,
            chunksize=SQL_CHUNK_SIZE,
        )

        total_rows += len(chunk)
        print(f"  Loaded {total_rows:,} rows", end="\r")

    print(f"\nCompleted: {table} ({total_rows:,} rows)")
    logging.info(
    "Completed table: %s | Rows loaded: %s",
    table,
    total_rows,
    )
    return total_rows


def main():
    print("=" * 60)
    print("OLIST E-COMMERCE ETL PIPELINE")
    print("=" * 60)

    verify_files()
    verify_empty_tables()

    results = {}

    for filename, (table, date_columns) in DATASETS.items():
        rows = load_dataset(
            filename,
            table,
            date_columns,
        )
        results[table] = rows

    print("\n" + "=" * 60)
    print("ETL PIPELINE COMPLETED")
    print("=" * 60)

    for table, rows in results.items():
        print(f"{table:35} {rows:>12,}")

    print("=" * 60)

    print("\nVerifying SQL Server row counts:")

    with engine.connect() as connection:
        for table, expected_rows in results.items():
            actual_rows = connection.exec_driver_sql(
                f"SELECT COUNT(*) FROM dbo.[{table}]"
            ).scalar_one()

            status = (
                "PASS"
                if actual_rows == expected_rows
                else "FAIL"
            )

            print(
                f"{table:35} "
                f"{actual_rows:>12,} "
                f"{status}"
            )

    engine.dispose()

if __name__ == "__main__":
    logger = setup_logging()

    try:
        logger.info("=" * 50)
        logger.info("ETL PIPELINE STARTED")

        main()

        logger.info("ETL PIPELINE COMPLETED SUCCESSFULLY")

    except Exception:
        logger.exception("ETL PIPELINE FAILED")
        raise
