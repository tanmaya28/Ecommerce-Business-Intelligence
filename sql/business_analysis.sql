USE EcommerceBI;
GO

SELECT TOP 100
    o.order_id,
    o.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp
FROM dbo.orders o
INNER JOIN dbo.customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_purchase_timestamp DESC;
GO

--Product category revenue--

SELECT
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS TotalOrders,
    COUNT(*) AS TotalItems,
    SUM(oi.price) AS ProductRevenue,
    SUM(oi.freight_value) AS FreightRevenue
FROM dbo.order_items oi
INNER JOIN dbo.products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_category_name
ORDER BY
    ProductRevenue DESC;
GO

--Monthly sales performance--

SELECT
    YEAR(o.order_purchase_timestamp) AS SalesYear,
    MONTH(o.order_purchase_timestamp) AS SalesMonth,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    SUM(oi.price) AS ProductRevenue
FROM dbo.orders o
INNER JOIN dbo.order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    SalesYear,
    SalesMonth;
GO

--Customer and payment analysis--
--Top 10 customers--

SELECT TOP 10
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    COUNT(DISTINCT c.customer_id) AS TotalCustomers
FROM dbo.customers c
INNER JOIN dbo.orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY TotalOrders DESC;
GO

--Payments Method Analysis--

SELECT
    payment_type,
    COUNT(*) AS PaymentTransactions,
    SUM(payment_value) AS TotalPaymentValue,
    AVG(payment_value) AS AveragePaymentValue
FROM dbo.order_payments
GROUP BY payment_type
ORDER BY TotalPaymentValue DESC;
GO

--Average order value (AOV)--

WITH OrderRevenue AS
(
    SELECT
        order_id,
        SUM(price) AS OrderRevenue
    FROM dbo.order_items
    GROUP BY order_id
)
SELECT
    COUNT(*) AS TotalOrders,
    SUM(OrderRevenue) AS TotalRevenue,
    AVG(OrderRevenue) AS AverageOrderValue
FROM OrderRevenue;
GO

