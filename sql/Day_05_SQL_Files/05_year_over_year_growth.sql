/*
Day 5 - Task 5: Year-over-year revenue growth
Purpose: Compare revenue with the same calendar month in the previous year.
A self-join on year and month handles missing months correctly.
*/
USE EcommerceBI;
GO

WITH MonthlySales AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS SalesYear,
        MONTH(o.order_purchase_timestamp) AS SalesMonth,
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
    current_year.SalesYear,
    current_year.SalesMonth,
    current_year.MonthlyRevenue,
    previous_year.MonthlyRevenue AS PreviousYearRevenue,
    CAST(
        100.0 * (
            current_year.MonthlyRevenue - previous_year.MonthlyRevenue
        ) / NULLIF(previous_year.MonthlyRevenue, 0)
        AS DECIMAL(10,2)
    ) AS YoYGrowthPercentage
FROM MonthlySales AS current_year
LEFT JOIN MonthlySales AS previous_year
    ON current_year.SalesYear = previous_year.SalesYear + 1
    AND current_year.SalesMonth = previous_year.SalesMonth
ORDER BY
    current_year.SalesYear,
    current_year.SalesMonth;
GO
