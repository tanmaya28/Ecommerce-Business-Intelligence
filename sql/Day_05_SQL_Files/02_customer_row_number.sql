/*
Day 5 - Task 2: ROW_NUMBER customer ranking
Purpose: Rank customers by number of orders, assigning a unique row number.
*/
USE EcommerceBI;
GO

WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS TotalOrders
    FROM dbo.customers AS c
    INNER JOIN dbo.orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    TotalOrders,
    ROW_NUMBER() OVER
    (
        ORDER BY TotalOrders DESC, customer_unique_id
    ) AS RowNumber
FROM CustomerOrders
ORDER BY RowNumber;
GO
