-- sales_dashboard.sql
-- Consultas SQL genéricas para um dashboard comercial com dados sintéticos.
-- Ajuste nomes de tabelas/colunas conforme o seu ambiente anonimizado.

-- 1) Receita mensal, pedidos e ticket médio
SELECT
    DATE_TRUNC('month', o.order_date) AS month_ref,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS active_customers,
    SUM(o.gross_amount) AS gross_revenue,
    SUM(o.net_amount) AS net_revenue,
    ROUND(SUM(o.net_amount) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS average_ticket
FROM fact_order o
WHERE o.order_date >= DATE_TRUNC('year', CURRENT_DATE)
  AND o.order_status IN ('PAID', 'INVOICED', 'DELIVERED')
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month_ref;

-- 2) Conversão por etapa de funil
WITH funnel AS (
    SELECT 'visit' AS step_name, COUNT(DISTINCT session_id) AS total_events FROM fact_web_event WHERE event_type = 'VISIT'
    UNION ALL
    SELECT 'lead' AS step_name, COUNT(DISTINCT lead_id) AS total_events FROM fact_lead WHERE created_at >= CURRENT_DATE - INTERVAL '90 days'
    UNION ALL
    SELECT 'proposal' AS step_name, COUNT(DISTINCT proposal_id) AS total_events FROM fact_proposal WHERE created_at >= CURRENT_DATE - INTERVAL '90 days'
    UNION ALL
    SELECT 'sale' AS step_name, COUNT(DISTINCT order_id) AS total_events FROM fact_order WHERE order_date >= CURRENT_DATE - INTERVAL '90 days'
)
SELECT
    step_name,
    total_events,
    ROUND(total_events * 100.0 / NULLIF(MAX(total_events) OVER (), 0), 2) AS conversion_from_top_pct
FROM funnel
ORDER BY CASE step_name
    WHEN 'visit' THEN 1
    WHEN 'lead' THEN 2
    WHEN 'proposal' THEN 3
    WHEN 'sale' THEN 4
END;

-- 3) Receita por canal e região
SELECT
    COALESCE(c.channel_name, 'nao_informado') AS channel_name,
    COALESCE(r.region_name, 'nao_informado') AS region_name,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(o.net_amount) AS net_revenue,
    ROUND(AVG(o.margin_pct), 2) AS avg_margin_pct
FROM fact_order o
LEFT JOIN dim_channel c ON c.channel_id = o.channel_id
LEFT JOIN dim_region r ON r.region_id = o.region_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY COALESCE(c.channel_name, 'nao_informado'), COALESCE(r.region_name, 'nao_informado')
ORDER BY net_revenue DESC;

-- 4) Retenção mensal simples por coorte
WITH first_purchase AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS cohort_month
    FROM fact_order
    WHERE order_status IN ('PAID', 'INVOICED', 'DELIVERED')
    GROUP BY customer_id
), customer_activity AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', order_date) AS activity_month
    FROM fact_order
    WHERE order_status IN ('PAID', 'INVOICED', 'DELIVERED')
)
SELECT
    fp.cohort_month,
    ca.activity_month,
    (EXTRACT(YEAR FROM ca.activity_month) - EXTRACT(YEAR FROM fp.cohort_month)) * 12
        + (EXTRACT(MONTH FROM ca.activity_month) - EXTRACT(MONTH FROM fp.cohort_month)) AS months_after_first_purchase,
    COUNT(DISTINCT ca.customer_id) AS retained_customers
FROM first_purchase fp
JOIN customer_activity ca ON ca.customer_id = fp.customer_id
WHERE ca.activity_month >= fp.cohort_month
GROUP BY fp.cohort_month, ca.activity_month
ORDER BY fp.cohort_month, ca.activity_month;
