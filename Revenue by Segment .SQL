-- CHAPTER 1: What do I want to see?
SELECT
    internetservice,              -- which internet type?
    paymentmethod,                -- which payment method?
    COUNT(*) AS total_customers,  -- how many customers?
    
    ROUND(AVG(monthlycharges), 2) 
        AS avg_mrr,               -- average revenue per customer
    
    ROUND(SUM(monthlycharges), 2) 
        AS total_mrr,             -- total monthly revenue
    
    ROUND(SUM(monthlycharges) * 12, 2) 
        AS total_arr,             -- total annual revenue
    
    SUM(CASE WHEN churn = 'Yes' 
        THEN 1 ELSE 0 
        END) AS churned_customers,-- count of churned customers
    
    ROUND(SUM(CASE WHEN churn = 'Yes' 
        THEN 1 ELSE 0 END) * 100.0 / 
        COUNT(*), 2) 
        AS churn_rate_pct,        -- churn as % of total
    
    ROUND(SUM(CASE WHEN churn = 'Yes' 
        THEN monthlycharges 
        ELSE 0 END) * 12, 2) 
        AS churned_arr            -- annual revenue lost

-- CHAPTER 2: Where is the data?
FROM customers

-- CHAPTER 3: How to group?
GROUP BY internetservice, paymentmethod  -- TWO columns!

-- CHAPTER 4: How to sort?
ORDER BY total_arr DESC;


