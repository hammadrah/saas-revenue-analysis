SELECT 
    internetservice,             
    paymentmethod,
	tenure,
    COUNT(*) AS total_customers,  
    
    ROUND(AVG(monthlycharges), 2) 
        AS avg_mrr,               
    
    ROUND(SUM(monthlycharges), 2) 
        AS total_mrr,             
    
    ROUND(SUM(monthlycharges) * 12, 2) 
        AS total_arr,            
    
    SUM(CASE WHEN churn = 'Yes' 
        THEN 1 ELSE 0 
        END) AS churned_customers,
    
    ROUND(SUM(CASE WHEN churn = 'Yes' 
        THEN 1 ELSE 0 END) * 100.0 / 
        COUNT(*), 2) 
        AS churn_rate_pct,        
    
    ROUND(SUM(CASE WHEN churn = 'Yes' 
        THEN monthlycharges 
        ELSE 0 END) * 12, 2) 
        AS churned_arr          

FROM customers
WHERE internetservice = 'Fiber optic' AND tenure <= '12'
GROUP BY internetservice, paymentmethod, tenure 
ORDER BY total_arr DESC;



SELECT internetservice, contract,
COUNT (*) AS TOTAL_CUSTOMERS,
ROUND (SUM (CASE WHEN contract = 'Month-to-month' THEN 1 ELSE 0 END))AS Total_Mtm
FROM customers
WHERE internetservice = 'Fiber optic' AND contract = 'Month-to-month'
GROUP BY internetservice, contract;


SELECT 
internetservice,
contract, 
COUNT (*) AS Total_customers,
FROM customers
WHERE contract = 'Month-to-month'
GROUP BY contract, internetservice;

SELECT 
internetservice,
tenure_band,
contract,
COUNT (*) AS Total_customers,
ROUND(AVG(monthlycharges), 2) AS avg_mrr,
 ROUND(SUM(monthlycharges)* 12, 2) 
        AS total_arr
FROM (
SELECT *,
CASE 
WHEN tenure BETWEEN 0 AND 12 THEN '0-12 Months'
END AS tenure_band
FROM customers)
AS tenure_groups
WHERE tenure_band = '0-12 Months' AND internetservice = 'Fiber optic' AND contract = 'Month-to-month'
GROUP BY tenure_band, internetservice, contract;

