-- Index on reviews table: used for the EXISTS check in vw_order_customer
CREATE INDEX idx_reviews_order_id
ON olist_order_reviews(order_id);

-- Index on orders table: used when joining orders with customers
CREATE INDEX idx_orders_customer_id
ON olist_orders(customer_id);

-- Index on customers table: used to join with the customer_cohort view
CREATE INDEX idx_customer_unique_id
ON olist_customers(customer_unique_id);

-- Index on materialized cohort view: used to join by customer_unique_id
CREATE INDEX idx_mv_customer_cohort_unique_id
ON mv_customer_cohort(customer_unique_id);