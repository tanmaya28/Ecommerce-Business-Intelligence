USE EcommerceBI;
GO

CREATE OR ALTER VIEW dbo.vw_OrderSummary
AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    DATEDIFF(
        DAY,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date
    ) AS DeliveryDays
FROM dbo.orders o;
GO

SELECT TOP 20 *
FROM dbo.vw_OrderSummary;

CREATE OR ALTER VIEW dbo.vw_OrderRevenue
AS
SELECT
    order_id,
    COUNT(*) AS TotalItems,
    SUM(price) AS ProductRevenue,
    SUM(freight_value) AS TotalFreight
FROM dbo.order_items
GROUP BY order_id;
GO

SELECT TOP 20 *
FROM dbo.vw_OrderRevenue
ORDER BY ProductRevenue DESC;