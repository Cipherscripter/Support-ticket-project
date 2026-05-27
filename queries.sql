USE support_ticket_db;


-- PART 1: BEGINNER & INTERMEDIATE OPERATIONS (FUNDAMENTALS)


-- Query 1.1: Retrieve all active agents sorted by their technical tier.
-- Operational Rationale: Helps team leads understand active staffing capacity and distribution across tiers.
-- SQL Concepts: SELECT, WHERE, ORDER BY
SELECT 
    agent_id, 
    first_name, 
    last_name, 
    tier, 
    status 
FROM agents
WHERE status = 'Active'
ORDER BY tier DESC, last_name ASC;


-- Query 1.2: Find all tickets related to Billing or Technical categories.
-- Operational Rationale: Helps specialized teams filter and pull their specific work queues.
-- SQL Concepts: WHERE, IN operator, logical filtering
SELECT 
    ticket_id, 
    subject, 
    category, 
    priority, 
    status 
FROM tickets
WHERE category IN ('Billing', 'Technical')
ORDER BY priority DESC;


-- Query 1.3: Pattern matching for keyword triage.
-- Operational Rationale: Isolates tickets containing specific system failure terms (e.g., VPN, locked, login) for rapid tagging.
-- SQL Concepts: LIKE operator with wildcard characters (%)
SELECT 
    ticket_id, 
    subject, 
    category, 
    status, 
    created_at 
FROM tickets
WHERE subject LIKE '%VPN%' 
   OR description LIKE '%locked%' 
   OR description LIKE '%login%'
ORDER BY created_at DESC;


-- Query 1.4: Count total tickets grouped by status.
-- Operational Rationale: Provides a high-level operational snapshot of the active support queue.
-- SQL Concepts: GROUP BY, COUNT() aggregation, alias naming
SELECT 
    status, 
    COUNT(ticket_id) AS ticket_count
FROM tickets
GROUP BY status
ORDER BY ticket_count DESC;

-- Query 1.5: Join tickets with customer names.
-- Operational Rationale: Displays customer details on front-end grids so agents know who submitted each ticket.
-- SQL Concepts: INNER JOIN, table aliases, column concatenation (CONCAT)
SELECT 
    t.ticket_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS customer_email,
    t.subject,
    t.priority,
    t.status
FROM tickets t
INNER JOIN customers c ON t.customer_id = c.customer_id
ORDER BY t.ticket_id ASC;


-- Query 1.6: Join tickets with agents (including unassigned tickets).
-- Operational Rationale: Essential for backlog triage to identify which tickets are unassigned (Agent Name is NULL).
-- SQL Concepts: LEFT JOIN (returns all records from the left table, and matching records from the right)
SELECT 
    t.ticket_id,
    t.subject,
    t.category,
    t.priority,
    t.status,
    CONCAT(a.first_name, ' ', a.last_name) AS assigned_agent
FROM tickets t
LEFT JOIN agents a ON t.agent_id = a.agent_id
ORDER BY assigned_agent IS NULL DESC, t.ticket_id ASC; -- Brings unassigned tickets to the top


-- Query 1.7: Identify tickets with high satisfaction scores using a subquery.
-- Operational Rationale: Filters tickets with above-average CSAT scores to analyze what went right (best practices).
-- SQL Concepts: Subquery, AVG() aggregation, WHERE comparative filtering
SELECT 
    ticket_id, 
    subject, 
    satisfaction_score
FROM tickets
WHERE satisfaction_score > (
    SELECT AVG(satisfaction_score) 
    FROM tickets 
    WHERE satisfaction_score IS NOT NULL
)
ORDER BY satisfaction_score DESC;




-- PART 2: REAL-WORLD SUPPORT OPERATIONS ANALYTICS (KPI REPORTING)

-- Query 2.1: Most Common Issue Types (Category Distribution)
-- Operational Rationale: Identifies the biggest drivers of customer friction. A high volume of billing queries may signal pricing confusion, while technical spikes point to system bugs.
-- SQL Concepts: COUNT(), GROUP BY, Percentage Calculation (using cross join for total count)
SELECT 
    category,
    COUNT(*) AS ticket_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tickets)), 2) AS percentage_of_total
FROM tickets
GROUP BY category
ORDER BY ticket_count DESC;


-- Query 2.2: Agent Performance Scorecard
-- Operational Rationale: Tracks productivity and customer satisfaction (CSAT) metrics per agent. Crucial for annual performance reviews and training needs.
-- SQL Concepts: LEFT JOIN, COUNT(), AVG(), ROUND(), SUM() with CASE WHEN to calculate resolution rates
SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
    a.tier AS technical_tier,
    COUNT(t.ticket_id) AS total_assigned,
    SUM(CASE WHEN t.status IN ('Resolved', 'Closed') THEN 1 ELSE 0 END) AS total_resolved,
    ROUND(
        (SUM(CASE WHEN t.status IN ('Resolved', 'Closed') THEN 1 ELSE 0 END) * 100.0 / COUNT(t.ticket_id)), 
        2
    ) AS resolution_rate_percentage,
    ROUND(AVG(t.satisfaction_score), 2) AS average_csat_score
FROM agents a
LEFT JOIN tickets t ON a.agent_id = t.agent_id
GROUP BY a.agent_id, a.first_name, a.last_name, a.tier
ORDER BY average_csat_score DESC, total_resolved DESC;


-- Query 2.3: SLA Breach Warning (High/Urgent Backlog Triage)
-- Operational Rationale: Shows unresolved High/Urgent tickets that are taking too long. Essential for avoiding SLA breaches.
-- Note: '2026-05-27 13:00:00' is used to represent 'current_time' based on our static seed dataset. In production, swap with NOW().
-- SQL Concepts: TIMESTAMPDIFF(), NOW(), WHERE logic, DATE formatting
SELECT 
    t.ticket_id,
    t.subject,
    t.priority,
    t.status,
    t.created_at,
    TIMESTAMPDIFF(HOUR, t.created_at, '2026-05-27 13:00:00') AS open_duration_hours,
    CONCAT(a.first_name, ' ', a.last_name) AS assigned_agent
FROM tickets t
LEFT JOIN agents a ON t.agent_id = a.agent_id
WHERE t.status NOT IN ('Resolved', 'Closed')
  AND t.priority IN ('High', 'Urgent')
ORDER BY open_duration_hours DESC;


-- Query 2.4: Neglected Tickets (Tickets without any updates)
-- Operational Rationale: Identifies tickets in the backlog that have zero recorded touches (agent notes or customer replies). 
-- This is a major customer friction point and key quality metric for support managers.
-- SQL Concepts: LEFT JOIN, IS NULL filter, GROUP BY, WHERE
SELECT 
    t.ticket_id,
    t.subject,
    t.category,
    t.priority,
    t.status,
    t.created_at,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM tickets t
INNER JOIN customers c ON t.customer_id = c.customer_id
LEFT JOIN ticket_updates u ON t.ticket_id = u.ticket_id
WHERE u.update_id IS NULL                     -- Filters for tickets with NO entries in updates table
  AND t.status NOT IN ('Resolved', 'Closed')  -- Only cares about currently unresolved tickets
ORDER BY t.priority DESC, t.created_at ASC;


-- Query 2.5: Repeat Contact Analysis (Customers with the Most Tickets)
-- Operational Rationale: Tracks "power contact" customers. High contact frequency indicates an account having major problems, which warrants proactive customer success or engineering intervention.
-- SQL Concepts: COUNT(), INNER JOIN, GROUP BY, HAVING filter
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS customer_email,
    COUNT(t.ticket_id) AS total_tickets_submitted,
    SUM(CASE WHEN t.status IN ('Resolved', 'Closed') THEN 1 ELSE 0 END) AS resolved_tickets,
    ROUND(AVG(t.satisfaction_score), 2) AS customer_avg_csat
FROM customers c
INNER JOIN tickets t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING total_tickets_submitted >= 3           -- Isolates users with multiple contacts (threshold = 3)
ORDER BY total_tickets_submitted DESC;


-- Query 2.6: Average Resolution Time by Issue Category
-- Operational Rationale: Provides operations teams with concrete data on how long specific types of issues take to solve. Useful for managing customer expectations (e.g. setting SLA promises).
-- SQL Concepts: TIMESTAMPDIFF() in HOUR/DAY, AVG(), GROUP BY, ROUND()
SELECT 
    category,
    COUNT(ticket_id) AS resolved_ticket_count,
    ROUND(AVG(TIMESTAMPDIFF(HOUR, created_at, resolved_at)), 1) AS avg_resolution_time_hours,
    ROUND(AVG(TIMESTAMPDIFF(DAY, created_at, resolved_at)), 1) AS avg_resolution_time_days
FROM tickets
WHERE resolved_at IS NOT NULL                 -- Excludes open tickets that don't have a resolution date yet
GROUP BY category
ORDER BY avg_resolution_time_hours ASC;


-- Query 2.7: Monthly Ticket Volume and CSAT Trends
-- Operational Rationale: Tracks seasonal support volume trends and overall CSAT health over months. Helps with staff capacity planning.
-- SQL Concepts: DATE_FORMAT(), COUNT(), AVG(), ROUND()
SELECT 
    DATE_FORMAT(created_at, '%Y-%m') AS billing_month,
    COUNT(ticket_id) AS monthly_ticket_volume,
    SUM(CASE WHEN status IN ('Resolved', 'Closed') THEN 1 ELSE 0 END) AS tickets_resolved,
    ROUND(AVG(satisfaction_score), 2) AS monthly_avg_csat
FROM tickets
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY billing_month ASC;


-- Query 2.8: Identify Process Bottlenecks - Unresolved Tickets Assigned to Agents On Leave
-- Operational Rationale: Pinpoints tickets assigned to agents who are currently on leave. These tickets are stuck and need immediate redistribution to active team members.
-- SQL Concepts: INNER JOIN, WHERE status match, comparative reporting
SELECT 
    t.ticket_id,
    t.subject,
    t.priority,
    t.status,
    CONCAT(a.first_name, ' ', a.last_name) AS agent_on_leave,
    a.tier AS agent_tier,
    TIMESTAMPDIFF(DAY, t.created_at, '2026-05-27 13:00:00') AS days_stuck
FROM tickets t
INNER JOIN agents a ON t.agent_id = a.agent_id
WHERE a.status = 'On Leave'
  AND t.status NOT IN ('Resolved', 'Closed')
ORDER BY t.priority DESC, days_stuck DESC;