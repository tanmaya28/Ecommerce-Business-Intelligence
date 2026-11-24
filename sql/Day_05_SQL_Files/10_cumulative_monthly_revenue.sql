/*
Day 5 - Task 10: Cumulative monthly revenue
Purpose: Calculate the running total of monthly product revenue.
Months absent from the source data do not appear as rows in this result.
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
)
SELECT
    SalesMonth,
    CAST(MonthlyRevenue AS DECIMAL(15,2)) AS MonthlyRevenue,
    CAST(
        SUM(MonthlyRevenue) OVER
        (
            ORDER BY SalesMonth
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
        AS DECIMAL(15,2)
    ) AS CumulativeRevenue
FROM MonthlySales
ORDER BY SalesMonth;
GO
