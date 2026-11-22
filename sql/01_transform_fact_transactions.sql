-- 1. Make the script idempotent (safe to re-run without errors)
DROP TABLE IF EXISTS fact_pos_transactions;

-- 2. Build the cleaned, analysis-ready fact table
CREATE TABLE fact_pos_transactions AS

WITH parsed_data AS (
    -- STEP A: Clean types and standardize text
    SELECT
        order_id,
        CAST(raw_date_time AS TIMESTAMP) AS order_timestamp,
        TRIM(transaction_type)           AS transaction_type,
        CAST(total AS NUMERIC(10, 2))    AS total_amount
    FROM stg_pos_transactions
    WHERE order_id IS NOT NULL
      AND total > 0
),

enriched_data AS (
    -- STEP B: Engineer time features & business flags
    SELECT
        order_id,
        order_timestamp,
        CAST(order_timestamp AS DATE)                  AS order_date,
        EXTRACT(YEAR FROM order_timestamp)::INT        AS order_year,
        EXTRACT(MONTH FROM order_timestamp)::INT       AS order_month,
        TO_CHAR(order_timestamp, 'Day')                AS day_of_week,
        EXTRACT(HOUR FROM order_timestamp)::INT        AS order_hour,
        transaction_type,
        total_amount,
        CASE
            WHEN total_amount >= 500 THEN TRUE
            ELSE FALSE
        END                                            AS is_bulk_order
    FROM parsed_data
)

-- STEP C: Final output written into fact_pos_transactions
SELECT *
FROM enriched_data;