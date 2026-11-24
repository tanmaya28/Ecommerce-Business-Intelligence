/*
Day 5 - Task 4: Monthly revenue comparison using LAG and LEAD
Purpose: Compare each month with the previous and next available month.
Important: LAG/LEAD compare rows in the result set. Missing calendar months
are skipped, so this is previous/next available month, not always adjacent month.
Revenue is SUM(order_items.price), excluding canceled orders; freight excluded.
*/
USE EcommerceBI;
GO

WITH MonthlySales AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS SalesMonth,
        SUM(oi.price) AS MonthlyRevenue
    FROM dbo.orders AS o
    INNER JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status <> 'canceled'
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
),
RevenueComparison AS
(
    SELECT
        SalesMonth,
        MonthlyRevenue,
        LAG(MonthlyRevenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
        LEAD(MonthlyRevenue) OVER (ORDER BY SalesMonth) AS NextMonthRevenue
    FROM MonthlySales
)
SELECT
    SalesMonth,
    MonthlyRevenue,
    PreviousMonthRevenue,
    NextMonthRevenue,
    CAST(
        100.0 * (MonthlyRevenue - PreviousMonthRevenue)
        / NULLIF(PreviousMonthRevenue, 0)
        AS DECIMAL(10,2)
    ) AS ChangeVsPreviousAvailableMonthPct
FROM RevenueComparison
ORDER BY SalesMonth;
GO
