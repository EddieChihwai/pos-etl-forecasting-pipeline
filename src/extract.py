import os
from dotenv import load_dotenv
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL  # <-- Add this import

# --- JOB 1: Load credentials & build the database connection ---
load_dotenv()

connection_url = URL.create(
    drivername="postgresql+psycopg2",
    username=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=int(os.getenv("DB_PORT", 5432)),
    database=os.getenv("DB_NAME"),
)

engine = create_engine(connection_url)

# --- JOB 2: Extract the raw Excel file ---
file_path = "../data/See_you_latte_oct_25_oct_26.xlsx"
df_raw = pd.read_excel(file_path, sheet_name=0)

# Rename columns to SQL-friendly snake_case (no spaces or special chars)
df_raw = df_raw.rename(
    columns={
        "Date & Time": "raw_date_time",
        "Order ID": "order_id",
        "Transaction type": "transaction_type",
        "Total": "total",
    }
)

# --- JOB 3: Load into PostgreSQL staging table ---
df_raw.to_sql(
    name="stg_pos_transactions",
    con=engine,
    if_exists="replace",  # Full extraction: overwrites staging table each run
    index=False,  # Don't save Pandas' 0,1,2... row index as a SQL column
)

print(f"Success! Loaded {len(df_raw)} rows into stg_pos_transactions.")