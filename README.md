# E-Commerce Business Intelligence & Sales Analytics

An end-to-end E-Commerce Business Intelligence and Data Analytics project using the Brazilian E-Commerce Public Dataset by Olist. This project focuses on transforming raw e-commerce data into structured, reliable datasets and generating actionable business insights using Python, SQL Server, Alteryx and Power BI.

## Project Overview

E-commerce businesses generate large volumes of data across customers, orders, products, payments, sellers and customer reviews.

The objective of this project is to build an end-to-end analytics solution that processes raw transactional data, performs data quality checks, analyzes business performance and develops interactive dashboards to support data-driven decision-making.

The project follows a practical business intelligence workflow, from data ingestion and database management to exploratory analysis, reporting and visualization.

## Business Objectives

- Analyze overall sales and revenue performance.
- Identify top-performing product categories and sellers.
- Understand customer purchasing behavior.
- Evaluate order delivery performance.
- Analyze payment methods and installment patterns.
- Monitor customer satisfaction through review scores.
- Identify business trends and opportunities for improvement.

## Technology Stack

| Category | Technologies |
|---|---|
| Programming | Python 3.12 |
| Data Manipulation | Pandas, NumPy |
| Data Visualization | Matplotlib, Seaborn, Plotly |
| Database | Microsoft SQL Server 2022 |
| Database Connectivity | SQLAlchemy, PyODBC |
| Data Preparation | Alteryx |
| Business Intelligence | Power BI, DAX |
| Development | VS Code, Jupyter Notebook |
| Version Control | Git, GitHub |
| Cloud | AWS (planned integration) |

## Dataset

**Brazilian E-Commerce Public Dataset by Olist**

Source: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

The dataset contains approximately 100,000 orders from a Brazilian e-commerce marketplace, with information about customers, products, sellers, payments, reviews and delivery.

### Dataset Tables

| Dataset | Description |
|---|---|
| Customers | Customer information and location |
| Orders | Order status and timestamps |
| Order Items | Products purchased in each order |
| Products | Product attributes and categories |
| Sellers | Seller information and location |
| Order Payments | Payment types and amounts |
| Order Reviews | Customer review scores and comments |
| Geolocation | Brazilian geographical coordinates |
| Product Category Translation | Portuguese-to-English category mapping |

## Project Architecture

```text
Raw CSV Datasets
       |
       v
Python ETL Pipeline
       |
       +--> File Validation
       +--> Chunk-Based CSV Reading
       +--> Data Type Conversion
       +--> Column Standardization
       +--> Execution Logging
       |
       v
Microsoft SQL Server
       |
       v
Data Quality Assessment
       |
       v
Exploratory Data Analysis
       |
       v
Alteryx Data Workflows
       |
       v
Power BI Dashboards
       |
       v
Business Insights & Reporting
```

## Repository Structure

```text
Brazilian_E-Commerce_Public_Dataset_by_Olist/
│
├── data/
│   ├── raw/
│   ├── processed/
│   └── exports/
│
├── python/
│   ├── config/
│   ├── ingestion/
│   ├── cleaning/
│   ├── analysis/
│   └── validation/
│
├── notebooks/
│
├── sql/
│
├── alteryx/
│   ├── workflows/
│   ├── macros/
│   └── output/
│
├── powerbi/
│   └── screenshots/
│
├── reports/
├── tests/
├── logs/
│
├── requirements.txt
├── .env.example
├── .gitignore
└── README.md
```

## Implementation Progress

### Phase 1: Data Engineering & ETL — Completed

- Downloaded and organized all nine Olist CSV datasets.
- Created the SQL Server database and nine relational tables.
- Configured Python-to-SQL Server connectivity.
- Developed a Python ETL pipeline using Pandas and SQLAlchemy.
- Implemented chunk-based CSV ingestion.
- Converted date columns and standardized column names.
- Added destination-table validation to prevent duplicate loading.
- Implemented execution logging and exception handling.
- Successfully loaded and validated 1,550,922 records across nine tables.

### Phase 2: Data Quality Assessment & EDA — Planned

- Missing-value analysis.
- Duplicate record detection.
- Primary key and foreign key validation.
- Date and timestamp consistency checks.
- Outlier detection.
- Exploratory data analysis.
- Automated data quality reporting.

### Phase 3: SQL Business Analysis — Planned

- Advanced SQL queries.
- Joins, CTEs and window functions.
- Revenue and sales trend analysis.
- Customer segmentation.
- Product and seller performance.
- Delivery and payment analysis.

### Phase 4: Alteryx Workflows — Planned

- Data preparation and transformation.
- Workflow automation.
- Data blending and aggregation.
- Reusable macros.
- Analytical output generation.

### Phase 5: Power BI Dashboards — Planned

- Executive Sales Dashboard.
- Customer Analytics Dashboard.
- Product and Seller Performance Dashboard.
- Order and Delivery Performance Dashboard.
- DAX measures and KPI reporting.

### Phase 6: Cloud Integration — Planned

- AWS S3 for data storage.
- AWS services for future analytics integration.

## Key Business KPIs

The project aims to analyze the following metrics:

- Total Revenue
- Total Orders
- Average Order Value (AOV)
- Total Customers
- Revenue Growth
- Average Review Score
- Order Cancellation Rate
- On-Time Delivery Rate
- Top Product Categories
- Top Performing Sellers

## How to Run the Project

### 1. Clone the repository

```bash
git clone https://github.com/tanmaya28/Ecommerce-Business-Intelligence.git
```

### 2. Navigate to the project

```bash
cd Ecommerce-Business-Intelligence
```

### 3. Create a virtual environment

```bash
python -m venv .venv
```

### 4. Activate the environment (Windows PowerShell)

```powershell
.\.venv\Scripts\Activate.ps1
```

### 5. Install dependencies

```bash
python -m pip install -r requirements.txt
```

### 6. Configure SQL Server

Create a `.env` file in the project root using `.env.example` as a template.

Configure your SQL Server connection details:

```text
DB_SERVER=YOUR_SERVER_NAME
DB_NAME=EcommerceBI
DB_DRIVER=ODBC Driver 18 for SQL Server
```

Update the configuration according to your SQL Server installation.

### 7. Create database and tables

Execute the SQL scripts available in the `sql/` directory using SQL Server Management Studio.

### 8. Add the dataset

Download the Olist dataset from Kaggle and place the nine CSV files inside:

```text
data/raw/
```

### 9. Run the ETL pipeline

From the project root:

```bash
python -m python.ingestion.load_data
```

**Note:** The ETL pipeline checks whether destination tables already contain records. Do not run it again against an already populated database unless you intentionally rebuild the database.

## Project Status

This project is being developed as a hands-on portfolio project to demonstrate practical data analytics, data engineering and business intelligence skills.

The implementation is progressing phase by phase.

## Author

**Tanmaya Raj Behera**

Aspiring Data Analyst | Data Science & Machine Learning Enthusiast

GitHub: https://github.com/tanmaya28

---

**Disclaimer:** This is an independent portfolio project using publicly available data from Olist. It is not affiliated with or endorsed by Olist.
