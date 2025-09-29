-- Replace table/column names with your schema.

-- 1) Average resolution time (in hours) per agent
SELECT
  agent_id,
  COUNT(*) AS tickets,
  ROUND(AVG(EXTRACT(EPOCH FROM (resolved_at - created_at)) / 3600.0), 2) AS avg_resolution_hours
FROM tickets
WHERE resolved_at IS NOT NULL
GROUP BY agent_id
ORDER BY avg_resolution_hours ASC;

-- 2) Top 10 recurring issues by category (last 30 days)
SELECT
  category,
  COUNT(*) AS occurrences
FROM tickets
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY category
ORDER BY occurrences DESC
LIMIT 10;

-- 3) Customers with churn risk indicators
-- Example: 3+ tickets in last 60 days AND last ticket tagged 'refund' or 'cancel'
SELECT
  customer_id,
  COUNT(*) AS ticket_count,
  MAX(created_at) AS last_ticket_date
FROM tickets
WHERE created_at >= CURRENT_DATE - INTERVAL '60 days'
GROUP BY customer_id
HAVING COUNT(*) >= 3
   AND EXISTS (
     SELECT 1
     FROM tickets t2
     WHERE t2.customer_id = tickets.customer_id
       AND t2.tag IN ('refund', 'cancel')
   )
ORDER BY ticket_count DESC;

-- 4) SLA breaches (resolution time > target by priority)
SELECT
  ticket_id,
  priority,
  created_at,
  resolved_at,
  EXTRACT(EPOCH FROM (resolved_at - created_at)) / 3600.0 AS resolution_hours,
  CASE priority
    WHEN 'high' THEN 4
    WHEN 'medium' THEN 24
    ELSE 48
  END AS sla_hours
FROM tickets
WHERE resolved_at IS NOT NULL
  AND (EXTRACT(EPOCH FROM (resolved_at - created_at)) / 3600.0) >
      CASE priority WHEN 'high' THEN 4 WHEN 'medium' THEN 24 ELSE 48 END;