
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[2]
RAW_DIR = BASE_DIR / "data" / "raw"

# Load datasets
geo = pd.read_csv(RAW_DIR / "olist_geolocation_dataset.csv")
orders = pd.read_csv(RAW_DIR / "olist_orders_dataset.csv")
products = pd.read_csv(RAW_DIR / "olist_products_dataset.csv")

print("=" * 65)
print("DATA QUALITY INVESTIGATION")
print("=" * 65)


# 1. GEOLOCATION INVESTIGATION

print("\n1. GEOLOCATION ANALYSIS")

print("Total records:", len(geo))
print("Exact duplicate rows:", geo.duplicated().sum())

print(
    "Unique ZIP codes:",
    geo["geolocation_zip_code_prefix"].nunique()
)

print(
    "Duplicate ZIP code records:",
    geo.duplicated(
        subset=["geolocation_zip_code_prefix"]
    ).sum()
)

print("\nTop 10 ZIP codes by record count:")

print(
    geo["geolocation_zip_code_prefix"]
    .value_counts()
    .head(10)
)


# 2. ORDERS INVESTIGATION

print("\n2. ORDERS ANALYSIS")

date_columns = [
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date"
]

print("\nMissing dates by order status:")

for column in date_columns:

    print(f"\n{column}")

    result = orders.groupby(
        "order_status"
    )[column].apply(
        lambda x: x.isna().sum()
    )

    print(result)


# 3. PRODUCTS INVESTIGATION

print("\n3. PRODUCTS ANALYSIS")

print("\nMissing values:")

print(products.isnull().sum())

print("\nProducts with missing categories:")

missing_categories = products[
    products["product_category_name"].isna()
]

print("Total:", len(missing_categories))

print(
    missing_categories.head(10).to_string(index=False)
)

print("\nProducts with missing physical dimensions:")

dimension_columns = [
    "product_weight_g",
    "product_length_cm",
    "product_height_cm",
    "product_width_cm"
]

missing_dimensions = products[
    products[dimension_columns].isna().any(axis=1)
]

print("Total:", len(missing_dimensions))

print(
    missing_dimensions.to_string(index=False)
)

print("\nINVESTIGATION COMPLETED")
