SELECT
    tenure_band,
    COUNT(*) AS total_customers,
    ROUND(SUM(monthlycharges), 2) AS total_mrr,
    ROUND(SUM(CASE WHEN churn = 'No' THEN monthlycharges ELSE 0 END), 2) AS retained_mrr,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN monthlycharges ELSE 0 END), 2) AS churned_mrr,
    ROUND(SUM(CASE WHEN churn = 'No' THEN monthlycharges ELSE 0 END) * 100.0 / 
    SUM(SUM(monthlycharges)) OVER(), 2) AS retained_revenue_share_pct
FROM (
    SELECT *,
        CASE 
            WHEN tenure BETWEEN 0 AND 12 THEN '0-12 Months'
            WHEN tenure BETWEEN 13 AND 24 THEN '13-24 Months'
            WHEN tenure BETWEEN 25 AND 48 THEN '25-48 Months'
            WHEN tenure BETWEEN 49 AND 72 THEN '49-72 Months'
        END AS tenure_band
    FROM customers
) AS tenure_groups
GROUP BY tenure_band
ORDER BY tenure_band;