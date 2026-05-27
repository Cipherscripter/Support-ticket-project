-- ============================================================================
-- SQL FILE: schema.sql
-- PROJECT: Support Ticket Analysis System using MySQL
-- AUTHOR: Fresher Support / Operations Analyst (2026 Graduate)
-- DESCRIPTION: Sets up the database and defines the schema, constraints,
--              foreign keys, and indexes for a realistic customer support
--              operations ticketing system.
-- ============================================================================

-- 1. DATABASE CREATION AND INITIALIZATION
-- Create the database if it doesn't already exist to prevent execution errors
CREATE DATABASE IF NOT EXISTS support_ticket_db;
USE support_ticket_db;

-- 2. DROP TABLES IN REVERSE ORDER OF DEPENDENCY
-- Dropping dependent tables first avoids Foreign Key constraint errors
DROP TABLE IF EXISTS ticket_updates;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS agents;
DROP TABLE IF EXISTS customers;


-- 3. CREATE 'customers' TABLE
-- Holds primary contact information for clients submitting support tickets.
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,      -- UNIQUE constraint prevents duplicate customer sign-ups
    phone VARCHAR(20) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_customer_email (email)         -- Index added for rapid customer lookup by email
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 4. CREATE 'agents' TABLE
-- Stores profile details for support professionals working the tickets.
CREATE TABLE agents (
    agent_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    tier INT NOT NULL DEFAULT 1,             -- 1 = Tier 1 (General), 2 = Tier 2 (Technical), 3 = Tier 3 (Escalations)
    status VARCHAR(20) NOT NULL DEFAULT 'Active', -- 'Active', 'On Leave', 'Inactive'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_agent_tier CHECK (tier IN (1, 2, 3)), -- Restricts values to realistic support tiers
    CONSTRAINT chk_agent_status CHECK (status IN ('Active', 'On Leave', 'Inactive'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 5. CREATE 'tickets' TABLE
-- The core transactional table. Stores ticket metadata, current status, assignment, and customer ratings.
CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    agent_id INT NULL,                       -- NULL represents unassigned tickets in the incoming backlog
    category VARCHAR(50) NOT NULL,           -- 'Billing', 'Technical', 'Account Access', 'Product Feedback'
    priority VARCHAR(20) NOT NULL,           -- 'Low', 'Medium', 'High', 'Urgent'
    status VARCHAR(20) NOT NULL DEFAULT 'Open', -- 'Open', 'In Progress', 'Pending', 'Resolved', 'Closed'
    subject VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL DEFAULT NULL, -- Populated when status changes to Resolved/Closed
    satisfaction_score INT NULL DEFAULT NULL, -- CSAT score (1 to 5) collected post-resolution
    
    -- Foreign Key Constraints to maintain Referential Integrity
    CONSTRAINT fk_tickets_customer FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id) 
        ON DELETE RESTRICT,                  -- Prevents deleting active customers with tickets
        
    CONSTRAINT fk_tickets_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(agent_id) 
        ON DELETE SET NULL,                  -- Reassigns to NULL if an agent's account is deactivated
        
    -- Domain constraints to enforce valid data entry
    CONSTRAINT chk_ticket_priority CHECK (priority IN ('Low', 'Medium', 'High', 'Urgent')),
    CONSTRAINT chk_ticket_status CHECK (status IN ('Open', 'In Progress', 'Pending', 'Resolved', 'Closed')),
    CONSTRAINT chk_ticket_csat CHECK (satisfaction_score BETWEEN 1 AND 5),
    
    -- Indexes optimized for heavy operational reporting queries
    INDEX idx_tickets_customer_id (customer_id),
    INDEX idx_tickets_agent_id (agent_id),
    INDEX idx_tickets_status (status),
    INDEX idx_tickets_priority (priority),
    INDEX idx_tickets_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 6. CREATE 'ticket_updates' TABLE
-- Simulates the audit trail and conversation history for every support ticket.
CREATE TABLE ticket_updates (
    update_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    update_type VARCHAR(30) NOT NULL,        -- 'Internal Note' (agent-only), 'Customer Reply', 'Agent Response'
    updated_by VARCHAR(30) NOT NULL,         -- 'Agent', 'Customer', 'System' (automation rules)
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Cascade delete removes updates if a testing/archived ticket is deleted
    CONSTRAINT fk_updates_ticket FOREIGN KEY (ticket_id) 
        REFERENCES tickets(ticket_id) 
        ON DELETE CASCADE,
        
    CONSTRAINT chk_update_type CHECK (update_type IN ('Internal Note', 'Customer Reply', 'Agent Response')),
    CONSTRAINT chk_updated_by CHECK (updated_by IN ('Agent', 'Customer', 'System')),
    
    -- Indexes optimized for pulling conversation feeds for specific tickets
    INDEX idx_updates_ticket_id (ticket_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- END OF schema.sql
-- ============================================================================
