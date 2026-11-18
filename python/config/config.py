import os
from urllib.parse import quote_plus

from dotenv import load_dotenv
from sqlalchemy import create_engine

# Load environment variables
PROJECT_ROOT = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "../../")
)

load_dotenv(os.path.join(PROJECT_ROOT, ".env"))

DB_SERVER = os.getenv("DB_SERVER", r"MSI\SQLEXPRESS")
DB_NAME = os.getenv("DB_NAME", "EcommerceBI")
DB_DRIVER = os.getenv(
    "DB_DRIVER",
    "ODBC Driver 18 for SQL Server"
)

connection_string = (
    f"DRIVER={{{DB_DRIVER}}};"
    f"SERVER={DB_SERVER};"
    f"DATABASE={DB_NAME};"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)

connection_url = (
    "mssql+pyodbc:///?odbc_connect="
    + quote_plus(connection_string)
)

engine = create_engine(connection_url)

def test_connection():
    try:
        with engine.connect() as connection:
            result = connection.exec_driver_sql(
                "SELECT DB_NAME()"
            )
            print("Connected successfully!")
            print("Database:", result.scalar())
    except Exception as error:
        print("Database connection failed:")
        print(error)


if __name__ == "__main__":
    test_connection()
