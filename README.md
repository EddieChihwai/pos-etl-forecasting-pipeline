# POS ETL Pipeline & Daily Revenue Forecasting

An end-to-end **Extract → Load → Transform (ELT)** and analytics project built on Point-of-Sale (POS) transaction data (**See You Latte**, Oct 2025 – Oct 2026). Raw Excel exports are ingested into PostgreSQL with Python, transformed into analysis-ready fact and daily mart tables in SQL, and explored for revenue trends and forecasting in Jupyter.

---

## Architecture

```text
Excel POS Export (data/See_you_latte_oct_25_oct_26.xlsx)
        │
        ▼  src/extract.py (pandas + SQLAlchemy)
PostgreSQL Staging Table (stg_pos_transactions)
        │
        ▼  sql/01_transform_fact_transactions.sql
Cleaned Fact Table (fact_pos_transactions)
        │
        ▼  sql/02_build_mart_daily_sales.sql
Daily Sales Mart (mart_daily_sales)
        │
        ▼  notebooks/01_eda_and_forecasting.ipynb
EDA, Rolling Revenue Trends & Forecasting
```

---

## Tech Stack

- **Ingestion:** Python 3.14, `pandas`, `openpyxl`, `SQLAlchemy`, `psycopg2-binary`, `python-dotenv`
- **Warehouse & Transformations:** PostgreSQL (CTEs, type casting, feature engineering, window functions)
- **Analysis & Visualization:** Jupyter (`ipykernel`), `matplotlib`, `numpy`

---

## Project Structure

```text
pos-etl-project/
├── data/
│   └── See_you_latte_oct_25_oct_26.xlsx        # Raw POS transaction export
├── notebooks/
│   └── 01_eda_and_forecasting.ipynb            # Daily sales EDA & forecasting
├── sql/
│   ├── 01_transform_fact_transactions.sql      # Builds cleaned fact_pos_transactions
│   ├── 02_build_mart_daily_sales.sql           # Builds pre-aggregated mart_daily_sales
│   ├── check_duplicates.sql                    # Staging row vs. distinct order ID check
│   ├── check_trans_type.sql                    # Payment/transaction type distribution check
│   └── sanity_check.sql                        # Quick staging preview
├── src/
│   └── extract.py                              # Extracts Excel export into PostgreSQL staging
├── .env.example                                # Template for database credentials
├── .gitignore
├── requirements.txt                            # Pinned Python dependencies
└── README.md
```

---

## Setup & Usage

### 1. Create the virtual environment & install dependencies
```powershell
python -m venv venv
.\venv\Scripts\pip install -r requirements.txt
```

### 2. Configure database credentials
Copy `.env.example` to `.env` and fill in your PostgreSQL connection details:
```powershell
Copy-Item .env.example .env
```

### 3. Run the extraction script
```powershell
cd src
..\venv\Scripts\python.exe extract.py
```

### 4. Run SQL transformations & data quality checks
Execute the scripts in `sql/` against your PostgreSQL database in order:
1. Quality checks: `sanity_check.sql`, `check_duplicates.sql`, `check_trans_type.sql`
2. Fact table: `01_transform_fact_transactions.sql`
3. Daily sales mart: `02_build_mart_daily_sales.sql`

### 5. Run the EDA & forecasting notebook
Open `notebooks/01_eda_and_forecasting.ipynb` in VS Code / Jupyter and select the project's `venv` kernel (`Python (pos-etl-project)`).
