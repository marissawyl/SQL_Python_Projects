-- This query looks at drop-offs in the funnel per quarter, from Ordered → Approved → Delivered.
-- I use an order_base CTE to simplify the source data.

-- Base dataset for quarter-based funnel drop-off analysis
WITH order_base AS (
	SELECT
		order_id,
		DATE_TRUNC('quarter', order_purchase_timestamp) AS order_quarter,
		order_status,
		is_approved,
		is_delivered,
		is_reviewed
	FROM vw_order_customer
),
-- Drop-off from Ordered → Approved (orders that never got approved, delivered, and reviewed)
ordered_to_approved_dropoff AS (
	SELECT
		order_quarter,
		1 AS step_num,
		'Ordered' AS step_from,
		'Approved' AS step_to,
		order_status AS reason,
		COUNT(order_id) AS drop_off_order_cnt
	FROM order_base
	WHERE 
		is_approved = 0
		AND is_delivered = 0
		AND is_reviewed = 0 -- Exclude orders with inconsistent lifecycle states (e.g. reviewed but not delivered)
	GROUP BY
		order_quarter,
		order_status
),
-- Drop-off from Approved → Delivered (approved orders that were not delivered and reviewed)
approved_to_delivered_dropoff AS (
	SELECT
		order_quarter,
		2 AS step_num,
		'Approved' AS step_from,
		'Delivered' AS step_to,
		order_status  AS reason,
		COUNT(order_id) AS drop_off_order_cnt
	FROM order_base
	WHERE
		is_approved = 1
		AND is_delivered = 0
		AND is_reviewed = 0 -- Exclude orders with inconsistent lifecycle states (e.g. reviewed but not delivered)
	GROUP BY
		order_quarter,
		order_status
),
-- Union all steps
all_dropoffs AS (
	SELECT * FROM ordered_to_approved_dropoff
	UNION ALL
	SELECT * FROM approved_to_delivered_dropoff
),
-- Total orders per quarter (base for Ordered → Approved)
total_ordered_per_quarter AS (
	SELECT
		order_quarter,
		COUNT(order_id) AS total_ordered_cnt
	FROM order_base
	GROUP BY
		order_quarter
),
-- Total approved orders per quarter (base for Approved → Delivered)
total_approved_per_quarter AS (
	SELECT
		order_quarter,
		COUNT(order_id) AS total_approved_cnt
	FROM order_base
	WHERE is_approved = 1
	GROUP BY order_quarter
)

-- Final select calculates:
-- 1) pct_of_drop_off: percent of each drop-off reason relative to the relevant step per quarter
-- 2) pct_of_total_order_by_quarter: percent of each drop-off reason relative to overall total orders per quarter (global view)
SELECT
	ad.order_quarter,
	ad.step_num,
	ad.step_from,
	ad.step_to,
	ad.reason,
	ad.drop_off_order_cnt,
	ROUND((100 * ad.drop_off_order_cnt::NUMERIC / SUM(ad.drop_off_order_cnt) OVER (PARTITION BY ad.order_quarter, ad.step_num)), 2) AS pct_of_drop_off,
	CASE
		WHEN ad.step_num = 1 THEN ROUND((100 * ad.drop_off_order_cnt::NUMERIC / toq.total_ordered_cnt), 3)
		WHEN ad.step_num = 2  AND taq.total_approved_cnt > 0 THEN ROUND((100 * ad.drop_off_order_cnt::NUMERIC / taq.total_approved_cnt), 3)
	END AS pct_of_total_order_by_quarter
FROM all_dropoffs ad
JOIN total_ordered_per_quarter toq ON ad.order_quarter = toq.order_quarter
LEFT JOIN total_approved_per_quarter taq ON ad.order_quarter = taq.order_quarter
ORDER BY
	ad.order_quarter,
	ad.step_num,
	pct_of_drop_off DESC;