/*
Day 5 - Task 6: Customer segmentation by order frequency
Segments:
1 order = One-Time; 2-3 = Occasional; 4-5 = Frequent; 6+ = Loyal.
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
),
CustomerSegments AS
(
    SELECT
        customer_unique_id,
        TotalOrders,
        CASE
            WHEN TotalOrders = 1 THEN 'One-Time Customer'
            WHEN TotalOrders BETWEEN 2 AND 3 THEN 'Occasional Customer'
            WHEN TotalOrders BETWEEN 4 AND 5 THEN 'Frequent Customer'
            ELSE 'Loyal Customer'
        END AS CustomerSegment
    FROM CustomerOrders
)
SELECT
    CustomerSegment,
    COUNT(*) AS TotalCustomers,
    CAST(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS CustomerPercentage
FROM CustomerSegments
GROUP BY CustomerSegment
ORDER BY TotalCustomers DESC;
GO
