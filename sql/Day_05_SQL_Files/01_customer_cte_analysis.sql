/*
Day 5 - Task 1: CTE-based customer repeat-purchase analysis
Purpose: Count orders per actual customer identity and summarize order frequency.
Note: customer_unique_id identifies a customer; customer_id is order-specific.
*/
USE EcommerceBI;
GO

WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS TotalOrders
    FROM dbo.customers AS c
    INNER JOIN dbo.orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    TotalOrders,
    COUNT(*) AS TotalCustomers
FROM CustomerOrders
GROUP BY TotalOrders
ORDER BY TotalOrders;
GO

-- Optional: overall one-time and repeat-customer summary.
WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS TotalOrders
    FROM dbo.customers AS c
    INNER JOIN dbo.orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN TotalOrders = 1 THEN 1 ELSE 0 END) AS OneTimeCustomers,
    SUM(CASE WHEN TotalOrders > 1 THEN 1 ELSE 0 END) AS RepeatCustomers,
    CAST(
        100.0 * SUM(CASE WHEN TotalOrders > 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS RepeatCustomerPercentage
FROM CustomerOrders;
GO
