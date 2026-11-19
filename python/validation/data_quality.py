
import pandas as pd
from pathlib import Path

# Project directory
BASE_DIR = Path(__file__).resolve().parents[2]

# Raw dataset directory
RAW_DIR = BASE_DIR / "data" / "raw"

# Load all CSV datasets
datasets = {}

csv_files = list(RAW_DIR.glob("*.csv"))

print("=" * 65)
print("OLIST E-COMMERCE DATASET PROFILING")
print("=" * 65)

if len(csv_files) != 9:
    raise ValueError(
        f"Expected 9 CSV files, found {len(csv_files)}"
    )

for file in csv_files:

    dataset_name = file.stem.replace(
        "olist_", ""
    ).replace("_dataset", "")

    df = pd.read_csv(file)

    datasets[dataset_name] = df

    print(f"\nDataset: {file.name}")
    print("-" * 50)
    print(f"Rows: {df.shape[0]:,}")
    print(f"Columns: {df.shape[1]}")
    print(f"Memory: {df.memory_usage(deep=True).sum() / 1024**2:.2f} MB")

print("\n" + "=" * 65)
print("ALL DATASETS LOADED SUCCESSFULLY")
print("=" * 65)

print(f"Total datasets: {len(datasets)}")

print("\n" + "=" * 70)
print("DATASET STRUCTURE ANALYSIS")
print("=" * 70)

for name, df in datasets.items():

    print(f"\nDATASET: {name.upper()}")
    print("-" * 60)

    print("\nColumn Names:")
    print(df.columns.tolist())

    print("\nData Types:")
    print(df.dtypes)

    print("\nMissing Values:")
    print(df.isnull().sum())

    print("\nDuplicate Rows:")
    print(df.duplicated().sum())

    print("\nSample Records:")
    print(df.head(3).to_string(index=False))