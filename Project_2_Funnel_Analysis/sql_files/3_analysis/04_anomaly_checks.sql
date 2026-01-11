-- The aim of this query is to analyze the anomalies in the orders by cohort year and order quarter.
-- Anomalies are cases that don't follow normal order flow, such as delivered orders that were not approved, or reviews created before delivery.

WITH order_base AS (
	-- Base order-level data with cohort and quarterly time dimension
	SELECT
		DATE_TRUNC('quarter', order_purchase_timestamp) AS order_quarter,
		cohort_year,
		order_id,
		order_status,
		is_approved,
		is_delivered,
		is_reviewed
	FROM vw_order_customer
),
anomaly_types_count AS (
	-- Classify each order into an anomaly type and count per cohort and quarter
	SELECT
		cohort_year,
		order_quarter,
		anomaly_type,
		COUNT(order_id) AS order_cnt
	FROM  (
		SELECT
			cohort_year,
			order_quarter,
			order_id,
			CASE
				WHEN is_delivered = 1 AND is_approved = 0
					THEN 'delivered_not_approved'
				WHEN is_reviewed = 1 AND is_approved = 0
					THEN 'reviewed_not_approved'
				WHEN is_reviewed = 1 AND is_delivered = 0 THEN
					CASE
						WHEN order_status IN ('shipped', 'invoiced', 'processing', 'approved')
							THEN 'pipeline_latency'
						WHEN order_status IN ('canceled', 'created', 'unavailable')
							THEN 'review_before_delivery'
					END
			END AS anomaly_type
		FROM order_base
	) t
	WHERE anomaly_type IS NOT NULL
	GROUP BY
		cohort_year,
		order_quarter,
		anomaly_type
),
total_all_orders AS (
	-- Total orders per cohort and quarter (used as the base for overall percentages)
	SELECT
		cohort_year,
		order_quarter,
		COUNT(order_id) AS total_order_cnt
	FROM order_base
	GROUP BY
		cohort_year,
		order_quarter
),
total_related_orders AS (
	-- Total delivered and total reviewed orders per cohort and quarter (used as the base for step-specific percentages)
	SELECT
		cohort_year,
		order_quarter,
		SUM(CASE WHEN is_delivered = 1 THEN 1 ELSE 0 END) AS total_delivered_cnt,
		SUM(CASE WHEN is_reviewed = 1 THEN 1 ELSE 0 END) AS total_reviewed_cnt
	FROM order_base
	GROUP BY
		cohort_year,
		order_quarter
)

-- Final select calculates:
-- 1) pct_of_relevant_orders: percentage of anomalies relative to the relevant step (delivered anomalies vs total delivered, review anomalies vs total reviewed)
-- 2) pct_of_all_orders: percentage of anomalies relative to all orders in the same cohort and quarter
SELECT
	ac.cohort_year,
	ac.order_quarter,
	ac.anomaly_type,
	ac.order_cnt,
	CASE
		WHEN ac.anomaly_type = 'delivered_not_approved' THEN ROUND((100 * ac.order_cnt::NUMERIC / NULLIF(tr.total_delivered_cnt, 0)), 2)
		ELSE ROUND((100 * ac.order_cnt::NUMERIC / NULLIF(tr.total_reviewed_cnt, 0)), 2)
	END AS pct_of_relevant_orders,
	ROUND((100 * ac.order_cnt::NUMERIC / ta.total_order_cnt), 2) AS pct_of_all_orders
FROM anomaly_types_count ac
JOIN total_related_orders tr
	ON ac.cohort_year = tr.cohort_year
	AND ac.order_quarter = tr.order_quarter
JOIN total_all_orders ta
	ON ac.cohort_year = ta.cohort_year
	AND ac.order_quarter = ta.order_quarter
ORDER BY
	ac.cohort_year,
	ac.order_quarter,
	ac.anomaly_type;
