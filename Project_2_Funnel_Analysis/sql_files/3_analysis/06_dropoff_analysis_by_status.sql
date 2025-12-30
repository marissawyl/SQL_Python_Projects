-- This query looks at drop-offs in the funnel per cohort year, from Ordered → Approved → Delivered.
-- I use an order_base CTE to simplify the source data.

WITH order_base AS (
	-- CTE of vw_order_customer for readability
	SELECT
		order_id,
		cohort_year,
		order_status,
		is_approved,
		is_delivered,
		is_reviewed
	FROM vw_order_customer
),
ordered_to_approved_dropoff_by_status AS (
	-- Orders that never got approved and delivered and reviewed
	SELECT
		cohort_year,
		order_status,
		COUNT(order_id) AS drop_off_order_cnt
	FROM order_base
	WHERE 
		is_approved = 0
		AND is_delivered = 0
		AND is_reviewed = 0
	GROUP BY
		cohort_year,
		order_status
),
approved_to_delivered_dropoff_by_status AS (
	-- Approved orders that were not delivered and reviewed
	SELECT
		cohort_year,
		order_status,
		COUNT(order_id) AS drop_off_order_cnt
	FROM order_base
	WHERE
		is_approved = 1
		AND is_delivered = 0
		AND is_reviewed = 0
	GROUP BY
		cohort_year,
		order_status
),
total_ordered_per_cohort AS (
	-- Total orders per cohort (base for Ordered → Approved)
	SELECT
		cohort_year,
		COUNT(order_id) AS total_ordered_cnt
	FROM order_base
	GROUP BY
		cohort_year
),
total_approved_per_cohort AS (
	-- Total approved orders per cohort (base for Approved → Delivered)
	SELECT
		cohort_year,
		COUNT(order_id) AS total_approved_cnt
	FROM order_base
	WHERE is_approved = 1
	GROUP BY cohort_year
)

-- Final select calculates:
-- 1) pct_of_drop_off: percent of each drop-off reason relative to the relevant step per cohort
-- 2) pct_of_total_order: percent of each drop-off reason relative to overall total orders per cohort (global view)
SELECT
	oa.cohort_year,
	1 AS step_num,
	'Ordered' AS step_from,
	'Approved' AS step_to,
	oa.order_status AS reason,
	oa.drop_off_order_cnt,
	ROUND((100 * oa.drop_off_order_cnt::NUMERIC / SUM(oa.drop_off_order_cnt) OVER (PARTITION BY oa.cohort_year)), 2) AS pct_of_drop_off,
	ROUND((100 * oa.drop_off_order_cnt::NUMERIC / toc.total_ordered_cnt), 3) AS pct_of_total_order
FROM ordered_to_approved_dropoff_by_status oa
JOIN total_ordered_per_cohort toc ON oa.cohort_year = toc.cohort_year
UNION ALL
SELECT
	ad.cohort_year,
	2,
	'Approved',
	'Delivered',
	ad.order_status,
	ad.drop_off_order_cnt,
	ROUND((100 * ad.drop_off_order_cnt::NUMERIC / SUM(ad.drop_off_order_cnt) OVER (PARTITION BY ad.cohort_year)), 2),
	ROUND((100 * ad.drop_off_order_cnt::NUMERIC / tac.total_approved_cnt), 3)
FROM approved_to_delivered_dropoff_by_status ad
JOIN total_approved_per_cohort tac ON ad.cohort_year = tac.cohort_year
ORDER BY
	cohort_year,
	step_num,
	reason