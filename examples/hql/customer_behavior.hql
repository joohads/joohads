-- customer_behavior.hql
-- Exemplos HQL/JPQL genéricos para comportamento de clientes.

-- 1) Clientes ativos por segmento nos últimos 90 dias
SELECT
    customer.segment AS segment,
    COUNT(DISTINCT customer.id) AS activeCustomers,
    SUM(order.netAmount) AS netRevenue
FROM OrderEntity order
JOIN order.customer customer
WHERE order.orderDate >= :startDate
  AND order.status IN (:validStatuses)
GROUP BY customer.segment
ORDER BY netRevenue DESC

-- 2) Produtos mais comprados por clientes recorrentes
SELECT
    product.category AS category,
    product.name AS productName,
    COUNT(DISTINCT order.id) AS totalOrders,
    SUM(item.quantity) AS totalQuantity
FROM OrderItemEntity item
JOIN item.order order
JOIN item.product product
JOIN order.customer customer
WHERE customer.totalOrders >= :minimumOrders
  AND order.orderDate BETWEEN :startDate AND :endDate
GROUP BY product.category, product.name
ORDER BY totalQuantity DESC

-- 3) Engajamento por canal de comunicação
SELECT
    event.channel AS channel,
    event.eventType AS eventType,
    COUNT(event.id) AS totalEvents,
    COUNT(DISTINCT event.customer.id) AS impactedCustomers
FROM CustomerEventEntity event
WHERE event.eventDate >= :startDate
  AND event.eventType IN (:trackedEvents)
GROUP BY event.channel, event.eventType
ORDER BY event.channel, totalEvents DESC
