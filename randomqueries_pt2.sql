"I need a complete customer risk report.

I want every customer categorised into 
a risk segment based on their health score.

Segment them like this:
→ 0-40  = 'High Risk'
→ 41-70 = 'Moderate Risk'
→ 71-100 = 'Low Risk'

For each risk segment I need:
→ Total customers
→ Average health score
→ Total annual revenue
→ Total annual revenue at risk (churned)
→ Churn rate %
→ Order by highest risk first"





SELECT
*,
    CASE WHEN tenure BETWEEN 0 AND 12   THEN 10
         WHEN tenure BETWEEN 13 AND 24  THEN 20
         WHEN tenure BETWEEN 25 AND 48  THEN 30
         WHEN tenure BETWEEN 49 AND 72  THEN 40
    END +
    CASE WHEN monthlycharges < 30              THEN 10
         WHEN monthlycharges BETWEEN 30 AND 70 THEN 20
         WHEN monthlycharges > 70              THEN 30
    END +
    CASE WHEN contract = 'Two year'       THEN 30
         WHEN contract = 'One year'       THEN 20
         WHEN contract = 'Month-to-month' THEN 10
    END AS health_score
FROM customers;

CREATE VIEW Risk_Segmentation AS 
SELECT *, 
CASE WHEN health_score BETWEEN 0 AND 40 THEN 'High Risk'
     WHEN health_score BETWEEN 41 AND 70 THEN 'Moderate Risk'
	 WHEN health_score BETWEEN 71 AND 100 THEN 'Low Risk'
	 END AS Risk_Analysis
	 FROM customer_scores;

SELECT risk_analysis,
COUNT (*) AS Total_customers,
ROUND(AVG(health_score), 2) AS Average_healthscore,
ROUND(SUM(monthlycharges) * 12, 2) AS Total_AR,
ROUND(SUM(CASE WHEN churn = 'Yes' THEN monthlycharges ELSE 0 END) * 12 ,2) AS Churn_AR,
ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT (*), 2) AS Churn_pct
FROM risk_segmentation
GROUP BY risk_analysis
ORDER BY CASE
    WHEN risk_analysis = 'High Risk'     THEN 1
    WHEN risk_analysis = 'Moderate Risk' THEN 2
    WHEN risk_analysis = 'Low Risk'      THEN 3
END;

