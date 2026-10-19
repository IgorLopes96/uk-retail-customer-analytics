-- Top 3 customers by revenue in each of the 5 largest non-UK markets (CTE + RANK)
WITH customer_revenue AS (
    SELECT Country, CustomerID, SUM(Revenue) AS revenue
    FROM transactions
    GROUP BY Country, CustomerID
),
top_markets AS (
    SELECT Country
    FROM transactions
    WHERE Country <> 'United Kingdom'
    GROUP BY Country
    ORDER BY SUM(Revenue) DESC
    LIMIT 5
),
ranked AS (
    SELECT cr.*,
           RANK() OVER (PARTITION BY cr.Country ORDER BY cr.revenue DESC) AS country_rank,
           ROUND(100.0 * cr.revenue / SUM(cr.revenue) OVER (PARTITION BY cr.Country), 1) AS pct_of_country
    FROM customer_revenue cr
    JOIN top_markets tm ON tm.Country = cr.Country
)
SELECT Country, CustomerID, ROUND(revenue, 0) AS revenue, pct_of_country, country_rank
FROM ranked
WHERE country_rank <= 3
ORDER BY Country, country_rank;
