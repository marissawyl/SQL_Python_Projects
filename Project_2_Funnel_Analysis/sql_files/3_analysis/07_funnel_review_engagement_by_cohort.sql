-- This query looks at delivered orders and whether customers left a review per cohort year.
-- It's more about customer behavior after delivery, not a drop-off. Hence, this analysis is separated from the funnel drop-off analysis.

WITH delivered_orders AS (
	-- Get only orders that were approved and delivered
	SELECT
		cohort_year,
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
		COUNT(*) AS total_delivered_cnt,
		SUM(CASE WHEN is_reviewed = 0 THEN 1 ELSE 0 END) AS not_reviewed_cnt
	FROM delivered_orders
	GROUP BY cohort_year
)

SELECT
	cohort_year,
	not_reviewed_cnt,
	-- Percent of delivered orders that were not reviewed relative to all delivered orders per cohort
	ROUND((100 * not_reviewed_cnt::NUMERIC / total_delivered_cnt), 2) AS pct_vs_delivered_orders
FROM agg
ORDER BY cohort_year;
