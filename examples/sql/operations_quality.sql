-- operations_quality.sql
-- Consultas SQL genéricas para indicadores operacionais e qualidade de atendimento.

-- 1) Cumprimento de SLA por fila e prioridade
SELECT
    queue_name,
    priority_level,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolved_at <= sla_due_at THEN 1 ELSE 0 END) AS tickets_within_sla,
    ROUND(SUM(CASE WHEN resolved_at <= sla_due_at THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS sla_compliance_pct
FROM fact_ticket
WHERE created_at >= CURRENT_DATE - INTERVAL '6 months'
  AND ticket_status IN ('RESOLVED', 'CLOSED')
GROUP BY queue_name, priority_level
ORDER BY queue_name, priority_level;

-- 2) Aging de tickets em aberto
SELECT
    queue_name,
    CASE
        WHEN CURRENT_DATE - CAST(created_at AS DATE) <= 2 THEN '0-2 dias'
        WHEN CURRENT_DATE - CAST(created_at AS DATE) <= 7 THEN '3-7 dias'
        WHEN CURRENT_DATE - CAST(created_at AS DATE) <= 15 THEN '8-15 dias'
        ELSE '16+ dias'
    END AS aging_bucket,
    COUNT(*) AS open_tickets
FROM fact_ticket
WHERE ticket_status NOT IN ('RESOLVED', 'CLOSED', 'CANCELLED')
GROUP BY queue_name,
    CASE
        WHEN CURRENT_DATE - CAST(created_at AS DATE) <= 2 THEN '0-2 dias'
        WHEN CURRENT_DATE - CAST(created_at AS DATE) <= 7 THEN '3-7 dias'
        WHEN CURRENT_DATE - CAST(created_at AS DATE) <= 15 THEN '8-15 dias'
        ELSE '16+ dias'
    END
ORDER BY queue_name, aging_bucket;

-- 3) Nota média de satisfação por mês
SELECT
    DATE_TRUNC('month', response_date) AS month_ref,
    COUNT(*) AS total_responses,
    ROUND(AVG(score), 2) AS avg_score,
    ROUND(SUM(CASE WHEN score >= 9 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS promoters_pct,
    ROUND(SUM(CASE WHEN score <= 6 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS detractors_pct
FROM fact_satisfaction_survey
WHERE response_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY DATE_TRUNC('month', response_date)
ORDER BY month_ref;
