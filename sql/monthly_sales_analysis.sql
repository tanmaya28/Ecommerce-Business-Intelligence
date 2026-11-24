USE EcommerceBI;
GO
--Calculate monthly average order value--

SELECT
    YEAR(o.order_purchase_timestamp) AS SalesYear,
    MONTH(o.order_purchase_timestamp) AS SalesMonth,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    SUM(oi.price) AS MonthlyRevenue,
    CAST(
        SUM(oi.price) /
        NULLIF(COUNT(DISTINCT o.order_id), 0)
        AS DECIMAL(18,2)
    ) AS AverageOrderValue
FROM dbo.orders o
INNER JOIN dbo.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status <> 'canceled'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    SalesYear,
    SalesMonth;
GO

--Visualize monthly revenue--

SELECT
    FORMAT(o.order_purchase_timestamp, 'yyyy-MM') AS SalesMonth,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    SUM(oi.price) AS MonthlyRevenue
FROM dbo.orders o
INNER JOIN dbo.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status <> 'canceled'
GROUP BY FORMAT(o.order_purchase_timestamp, 'yyyy-MM')
ORDER BY SalesMonth;

