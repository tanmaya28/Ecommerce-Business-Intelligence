/*
Day 5 - Task 8: Customer value segmentation
VIP: revenue >= 5000 and at least 2 orders
High Value: revenue >= 2000
Regular: revenue >= 500
Low Value: revenue < 500
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
)
SELECT
    CustomerSegment,
    COUNT(*) AS TotalCustomers,
    CAST(SUM(TotalRevenue) AS DECIMAL(15,2)) AS SegmentRevenue,
    CAST(AVG(TotalRevenue) AS DECIMAL(12,2)) AS AverageCustomerRevenue
FROM CustomerSegments
GROUP BY CustomerSegment
ORDER BY SegmentRevenue DESC;
GO
