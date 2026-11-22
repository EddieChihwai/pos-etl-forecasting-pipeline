SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM stg_pos_transactions;