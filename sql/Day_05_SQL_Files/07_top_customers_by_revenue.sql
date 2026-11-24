/*
Day 5 - Task 7: Top 20 customers by product revenue
Revenue = SUM(order_items.price), excluding canceled orders.
AverageItemPrice is the average item price, not average order value.
*/
USE EcommerceBI;
GO

WITH CustomerRevenue AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS TotalOrders,
        SUM(oi.price) AS TotalRevenue,
        AVG(oi.price) AS AverageItemPrice
    FROM dbo.customers AS c
    INNER JOIN dbo.orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status <> 'canceled'
    GROUP BY c.customer_unique_id
),
CustomerRanking AS
(
    SELECT
        customer_unique_id,
        TotalOrders,
        TotalRevenue,
        AverageItemPrice,
        DENSE_RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank
    FROM CustomerRevenue
)
SELECT TOP (20)
    customer_unique_id,
    TotalOrders,
    CAST(TotalRevenue AS DECIMAL(12,2)) AS TotalRevenue,
    CAST(AverageItemPrice AS DECIMAL(10,2)) AS AverageItemPrice,
    RevenueRank
FROM CustomerRanking
ORDER BY RevenueRank, customer_unique_id;
GO
