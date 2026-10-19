-- Month-over-month revenue growth (window function LAG)
WITH monthly AS (
    SELECT strftime('%Y-%m', InvoiceDate) AS month,
           SUM(Revenue)                   AS revenue
    FROM transactions
    GROUP BY month
)
SELECT month,
       ROUND(revenue, 0)                                        AS revenue,
       ROUND(LAG(revenue) OVER (ORDER BY month), 0)             AS prev_month_revenue,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 1)           AS growth_pct
FROM monthly
ORDER BY month;
