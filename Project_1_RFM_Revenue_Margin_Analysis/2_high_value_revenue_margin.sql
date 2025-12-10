-- Calculate total orders and total revenue per customer based on product category
WITH customer_category_revenue AS (
	SELECT
		vcr.customerkey,
		vcr.rfm_segment,
		p.categoryname,
		p.subcategoryname,
		SUM(s.quantity) AS total_order,
		SUM(s.quantity * s.netprice / s.exchangerate) AS total_revenue_per_customer
	FROM vw_customer_rfm vcr
	JOIN sales s ON vcr.customerkey = s.customerkey
	JOIN product p ON s.productkey = p.productkey
	WHERE
		vcr.rfm_segment IN ('Champions', 'Loyal')
	GROUP BY
		vcr.customerkey,
		vcr.rfm_segment,
		p.categoryname,
		p.subcategoryname
)

-- Final output: Calculate total units, total revenue, average revenue per customer, and percentage of revenue contribution per segment & category
SELECT
	rfm_segment,
	categoryname,
	subcategoryname,
	SUM(total_order) AS total_units,
	ROUND(SUM(total_revenue_per_customer)::NUMERIC, 2) AS total_revenue,
	ROUND(AVG(total_revenue_per_customer)::NUMERIC, 2) AS avg_revenue_per_customer,
	ROUND(
		(100.0 * SUM(total_revenue_per_customer) 
			/
		 SUM(SUM(total_revenue_per_customer)) OVER (PARTITION BY rfm_segment)
		)::NUMERIC
	, 2) AS revenue_share_pct
FROM customer_category_revenue
GROUP BY
	rfm_segment,
	categoryname,
	subcategoryname
ORDER BY 
	rfm_segment,
	total_revenue DESC;
