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
-- Drop-off from Ordered → Approved (orders that never got approved, delivered, and reviewed)
ordered_to_approved_dropoff AS (
	SELECT
		cohort_year,
		1 AS step_num,
		'Ordered' AS step_from,
		'Approved' AS step_to,
		order_status AS reason,
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
-- Drop-off from Approved → Delivered (approved orders that were not delivered and reviewed)
approved_to_delivered_dropoff AS (
	SELECT
		cohort_year,
		2 AS step_num,
		'Approved' AS step_from,
		'Delivered' AS step_to,
		order_status  AS reason,
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
-- Union all steps
all_dropoffs AS (
	SELECT * FROM ordered_to_approved_dropoff
	UNION ALL
	SELECT * FROM approved_to_delivered_dropoff
),
-- Total orders per cohort (base for Ordered → Approved)
total_ordered_per_cohort AS (
	SELECT
		cohort_year,
		COUNT(order_id) AS total_ordered_cnt
	FROM order_base
	GROUP BY
		cohort_year
),
-- Total approved orders per cohort (base for Approved → Delivered)
total_approved_per_cohort AS (
	SELECT
		cohort_year,
		COUNT(order_id) AS total_approved_cnt
	FROM order_base
	WHERE is_approved = 1
	GROUP BY cohort_year
)

-- Final select calculates:
-- 1) pct_of_drop_off: percent of each drop-off reason relative to the relevant step per cohort
-- 2) pct_of_total_order_by_cohort: percent of each drop-off reason relative to overall total orders per cohort (global view)
SELECT
	ad.cohort_year,
	ad.step_num,
	ad.step_from,
	ad.step_to,
	ad.reason,
	ad.drop_off_order_cnt,
	ROUND((100 * ad.drop_off_order_cnt::NUMERIC / SUM(ad.drop_off_order_cnt) OVER (PARTITION BY ad.cohort_year, ad.step_num)), 2) AS pct_of_drop_off,
	CASE
		WHEN ad.step_num = 1 THEN ROUND((100 * ad.drop_off_order_cnt::NUMERIC / toc.total_ordered_cnt), 3)
		WHEN ad.step_num = 2  AND tac.total_approved_cnt > 0 THEN ROUND((100 * ad.drop_off_order_cnt::NUMERIC / tac.total_approved_cnt), 3)
	END AS pct_of_total_order_by_cohort
FROM all_dropoffs ad
JOIN total_ordered_per_cohort toc ON ad.cohort_year = toc.cohort_year
LEFT JOIN total_approved_per_cohort tac ON ad.cohort_year = tac.cohort_year
ORDER BY
	ad.cohort_year,
	ad.step_num,
	pct_of_drop_off DESC;