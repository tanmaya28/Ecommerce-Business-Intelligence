-- Total orders
SELECT COUNT(*) AS TotalOrders
FROM dbo.orders;

-- Orders by status
SELECT
    order_status,
    COUNT(*) AS OrderCount
FROM dbo.orders
GROUP BY order_status
ORDER BY OrderCount DESC;

-- Total product revenue
SELECT
    SUM(price) AS TotalProductRevenue
FROM dbo.order_items;

-- Monthly orders
SELECT
    YEAR(order_purchase_timestamp) AS OrderYear,
    MONTH(order_purchase_timestamp) AS OrderMonth,
    COUNT(*) AS TotalOrders
FROM dbo.orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY OrderYear, OrderMonth;