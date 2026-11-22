# POS Sales ETL Pipeline & Daily Revenue Forecasting

An end-to-end data engineering and analytics project built on 12 months of coffee shop Point-of-Sale (POS) data (18,570 transactions).

## Architecture
**Excel (Raw POS Data)** → **Python (`pandas` + `SQLAlchemy`)** → **PostgreSQL (`stg` → `fact` → `mart`)** → **Jupyter & Scikit-Learn**

1. **Extract & Stage (`src/extract.py`)**: Ingests raw `.xlsx` POS records into a PostgreSQL staging table (`stg_pos_transactions`) using secure `.env` credentials and `URL.create()`.
2. **Transform (`sql/01_transform_fact_transactions.sql`)**: Uses SQL CTEs to cast timestamps and `NUMERIC` currency types, engineer calendar features, and flag 15 high-value bulk/catering orders (`total >= 500`) without distorting everyday order averages.
3. **Load Data Mart (`sql/02_build_mart_daily_sales.sql`)**: Aggregates daily KPIs (`mart_daily_sales`) using PostgreSQL `FILTER` clauses and Window Functions (`7-day rolling average` and `LAG` previous-day revenue).
4. **EDA & Forecasting (`notebooks/01_eda_and_forecasting.ipynb`)**: Visualizes revenue trends (identifying weekend closures and holiday gaps) and trains a `RandomForestRegressor` using a chronological 80/20 split.

## Key Engineering Highlights
- **Bulk Order Isolation**: Separated 15 bulk orders (avg `1,110.53`) from 18,555 regular transactions (avg `47.83`) via an `is_bulk_order` flag.
- **Data Leakage Prevention**: Caught and eliminated target leakage in the 7-day rolling average by shifting it (`prev_7d_avg_revenue`), moving from an inflated `424.20` MAE to an honest, production-realistic baseline of **`484.35` MAE**.

## Tech Stack
- **Python**: `pandas`, `openpyxl`, `SQLAlchemy`, `psycopg2`, `python-dotenv`, `matplotlib`, `scikit-learn`
- **Database**: PostgreSQL (CTEs, Window Functions, Conditional Aggregation)