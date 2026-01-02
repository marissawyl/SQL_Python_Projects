-- This query creates a materialized view to track customer cohorts.
-- I group customers by their unique ID and find the date of their first order.
-- From that first order date, I extract the year to define the cohort year.
-- This makes it easier to analyze customer behavior based on when they first started buying.
-- I use a materialized view so the result can be reused without recalculating every time.
-- Grain: 1 row = 1 customer

CREATE MATERIALIZED VIEW mv_customer_cohort AS
SELECT
	c.customer_unique_id,
	MIN(o.order_purchase_timestamp) AS first_order_date,
	EXTRACT(YEAR FROM MIN(o.order_purchase_timestamp)) AS cohort_year
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
GROUP BY
	c.customer_unique_id;



