SELECT 
    transaction_type, 
    COUNT(*) AS txn_count
FROM stg_pos_transactions
GROUP BY transaction_type;