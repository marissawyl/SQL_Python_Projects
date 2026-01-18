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

#### **Key Findings**
1. Customer cohorts show clear improvement from 2016 to 2018. Later cohorts retain a higher percentage of orders through each funnel stage, from approval to delivery and review.
2. The 2016 cohort shows a noticeable drop after approval, with delivery conversion falling to around 81%, while 2017 and 2018 cohorts maintain delivery rates above 96%.
3. Once an order is delivered, the likelihood of receiving a review remains relatively stable within each cohort. There is no major additional drop after delivery, indicating that delivery is the main bottleneck, not review behavior itself.
4. Orders from the 2018 cohort retain over 97% of customers through delivery and review, suggesting operational improvements or better customer experience compared to earlier years.

#### **Key Findings**
1. Even though almost all orders get approved, a noticeable drop happens before orders are delivered. Improving this stage will have the biggest impact on the overall funnel.
2. Newer customer cohorts show higher conversion rates at almost every step. This suggests that order processing and delivery operations have improved over time.
3. Efforts should focus on approval and delivery processes, not post-delivery engagement, because fixing early issues affects all later steps.

### Q2. What order statuses are most commonly associated with failed progression?

### Q3. How does post-delivery review participation change over time?

### Q4. Are there any anomalies or inconsistencies in the order lifecycle?
