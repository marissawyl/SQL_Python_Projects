-- This view combines order data with customer and cohort information.
-- I join the orders table with customers and the customer_cohort view to get the unique customer ID and cohort year.
-- I also add some simple flags to make analysis easier later:
-- 1. is_approved checks if the order was approved.
-- 2. is_delivered checks if the order was actually delivered.
-- 3. is_reviewed checks if the order has at least one review.
-- The idea is to keep all order-level info in one place, so don’t have to repeat the same joins and logic again.

CREATE OR REPLACE VIEW vw_order_customer AS
SELECT
	o.order_id,
	o.customer_id,
	cc.customer_unique_id,
	cc.cohort_year,
	o.order_status,
	o.order_purchase_timestamp,
	o.order_approved_at,
	o.order_delivered_customer_date,
	
	-- Order was approved or not
	CASE
		WHEN o.order_approved_at IS NOT NULL THEN 1
		ELSE 0
	END AS is_approved,
	
	-- Order was delivered or not
	CASE
		WHEN o.order_status = 'delivered' THEN 1
		ELSE 0
	END AS is_delivered,
	
	-- Order has at least one review
	CASE
		WHEN EXISTS (
			SELECT 1
			FROM olist_order_reviews r
			WHERE r.order_id = o.order_id
		) THEN 1
		ELSE 0
	END AS is_reviewed
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
JOIN mv_customer_cohort cc ON c.customer_unique_id = cc.customer_unique_id
