--Payment method analysis--

SELECT
    COUNT(*) AS TotalDeliveredOrders,

    SUM(
        CASE
            WHEN order_delivered_customer_date
                 <= order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS OnTimeDeliveries,

    SUM(
        CASE
            WHEN order_delivered_customer_date
                 > order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS LateDeliveries,

    CAST(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date
                     <= order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS OnTimeDeliveryPercentage

FROM dbo.orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
GO

--Delivery performance analysis--

SELECT
    c.customer_state AS CustomerState,

    COUNT(o.order_id) AS TotalDeliveredOrders,

    SUM(
        CASE
            WHEN o.order_delivered_customer_date
                 > o.order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS LateDeliveries,

    CAST(
        100.0 * SUM(
            CASE
                WHEN o.order_delivered_customer_date
                     > o.order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(o.order_id), 0)
        AS DECIMAL(10,2)
    ) AS LateDeliveryPercentage

FROM dbo.orders o
INNER JOIN dbo.customers c
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY c.customer_state

ORDER BY LateDeliveryPercentage DESC;
GO

--Identify states with the highest delivery delays--

SELECT
    c.customer_state AS CustomerState,

    COUNT(o.order_id) AS LateOrders,

    CAST(
        AVG(
            CAST(
                DATEDIFF(
                    DAY,
                    o.order_estimated_delivery_date,
                    o.order_delivered_customer_date
                ) AS FLOAT
            )
        ) AS DECIMAL(10,2)
    ) AS AverageDelayDays,

    MAX(
        DATEDIFF(
            DAY,
            o.order_estimated_delivery_date,
            o.order_delivered_customer_date
        )
    ) AS MaximumDelayDays

FROM dbo.orders o
INNER JOIN dbo.customers c
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
  AND o.order_delivered_customer_date
      > o.order_estimated_delivery_date

GROUP BY c.customer_state

ORDER BY AverageDelayDays DESC;
GO