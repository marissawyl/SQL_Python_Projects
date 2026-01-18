# 📊 Funnel, Drop-off, and Behavior Analysis

## Introduction
This project analyzes the customer purchase funnel and drop-off behavior in an e-commerce dataset using SQL and Python. The analysis focuses on understanding where customers drop off, how behavior differs by cohort, and which order statuses contribute most to funnel leakage.

The goal is not only to compute metrics, but to explain customer behavior across funnel stages and translate it into actionable insights.

## Business Questions
The analysis is built around a few practical questions:
1. How does the purchase funnel perform for different customer cohorts?
2. What order statuses are most commonly associated with failed progression?
3. How does post-delivery review participation change over time?
4. Are there any anomalies or inconsistencies in the order lifecycle?

## Data & Methodology
### Data Source
The project uses the Olist e-commerce dataset, which includes order transactions, customer information, delivery status, and customer reviews. The data structure is well suited for funnel analysis, allowing clear identification of order progression and outcomes.

### Methodology
The workflow combines SQL for data modeling and Python for analysis and visualization.
- SQL is used to:
  - Create customer cohorts materialized view based on first purchase
  - Build order-level views with approval, delivery, and review flags
  - Calculate funnel conversion and drop-off metrics
- Python is used to:
  - Query analytical tables
  - Visualize funnel performance by cohort
  - Explore drop-off composition and review behavior

## Tools Used
- **PostgreSQL**: Funnel logic, cohort modeling, drop-off calculations
- **Python**: Data analysis and visualization
  - **Pandas**
  - **Matplotlib**
  - **Seaborn**
- **SQLAlchemy & psycopg2**: Database connection
- **Visual Studio Code & DBeaver**: Development and database tools
- **Jupyter Notebook**: Notebook environment

## Analysis
### Q1. How does the purchase funnel perform for different customer cohorts?
#### **Approach**
- Identified each customer’s cohort year based on their first order.
- Modeled the funnel steps: Ordered → Approved → Delivered → Reviewed
- Conversion and drop-off rates are calculated at each step for every cohort.

#### **SQL**
- Query: [01_funnel_customer_order_by_cohort.sql](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/sql_files/3_analysis/01_funnel_customer_order_by_cohort.sql)
Calculates funnel size, conversion rate, and drop-off rate per cohort year.

#### **Visualization**
- Order-to-review conversion funnel by cohort
- Built using Python (Pandas, Matplotlib, Seaborn). Code: [01_funnel_customer_order.ipynb](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/python_files/01_funnel_customer_order.ipynb)

![order_to_review_conversion_funnel](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/images/order_to_review_conversion_funnel.png)

### Q2. What order statuses are most commonly associated with failed progression?

### Q3. How does post-delivery review participation change over time?

### Q4. Are there any anomalies or inconsistencies in the order lifecycle?
