-- RFM features per customer in SQL (reference date = day after last invoice)
SELECT CustomerID,
       CAST(julianday((SELECT DATE(MAX(InvoiceDate), '+1 day') FROM transactions))
            - julianday(MAX(InvoiceDate)) AS INTEGER) AS recency_days,
       COUNT(DISTINCT InvoiceNo)                     AS frequency,
       ROUND(SUM(Revenue), 2)                        AS monetary
FROM transactions
GROUP BY CustomerID
ORDER BY monetary DESC
LIMIT 10;
