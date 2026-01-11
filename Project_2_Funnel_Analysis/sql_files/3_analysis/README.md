# Funnel, Drop-off, and Behavior Analysis

This folder contains SQL queries used to analyze customer behavior across the order funnel by cohort year.  
All queries here are built on top of prepared views (`mv_customer_cohort` and `vw_order_customer`) and focus on aggregations used for visualization, which are later visualized and interpreted in Python.

## Analysis Scope

The SQL analysis in this folder covers four main areas:
1. Customer funnel progression
2. Funnel drop-off breakdown
3. Post-delivery review behavior
4. Anomaly and data consistency checks

## 1. Funnel Customer Analysis

**SQL file:** [01_funnel_customer_order_by_cohort.sql](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/sql_files/3_analysis/01_funnel_customer_order_by_cohort.sql)

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

**SQL file:** [02_dropoff_analysis_by_status.sql](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/sql_files/3_analysis/02_dropoff_analysis_by_status.sql)

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

## 3. Review Behavior Analysis

**SQL file:** [03_funnel_review_engagement_by_cohort.sql](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/sql_files/3_analysis/03_funnel_review_engagement_by_cohort.sql)

This query analyzes review behavior after orders are delivered.  
Since leaving a review is optional, this analysis is treated as **customer behavior**, not funnel drop-off.

The query:
- Filters only approved and delivered orders
- Groups results by cohort year and order quarter
- Counts how many delivered orders were not reviewed
- Calculates the share of non-reviewed orders relative to delivered orders

The output is used to understand post-purchase engagement patterns separately from funnel performance.

## 4. Anomaly and Data Consistency Checks

**SQL file:** [04_anomaly_checks.sql](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/sql_files/3_analysis/04_anomaly_checks.sql)

This analysis looks for unusual or inconsistent order states, grouped by cohort year and order quarter.

Examples of anomalies include:
- Delivered orders that were not approved
- Reviewed orders that were not approved
- Reviews created before delivery
- Reviews appearing while orders are still in the pipeline

Each anomaly type is:
- Counted per cohort and quarter
- Compared to the relevant order base (delivered or reviewed)
- Also compared to all orders in the same cohort and quarter

This step helps surface data patterns that may require further investigation.
