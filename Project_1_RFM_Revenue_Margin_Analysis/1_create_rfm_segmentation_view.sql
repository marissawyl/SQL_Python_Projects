CREATE OR REPLACE VIEW vw_customer_rfm AS
-- Get raw customer-level metrics
WITH customer_raw AS (
	SELECT
		c.customerkey,
		-- Combine first and last name
		CONCAT(c.givenname, ' ', c.surname) AS customer_name,
		-- Last purchase date for each customer
		MAX(s.orderdate) AS last_purchase_date,
		-- Count unique orders
		COUNT(DISTINCT s.orderkey) AS purchase_cnt,
		-- Total spending converted using exchange rate
		ROUND(SUM((s.quantity * s.netprice) / s.exchangerate)::NUMERIC, 2) AS total_spent
	FROM customer c
	JOIN sales s ON s.customerkey = c.customerkey
	GROUP BY c.customerkey
),
-- Prepare RFM raw values
rfm_raw AS (
	SELECT
	 	customerkey,
	 	customer_name,
	 	last_purchase_date,
		-- Recency: days since last purchase
	 	(SELECT MAX(orderdate) FROM sales) - last_purchase_date AS recency,
		-- Frequency: number of orders
	 	purchase_cnt AS frequency,
		-- Monetary: total spending
	 	total_spent AS monetary
	FROM customer_raw
),
-- Get percentile cutoffs for R, F, M scoring
percentile_values AS (
	SELECT
		-- 20th, 40th, 60th, 80th percentiles for each metric
		PERCENTILE_CONT(ARRAY[.2,.4,.6,.8]) WITHIN GROUP (ORDER BY recency) AS rec,
		PERCENTILE_CONT(ARRAY[.2,.4,.6,.8]) WITHIN GROUP (ORDER BY frequency) AS freq,
		PERCENTILE_CONT(ARRAY[.2,.4,.6,.8]) WITHIN GROUP (ORDER BY monetary) AS mon
	FROM rfm_raw
),
-- Assign RFM scores using the percentile cutoffs
rfm_score AS (
	SELECT
		r.customerkey,
		r.customer_name,
		r.last_purchase_date,
		r.recency,
		r.frequency,
		r.monetary,
		-- Recency score: lower recency = better score
		5 - (r.recency >= p.rec[1]::INT)::INT
		  - (r.recency >= p.rec[2]::INT)::INT
		  - (r.recency >= p.rec[3]::INT)::INT
		  - (r.recency >= p.rec[4]::INT)::INT AS rec_score,

		-- Frequency score: higher frequency = better score
		5 - (r.frequency <= p.freq[1]::INT)::INT
		  - (r.frequency <= p.freq[2]::INT)::INT
		  - (r.frequency <= p.freq[3]::INT)::INT
		  - (r.frequency <= p.freq[4]::INT)::INT AS freq_score,

		-- Monetary score: higher spending = better score
		5 - (r.monetary <= p.mon[1]::INT)::INT
		  - (r.monetary <= p.mon[2]::INT)::INT
		  - (r.monetary <= p.mon[3]::INT)::INT
		  - (r.monetary <= p.mon[4]::INT)::INT AS mon_score
	FROM rfm_raw r
	CROSS JOIN percentile_values p
)

SELECT
	customerkey,
	customer_name,
	last_purchase_date,
	recency,
	frequency,
	monetary,
	rec_score,
	freq_score,
	mon_score,

	-- Assign customer segment based on RFM scores
	CONCAT(rec_score, '-', freq_score, '-', mon_score) AS rfm_score,
        CASE
            WHEN rec_score = 5 AND freq_score >= 4 AND mon_score >= 4 THEN 'Champions'
            WHEN rec_score >= 3 AND freq_score >= 4 AND mon_score >= 3 THEN 'Loyal'
            WHEN rec_score >= 3 AND freq_score BETWEEN 2 AND 3 AND mon_score >= 3 THEN 'Potential Loyalists'
            WHEN rec_score >= 4 AND freq_score >= 3 AND mon_score <= 2 THEN 'Active Low Spenders'
            WHEN rec_score = 5 AND freq_score = 1 THEN 'New Customers / Recent'
            WHEN rec_score >= 4 AND freq_score <= 2 THEN 'Promising'
            WHEN rec_score BETWEEN 2 AND 3 AND freq_score <=3 AND mon_score >= 3 THEN 'Need Attention'
            WHEN rec_score BETWEEN 2 AND 3 AND mon_score <= 2 THEN 'About To Sleep'
            WHEN rec_score <= 2 AND freq_score >= 3 AND mon_score >= 3 THEN 'At Risk'
            WHEN rec_score = 1 AND freq_score <= 2 AND mon_score >= 3 THEN 'Cannot Lose Them'
            WHEN rec_score = 1 AND mon_score <= 2 THEN 'Lost'
        END AS rfm_segment
		
FROM rfm_score

ORDER BY customerkey;
