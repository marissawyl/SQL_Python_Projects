# Funnel, Drop-off, and Behavior Analysis

This folder contains SQL queries used to analyze customer behavior across the order funnel by cohort year.  
All queries here are built on top of prepared views (`mv_customer_cohort` and `vw_order_customer`) and focus on aggregations that are later used for visualization in Python.

## Analysis Scope

The SQL analysis in this folder covers four main areas:
1. Customer funnel progression
2. Funnel drop-off breakdown
3. Post-delivery review behavior
4. Anomaly and data consistency checks

## 1. Funnel Customer Analysis

This query builds a customer-level funnel by cohort year.

The funnel follows these steps:  
**Ordered → Approved → Delivered → Reviewed**

Key points:
- Funnel grain is customer-level
- Each step uses 'DISTINCT' to ensure a customer is counted only once
- A customer is considered to pass a step if they complete it at least once, even if they place multiple orders

The output shows (per cohort year):
- Number of customers at each funnel step
- Conversion rate from the first step (Ordered)
- Conversion rate compared to the previous step
- Drop-off rate between consecutive steps

This result provides a high-level view of funnel progression per cohort.

## 2. Funnel Drop-off Analysis

This analysis focuses on order-level drop-offs between funnel steps and breaks them down by order_status.

Two transitions are analyzed:
- Ordered → Approved
- Approved → Delivered

For each cohort year and funnel step, the query calculates:
- Drop-off order counts by reason (order status)
- Percentage relative to the relevant funnel step
- Percentage relative to all orders in the cohort (global view)

This helps separate:
- *Where* drop-offs happen in the funnel
- *What status* orders are in when they drop off
