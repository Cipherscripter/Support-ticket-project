-- ============================================================================
-- SQL FILE: data.sql
-- PROJECT: Support Ticket Analysis System using MySQL
-- AUTHOR: Fresher Support / Operations Analyst (2026 Graduate)
-- DESCRIPTION: Inserts realistic seed data into the database to model standard
--              operations. Includes active/on-leave agents, diverse tickets, 
--              unresolved backlogs, and multi-turn ticket update threads.
-- ============================================================================

USE support_ticket_db;

-- 1. INSERT DATA INTO 'customers' TABLE
-- 10 realistic customer accounts representing corporate and retail accounts
INSERT INTO customers (customer_id, first_name, last_name, email, phone, created_at) VALUES
(1, 'David', 'Miller', 'david.miller@acmecorp.com', '+1-555-0192', '2026-01-15 10:00:00'),
(2, 'Sophia', 'Garcia', 's.garcia@globaltech.io', '+1-555-0143', '2026-02-01 11:30:00'),
(3, 'James', 'Wilson', 'james.wilson@retailhub.net', '+1-555-0188', '2026-02-18 14:15:00'),
(4, 'Olivia', 'Martinez', 'olivia.m@startupbuilders.co', '+1-555-0121', '2026-03-05 09:45:00'),
(5, 'Liam', 'Anderson', 'l.anderson@cloudservices.com', '+1-555-0177', '2026-03-22 16:20:00'),
(6, 'Isabella', 'Thomas', 'isabella.t@financesolutions.org', '+1-555-0155', '2026-04-02 10:10:00'),
(7, 'Noah', 'Taylor', 'noah.taylor@mediagroup.com', '+1-555-0134', '2026-04-10 13:40:00'),
(8, 'Mia', 'White', 'mia.white@healthcareone.org', '+1-555-0112', '2026-04-18 15:30:00'),
(9, 'William', 'Harris', 'w.harris@logisticsunlimited.com', '+1-555-0109', '2026-04-25 11:15:00'),
(10, 'Charlotte', 'Martin', 'charlotte.m@edutech.edu', '+1-555-0166', '2026-05-01 09:00:00');


-- 2. INSERT DATA INTO 'agents' TABLE
-- 5 support agents with realistic tiers and working statuses
INSERT INTO agents (agent_id, first_name, last_name, email, tier, status, created_at) VALUES
(1, 'John', 'Doe', 'john.doe@supportcompany.com', 1, 'Active', '2025-06-01 09:00:00'),     -- Tier 1 (General Support)
(2, 'Alice', 'Smith', 'alice.smith@supportcompany.com', 1, 'Active', '2025-08-15 09:00:00'), -- Tier 1 (General Support)
(3, 'Sarah', 'Connor', 'sarah.connor@supportcompany.com', 2, 'Active', '2025-01-10 09:00:00'), -- Tier 2 (Technical Support)
(4, 'Bob', 'Johnson', 'bob.johnson@supportcompany.com', 3, 'Active', '2024-03-12 09:00:00'), -- Tier 3 (Escalations Specialist)
(5, 'Emma', 'Watson', 'emma.watson@supportcompany.com', 1, 'On Leave', '2025-11-20 09:00:00'); -- Currently on leave


-- 3. INSERT DATA INTO 'tickets' TABLE
-- 30 realistic support tickets representing diverse categories, priorities, and lifecycles
-- Formatted carefully to show both resolved tickets (with CSAT and resolution time) and open backlogs.
INSERT INTO tickets (ticket_id, customer_id, agent_id, category, priority, status, subject, description, created_at, resolved_at, satisfaction_score) VALUES
-- Resolved Tickets (April 2026)
(1, 1, 3, 'Technical', 'High', 'Resolved', 'Cannot connect to VPN', 'I am getting a timeout error when trying to connect to the corporate VPN from home. Please assist.', '2026-04-10 09:00:00', '2026-04-10 14:30:00', 5),
(2, 2, 1, 'Billing', 'Medium', 'Resolved', 'Double charge on monthly subscription', 'My credit card statement shows two charges of $29.99 for this month. Please refund one.', '2026-04-12 10:15:00', '2026-04-13 11:00:00', 4),
(3, 3, 2, 'Account Access', 'Urgent', 'Resolved', 'Account locked after password attempts', 'I tried logging in and got locked out. I have an urgent demo in 30 minutes! Help!', '2026-04-15 08:30:00', '2026-04-15 09:15:00', 5),
(4, 4, 3, 'Technical', 'Medium', 'Resolved', 'Slow loading speeds in dashboard', 'The main reports dashboard is taking over 15 seconds to load. My internet speed is fine.', '2026-04-18 14:00:00', '2026-04-20 16:00:00', 3),
(5, 6, 1, 'Product Feedback', 'Low', 'Resolved', 'Requesting dark mode feature', 'It would be great if the user portal had a dark mode. The bright white screen causes eye strain.', '2026-04-25 15:45:00', '2026-04-28 10:00:00', 5),

-- Resolved Tickets (May 2026)
(6, 8, 3, 'Account Access', 'High', 'Resolved', 'Password reset link not arriving', 'I clicked forgotten password but have not received the email in my inbox or spam folder.', '2026-05-03 12:00:00', '2026-05-03 13:45:00', 4),
(7, 9, 2, 'Billing', 'Medium', 'Resolved', 'Receipt request for Invoice #9843', 'Please send a PDF receipt for my last payment. Need it for tax filing.', '2026-05-05 09:00:00', '2026-05-06 14:00:00', 5),
(8, 10, 4, 'Technical', 'Urgent', 'Resolved', 'Database integration failure', 'The HubSpot integration suddenly stopped syncing contacts. This is stopping our marketing team.', '2026-05-08 14:30:00', '2026-05-09 17:15:00', 5),
(9, 4, 2, 'Product Feedback', 'Low', 'Closed', 'Suggesting bulk delete option in UI', 'Deleting tickets one by one takes a lot of time. We need a bulk delete checkbox option.', '2026-05-15 16:30:00', '2026-05-17 10:00:00', 4),
(10, 5, 3, 'Technical', 'High', 'Resolved', 'Mobile app crashes on login screen', 'After the latest iOS update, opening the app and tapping login immediately crashes the app.', '2026-05-16 09:15:00', '2026-05-18 11:30:00', 2), -- Customer gave low rating (2) due to initial delay
(11, 6, 1, 'Billing', 'Medium', 'Resolved', 'Change subscription from Monthly to Annual', 'I want to upgrade to the annual plan to save the 20% discount. How can I do this?', '2026-05-17 10:45:00', '2026-05-17 15:00:00', 5),
(12, 7, 4, 'Technical', 'Urgent', 'Resolved', 'Production Server Outage', 'Our team cannot access the hosted server instance. All users are getting 502 Bad Gateway.', '2026-05-18 11:00:00', '2026-05-20 10:00:00', 5),
(13, 9, 2, 'Account Access', 'Medium', 'Resolved', 'Requesting Admin permission for new employee', 'I need to grant Admin rights to our new HR manager but the save button is disabled.', '2026-05-21 09:30:00', '2026-05-21 11:00:00', 4),
(14, 10, 3, 'Technical', 'High', 'Resolved', 'Emails not sending from custom SMTP', 'We integrated our custom SendGrid SMTP but test emails fail to deliver. Log says SMTP auth failure.', '2026-05-22 15:00:00', '2026-05-23 16:30:00', 5),
(15, 6, 1, 'Billing', 'Medium', 'Resolved', 'Refund request for unused seats', 'We removed 3 users from our team plan last month but were still billed for them. Please check.', '2026-05-26 13:00:00', '2026-05-27 10:00:00', 3),
(16, 8, 2, 'Product Feedback', 'Low', 'Resolved', 'Documentation typo on API page', 'On the API docs page under /tickets, status has a spelling error: staatus.', '2026-05-27 09:00:00', '2026-05-27 12:00:00', 5),

-- Open / Work-In-Progress Tickets (representing active agent backlog)
(17, 5, 5, 'Billing', 'Low', 'In Progress', 'Update billing address', 'I need to change my corporate billing address for future invoices. Please update it.', '2026-04-22 11:30:00', NULL, NULL), -- Assigned to Emma who went on leave (potential bottleneck!)
(18, 1, 3, 'Technical', 'Medium', 'In Progress', 'API Webhook payload returning empty', 'We configured a webhook for ticket updates but the JSON body is empty when received.', '2026-05-10 11:00:00', NULL, NULL),
(19, 3, 1, 'Billing', 'High', 'Pending', 'Payment declined multiple times', 'My corporate Visa card is being declined. Bank says charge is not reaching them.', '2026-05-14 13:00:00', NULL, NULL),
(20, 2, 2, 'Product Feedback', 'Low', 'In Progress', 'Add filter by tags in reports', 'We heavily tag our tickets. Being able to filter reports by tags would be very helpful.', '2026-05-24 12:00:00', NULL, NULL),
(21, 3, 1, 'Technical', 'Medium', 'In Progress', 'Chrome browser extension not loading', 'The Chrome extension worked fine yesterday but today it is just a blank gray square.', '2026-05-25 09:00:00', NULL, NULL),
(22, 7, 4, 'Technical', 'Urgent', 'In Progress', 'SSL Certificate expired on domain', 'Our custom customer portal shows Not Secure to all clients. Please renew the SSL cert.', '2026-05-27 08:30:00', NULL, NULL),

-- New / Unassigned Tickets (the incoming queue)
(23, 7, NULL, 'Technical', 'High', 'Open', 'Error 500 when exporting reports to CSV', 'Getting a internal server error 500 whenever I try to export my weekly analytics report.', '2026-05-01 10:00:00', NULL, NULL), -- Unassigned High priority for a long time (SLA Breach!)
(24, 2, NULL, 'Account Access', 'Urgent', 'Open', 'Cannot disable 2FA', 'I lost my backup codes and upgraded my phone. Complete lockout from admin account!', '2026-05-12 08:00:00', NULL, NULL), -- Unassigned Urgent (Critical triage needed!)
(25, 8, NULL, 'Product Feedback', 'Low', 'Open', 'Integrations list page request', 'Can you provide a list of all current third-party integrations planned for Q3?', '2026-05-20 14:00:00', NULL, NULL),
(26, 1, NULL, 'Billing', 'Medium', 'Open', 'Invoice has incorrect Tax ID', 'Our latest invoice has an outdated tax registration number. Please correct and re-issue.', '2026-05-24 10:00:00', NULL, NULL),
(27, 4, NULL, 'Account Access', 'Low', 'Open', 'Remove former employee access', 'Please deactivate the account of employee john.smith@company.com immediately.', '2026-05-25 14:00:00', NULL, NULL),
(28, 5, NULL, 'Technical', 'High', 'Open', 'Excel export formatting is garbled', 'When we export tables containing non-English names to Excel, the characters are corrupted.', '2026-05-26 11:15:00', NULL, NULL),
(29, 9, 3, 'Billing', 'Low', 'Open', 'When is my next billing cycle?', 'Just want to confirm when the next charge will hit our account.', '2026-05-27 10:30:00', NULL, NULL),
(30, 10, NULL, 'Technical', 'High', 'Open', 'PDF Invoice download link broken', 'Clicking Download PDF from the billing dashboard does nothing. No error is shown.', '2026-05-27 11:00:00', NULL, NULL);


-- 4. INSERT DATA INTO 'ticket_updates' TABLE
-- Simulates the conversations and internal audit history of several tickets.
-- Contains multiple updates per ticket to model rich historical context.
-- Note: Some tickets (like 23, 24, 25, 28, 30) have ZERO updates, showing "neglected" tickets in reporting.
INSERT INTO ticket_updates (update_id, ticket_id, update_type, updated_by, message, created_at) VALUES
-- Conversation for Ticket 1 (VPN Connection Problem)
(1, 1, 'Agent Response', 'Agent', 'Hi David, please verify if you are using the new IP address from the security email sent yesterday.', '2026-04-10 09:30:00'),
(2, 1, 'Customer Reply', 'Customer', 'Hi Sarah, yes, updating the server IP to the new one fixed the timeout! Thank you so much.', '2026-04-10 14:15:00'),
(3, 1, 'Internal Note', 'Agent', 'VPN issue resolved by directing customer to the updated server configuration.', '2026-04-10 14:30:00'),

-- Conversation for Ticket 2 (Billing Double Charge)
(4, 2, 'Agent Response', 'Agent', 'Hi Sophia, I checked our system and it seems there was a merchant gateway error. I have processed a refund of $29.99 back to your card. It should reflect in 3-5 business days.', '2026-04-12 14:00:00'),
(5, 2, 'Customer Reply', 'Customer', 'Thanks John! I see the refund pending on my bank app. Excellent speed!', '2026-04-13 10:30:00'),

-- Conversation for Ticket 3 (Urgent Lockout)
(6, 3, 'Agent Response', 'Agent', 'Hello James, I have verified your identity using your corporate security key. Your account has been unlocked, and a temporary password link has been sent to your registered mobile.', '2026-04-15 08:45:00'),
(7, 3, 'Customer Reply', 'Customer', 'Got it! Logged in just in time. You guys are lifesavers!', '2026-04-15 09:10:00'),

-- Conversation for Ticket 4 (Slow Load)
(8, 4, 'Internal Note', 'Agent', 'Checking server response times. No outage reported on AWS. Might be a front-end rendering bug.', '2026-04-18 16:00:00'),
(9, 4, 'Agent Response', 'Agent', 'Hi Olivia, our dev team released a hotfix for a JS loop memory leak on the dashboard page. Could you clear your cache and try loading again?', '2026-04-19 10:00:00'),
(10, 4, 'Customer Reply', 'Customer', 'It loads a bit faster now (about 4 seconds), which is acceptable compared to before. Thanks for the fix.', '2026-04-20 15:30:00'),

-- Conversation for Ticket 5 (Request Dark Mode)
(11, 5, 'Agent Response', 'Agent', 'Hi Isabella, thank you for your feedback! I have forwarded this feature request to our Product Management team for consideration in the Q3 roadmap.', '2026-04-26 10:00:00'),

-- Conversation for Ticket 8 (HubSpot Integration Failure - Escalation Scenario)
(12, 8, 'Internal Note', 'Agent', 'Attempted general resync, still failing with OAuth token error. Escalating to Tier 3 (Bob) for deep API inspection.', '2026-05-08 15:00:00'),
(13, 8, 'Internal Note', 'Agent', 'Assigned ticket to Bob Johnson (Tier 3) automatically via support rules.', '2026-05-08 15:05:00'),
(14, 8, 'Agent Response', 'Agent', 'Hi Charlotte, this is Bob from Tier 3 support. HubSpot changed their API endpoints today. I manually regenerated our token bindings. The sync is now operational again.', '2026-05-09 16:30:00'),
(15, 8, 'Customer Reply', 'Customer', 'Works perfectly now! Incredible troubleshooting under pressure. Highly appreciate it!', '2026-05-09 17:00:00'),

-- Conversation for Ticket 10 (Mobile App Crashes - Low CSAT Scenario)
(16, 10, 'Agent Response', 'Agent', 'Hi Liam, I tried replicating this on our iPhone test devices and did not experience a crash. Can you reinstall the app?', '2026-05-16 11:00:00'),
(17, 10, 'Customer Reply', 'Customer', 'I reinstalled and it still crashes every time! My iOS version is 17.4.1. This is urgent as I cannot manage shipments on the road.', '2026-05-16 14:00:00'),
(18, 10, 'Internal Note', 'Agent', 'Checking logs. Found NullPointerException on startup check for iOS 17.4.1. Escalated to mobile dev. Hotfix v2.4.1 sent to App Store.', '2026-05-17 09:00:00'),
(19, 10, 'Agent Response', 'Agent', 'Hi Liam, our engineering team identified an incompatibility with iOS 17.4.1 and pushed a hotfix (v2.4.1) to the App Store. Please download the latest update. That will resolve the crash.', '2026-05-18 10:00:00'),

-- Conversation for Ticket 12 (Production Server Outage)
(20, 12, 'Internal Note', 'Agent', 'Alert received from Cloudflare. Primary AWS database node is unresponsive. Initiating failover cluster switch.', '2026-05-18 11:15:00'),
(21, 12, 'Agent Response', 'Agent', 'Hi Noah, our infrastructure team is currently resolving a hardware node failure on our primary cluster. Traffic is being rerouted. Expect complete service restoration within 1 hour.', '2026-05-18 12:00:00'),
(22, 12, 'Agent Response', 'Agent', 'Rerouting completed. All systems operational. Noah, could you please verify connection on your end?', '2026-05-19 09:00:00'),
(23, 12, 'Customer Reply', 'Customer', 'Yes, all back online! Our team can log in without issues. Great job communicating the downtime.', '2026-05-20 09:45:00'),

-- Conversation for Ticket 17 (Billing address change - Agent went on leave)
(24, 17, 'Agent Response', 'Agent', 'Hi Liam, I can certainly assist with this. Please attach a copy of your tax certificate for corporate verification.', '2026-04-22 13:00:00'),
(25, 17, 'Customer Reply', 'Customer', 'Here is our W9 tax form for address verification.', '2026-04-23 09:00:00'),
-- (Note: Emma Watson went on leave right after, no agent response since April 23 - shows up as In Progress but neglected!)

-- Conversation for Ticket 19 (Payment Declined)
(26, 19, 'Agent Response', 'Agent', 'Hi James, this is John. I have reviewed our Stripe logs. The error code returned is insufficient_funds. Can you double check if your corporate billing department has authorized this month payments?', '2026-05-14 15:30:00'),
(27, 19, 'Customer Reply', 'Customer', 'Ah, let me check with the accounts team. It might be due to our quarterly card limit refresh. Please keep this ticket open.', '2026-05-15 10:00:00'),
(28, 19, 'Internal Note', 'Agent', 'Ticket placed in Pending status while customer verifies their credit limit with the bank.', '2026-05-15 10:05:00'),

-- Conversation for Ticket 22 (SSL Expired)
(29, 22, 'Internal Note', 'Agent', 'Confirmed certificate renewal failed auto-propagation on our CDN. Manually uploading Let\'s Encrypt certificate chain.', '2026-05-27 08:35:00'),
(30, 22, 'Agent Response', 'Agent', 'Hi Noah, I am currently installing the renewed security certificate. The propagation should be complete across all global edge servers in the next 15 minutes.', '2026-05-27 08:45:00');

-- ============================================================================
-- END OF data.sql
-- ============================================================================
