
from pathlib import Path

# Automatically detect the current project directory
ROOT = Path(__file__).resolve().parent

# Project directories
folders = [
    "data/raw",
    "data/processed",
    "data/exports",

    "python/config",
    "python/ingestion",
    "python/cleaning",
    "python/analysis",
    "python/validation",

    "notebooks",

    "sql",

    "alteryx/workflows",
    "alteryx/macros",
    "alteryx/output",

    "powerbi/screenshots",

    "reports",
    "tests",
    "logs",
]

# Project files
files = [
    # Python
    "python/config/config.py",
    "python/ingestion/load_data.py",

    "python/cleaning/clean_customers.py",
    "python/cleaning/clean_orders.py",
    "python/cleaning/clean_products.py",

    "python/analysis/sales_analysis.py",
    "python/analysis/customer_analysis.py",
    "python/analysis/product_analysis.py",
    "python/analysis/delivery_analysis.py",

    "python/validation/data_quality.py",
    "python/main.py",

    # Jupyter notebooks
    "notebooks/01_data_exploration.ipynb",
    "notebooks/02_data_cleaning.ipynb",
    "notebooks/03_exploratory_analysis.ipynb",

    # SQL Server
    "sql/01_database_creation.sql",
    "sql/02_table_creation.sql",
    "sql/03_data_loading.sql",
    "sql/04_data_quality_checks.sql",
    "sql/05_sales_analysis.sql",
    "sql/06_customer_analysis.sql",
    "sql/07_product_analysis.sql",
    "sql/08_advanced_queries.sql",
    "sql/09_views.sql",
    "sql/10_stored_procedures.sql",

    # Alteryx
    "alteryx/workflows/.gitkeep",
    "alteryx/macros/.gitkeep",
    "alteryx/output/.gitkeep",

    # Power BI
    "powerbi/dax_measures.md",
    "powerbi/screenshots/.gitkeep",

    # Reports
    "reports/sales_insights.md",
    "reports/business_recommendations.md",

    # Testing
    "tests/test_cleaning.py",
    "tests/test_validation.py",

    # Logs
    "logs/.gitkeep",

    # Root files
    "requirements.txt",
    ".env.example",
    ".gitignore",
    "README.md",
]

# Create directories
for folder in folders:
    (ROOT / folder).mkdir(parents=True, exist_ok=True)

# Create empty files without overwriting existing files
for filename in files:
    file_path = ROOT / filename
    file_path.parent.mkdir(parents=True, exist_ok=True)

    if not file_path.exists():
        file_path.touch()

print("\n" + "=" * 55)
print(" E-COMMERCE BUSINESS INTELLIGENCE PROJECT")
print("=" * 55)
print(f"Project location: {ROOT}")
print(f"Directories: {len(folders)}")
print(f"Files: {len(files)}")
print("STATUS: STRUCTURE CREATED SUCCESSFULLY")
print("=" * 55)
