# Funnel, Drop-off, and Behavior Analysis

This folder contains SQL queries used to analyze customer behavior across the order funnel by cohort year.  
All queries here are built on top of prepared views (`mv_customer_cohort` and `vw_order_customer`) and focus on aggregations that are later used for visualization in Python.

## Analysis Scope## Analysis Scope

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
