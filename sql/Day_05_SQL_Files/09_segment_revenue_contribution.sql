/*
Day 5 - Task 9: Revenue contribution by customer segment
Purpose: Calculate each segment's share of total product revenue.
*/
USE EcommerceBI;
GO

WITH CustomerRevenue AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS TotalOrders,
        SUM(oi.price) AS TotalRevenue
    FROM dbo.customers AS c
    INNER JOIN dbo.orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status <> 'canceled'
    GROUP BY c.customer_unique_id
),
CustomerSegments AS
(
    SELECT
        customer_unique_id,
        TotalOrders,
        TotalRevenue,
        CASE
            WHEN TotalRevenue >= 5000 AND TotalOrders >= 2 THEN 'VIP'
            WHEN TotalRevenue >= 2000 THEN 'High Value'
            WHEN TotalRevenue >= 500 THEN 'Regular'
            ELSE 'Low Value'
        END AS CustomerSegment
    FROM CustomerRevenue
),
SegmentRevenue AS
(
    SELECT
        CustomerSegment,
        COUNT(*) AS TotalCustomers,
        SUM(TotalRevenue) AS TotalRevenue
    FROM CustomerSegments
    GROUP BY CustomerSegment
)
SELECT
    CustomerSegment,
    TotalCustomers,
    CAST(TotalRevenue AS DECIMAL(15,2)) AS TotalRevenue,
    CAST(
        100.0 * TotalRevenue / SUM(TotalRevenue) OVER ()
        AS DECIMAL(10,2)
    ) AS RevenueContributionPercentage
FROM SegmentRevenue
ORDER BY TotalRevenue DESC;
GO
