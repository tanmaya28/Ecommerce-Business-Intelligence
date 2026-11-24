/*
Day 5 - Task 3: RANK and DENSE_RANK customer ranking
Purpose: Compare ranking behavior when customers have the same order count.
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
    ) AS RowNumber,
    RANK() OVER
    (
        ORDER BY TotalOrders DESC
    ) AS CustomerRank,
    DENSE_RANK() OVER
    (
        ORDER BY TotalOrders DESC
    ) AS DenseCustomerRank
FROM CustomerOrders
ORDER BY TotalOrders DESC, customer_unique_id;
GO
