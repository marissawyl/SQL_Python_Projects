-- This query builds a simple funnel by cohort year.
-- The result shows how customers move through the order flow for each cohort year: Ordered → Approved → Delivered → Reviewed.

-- Funnel grain: 1 row = 1 unique customer per funnel step.
-- Each step uses DISTINCT to ensure a customer is counted only once, even if they place multiple orders.
-- A customer is considered to pass a step if they complete it at least once.

WITH order_base AS (
	-- Base order-level dataset with customer cohort information used as the source table for counting unique customers at each funnel step.
	-- Grain: 1 row = 1 order
	SELECT
		o.order_id,
		cc.customer_unique_id,
		cc.cohort_year,
		o.order_status,
		o.order_approved_at
	FROM olist_orders o
	JOIN olist_customers c ON o.customer_id = c.customer_id
	JOIN mv_customer_cohort cc ON c.customer_unique_id = cc.customer_unique_id
),
ordered AS (
	-- Customers who have placed at least one order
	SELECT DISTINCT
		customer_unique_id,
		cohort_year
	FROM order_base
),
approved AS (
	-- Customers with at least one approved order
	SELECT DISTINCT
		customer_unique_id,
		cohort_year
	FROM order_base
	WHERE order_approved_at IS NOT NULL
),
delivered AS (
	-- Customers with at least one approved order that was successfully delivered
	SELECT DISTINCT 
		customer_unique_id,
		cohort_year
	FROM order_base
	WHERE
		order_status = 'delivered'
		AND order_approved_at IS NOT NULL
),
reviewed AS (
	-- Customers who received a delivered order and submitted at least one review
	SELECT DISTINCT
		customer_unique_id,
		cohort_year
	FROM order_base ob
	WHERE
		order_status = 'delivered'
		AND order_approved_at IS NOT NULL
		AND EXISTS (
			-- Check if the order has at least one review
			SELECT 1
			FROM olist_order_reviews r
			WHERE r.order_id = ob.order_id
		)
),
-- All steps are combined into a single funnel table with UNION ALL.
funnel AS (
	SELECT cohort_year, 1 AS step_order, 'Ordered' AS step_name, COUNT(*) AS users_cnt
	FROM ordered
	GROUP BY cohort_year
	UNION ALL
	SELECT cohort_year, 2, 'Approved', COUNT(*)
	FROM approved
	GROUP BY cohort_year
	UNION ALL
	SELECT cohort_year, 3, 'Delivered', COUNT(*)
	FROM delivered
	GROUP BY cohort_year
	UNION ALL
	SELECT cohort_year, 4, 'Reviewed', COUNT(*)
	FROM reviewed
	GROUP BY cohort_year
)

SELECT
	cohort_year,
	step_order,
	step_name,
	users_cnt,
	
	-- Conversion rate from the first step (Ordered)
	ROUND(100 * users_cnt::NUMERIC / FIRST_VALUE(users_cnt) OVER (PARTITION BY cohort_year ORDER BY step_order), 2) AS overall_conv_rate_pct,
	
	--  Conversion rate compared to the previous step
	ROUND(100 * users_cnt::NUMERIC / LAG(users_cnt) OVER (PARTITION BY cohort_year ORDER BY step_order), 2) AS prev_step_conv_rate_pct,
	
	-- Drop-off rate from the previous step: how many users drop from the previous step
	100 - (ROUND(100 * users_cnt::NUMERIC / LAG(users_cnt) OVER (PARTITION BY cohort_year ORDER BY step_order), 2)) AS drop_off_pct
FROM
	funnel
ORDER BY
	cohort_year,
	step_order;

