-- sql/create_customer_agg.sql (SQLite-safe, single-table)
DROP TABLE IF EXISTS customer_agg;
CREATE TABLE customer_agg AS
SELECT rowid AS customer_id,
       age,
       AVG("Credit amount") AS avg_prev_loan_amount,
       1 AS n_prev_loans,
       0 AS n_past_due,
       0 AS max_days_past_due,
       ("Credit amount" * 1.0) / ("Credit amount" + 1000.0) AS utilization,
       (ABS(RANDOM()) % 50001) + 30000 AS income,
       0 AS target_default
FROM applications;