-- This query analyzes post-delivery review behavior by cohort and quarter.
-- It focuses on whether delivered orders receive customer reviews, which reflects post-purchase engagement rather than funnel drop-off.

WITH delivered_orders AS (
	-- Get only orders that were approved and delivered
	SELECT
		cohort_year,
		order_purchase_timestamp,
		is_reviewed
	FROM vw_order_customer
	WHERE
		is_approved = 1
		AND is_delivered = 1
),
agg AS (
	-- Aggregate total delivered orders and count how many were not reviewed
	SELECT
		cohort_year,
		DATE_TRUNC('quarter', order_purchase_timestamp) AS order_quarter,
		COUNT(*) AS total_delivered_cnt,
		SUM(CASE WHEN is_reviewed = 0 THEN 1 ELSE 0 END) AS not_reviewed_cnt
	FROM delivered_orders
	GROUP BY 
		cohort_year,
		order_quarter
)

SELECT
	cohort_year,
	order_quarter,
	total_delivered_cnt,
	not_reviewed_cnt,
	-- Share of delivered orders without reviews, calculated per cohort and per quarter
	ROUND((100 * not_reviewed_cnt::NUMERIC / total_delivered_cnt), 2) AS pct_vs_delivered_orders
FROM agg
ORDER BY
	cohort_year,
	order_quarter;