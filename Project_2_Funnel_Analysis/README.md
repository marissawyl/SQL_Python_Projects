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

#### **Business Takeaways**
1. Prioritize improvements in the approval-to-delivery stage, as this is where the biggest losses occur and where changes will have the greatest impact on overall conversion.
2. Review and standardize operational practices used in recent cohorts, since newer cohorts consistently perform better across the funnel.
3. Allocate fewer resources to post-delivery interventions, as drop-off after delivery is minimal and does not appear to be a major problem area.
4. Focus retention and process optimization efforts before delivery, rather than after, to prevent avoidable losses earlier in the customer journey.

### Q2. What order statuses are most commonly associated with failed progression?
#### **Approach**
- Orders are analyzed based on order time (quarter).
- Drop-offs are broken down by order_status to identify common failure reasons.
- Only valid lifecycle states are included (for example, orders reviewed before delivery are excluded)
- Metrics are calculated both relative to the funnel step and to total quarter orders.

#### **SQL**
- Query: [02_dropoff_analysis_by_status.sql](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/sql_files/3_analysis/02_dropoff_analysis_by_status.sql)  
Identifies drop-offs between Ordered → Approved and Approved → Delivered, including drop-off reasons.

#### **Visualization**
- Stacked bar chart showing drop-off composition by order status
- Built using Python (Pandas, Matplotlib). Code: [02_dropoff_analysis.ipynb](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/python_files/02_dropoff_analysis.ipynb)

![dropoff_analysis](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/images/dropoff_analysis.png)

#### **Key Findings**
1. For Ordered → Approved, drop-offs are typically dominated by a single status per quarter, suggesting early-stage failures are concentrated in specific order states.
2. For Approved → Delivered, drop-offs are more spread across multiple statuses, indicating more complex operational issues after approval.
3. The dominant drop-off reasons change over time, showing that failure patterns are not static across quarters.

#### **Business Takeaways**
1. Focus improvement efforts on the largest drop-off status observed in each quarter’s analysis to maximize impact.
2. For the Approved → Delivered stage, address drop-offs across multiple checkpoints (e.g. shipping, availability, invoicing) instead of focusing on one root cause.

### Q3. How does post-delivery review participation change over time?
#### **Approach**
- The analysis focuses only on delivered orders.
- It measures how many delivered orders do not receive a review.
- Results are analyzed by cohort and by order quarter.

#### **SQL**
- Query: [03_funnel_review_engagement_by_cohort.sql](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/sql_files/3_analysis/03_funnel_review_engagement_by_cohort.sql)  
Aggregates delivered vs non-reviewed orders by cohort and time period.

#### **Visualization**
- Heatmap of non-reviewed delivered orders by cohort and quarter
- Built using Python (Pandas, Matplotlib). Code: [03_funnel_review_engagement.ipynb](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/python_files/03_funnel_review_engagement.ipynb)
- Darker cells indicate higher anomaly rates, while blank cells represent periods with no data.

![funnel_review_engagement](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/images/funnel_review_engagement.png)

#### **Key Findings**
1. Across all cohorts and quarters, the share of delivered orders that were not reviewed is very low (generally below 2.5%).
2. Cohort 2017 shows stable review behavior over time, with most quarters around 0.7–0.8%.
3. Cohort 2017 shows stable review behavior over time, with most quarters around 0.7–0.8%.
4. Cohort 2018 has the lowest and declining non-review rate, dropping to below 0.5% in later quarters.

#### **Business Takeaways**
1. Since very few delivered orders are not reviewed, review participation is not a major problem in the funnel.
2. The spike in 2018Q1 should be checked for potential anomalies, such as system issues or changes in the review process.
3. Reuse recent cohort practices as the baseline for post-delivery engagement, instead of redesigning the review flow.

### Q4. Are there any anomalies or inconsistencies in the order lifecycle?
#### **Approach**
- This analysis focuses on identifying unusual patterns in the order-to-review process.
- Anomaly rates are calculated by cohort and order quarter.
- A heatmap is used to highlight unusual spikes over time.

#### **SQL**
- Query: [04_anomaly_checks.sql](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/sql_files/3_analysis/04_anomaly_checks.sql)  
Classifies and counts different anomaly types by cohort and time period.

#### **Visualization**
- Anomaly rate by quarter per cohort (heatmap)
- Built using Python (Pandas, Matplotlib). Code: [04_anomaly_checks.ipynb](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/python_files/04_anomaly_checks.ipynb)
- Darker cells indicate higher anomaly rates, while blank cells represent periods with no data.

![anomaly_checks](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/images/anomaly_checks.png)

#### **Key Findings**
1. Early cohorts (2016) show very high anomaly rates in the initial quarters, especially for pipeline latency and reviews submitted before delivery.
2. Anomaly rates drop significantly in later cohorts, with 2017 and 2018 showing much lower and more stable values.
3. Pipeline latency anomalies decrease steadily over time, suggesting improvements in order processing and system reliability.
4. Most anomaly types remain below 2% in recent periods, indicating that anomalies are relatively rare in the mature stages of the funnel.

#### **Business Takeaways**
1. Treat early-cohort anomalies as historical issues, not current performance problems, since they are concentrated in the earliest periods.
2. Use recent cohorts (2017–2018) as the operational baseline, as anomaly rates are consistently low and stable.
3. Monitor pipeline latency as a leading signal, since it appears more frequently than other anomaly types and reflects operational health.

## Strategic Recommendations
- Across all analyses, the largest and most consistent losses happen between approval and delivery. This stage shows both the biggest conversion drop (Q1) and the most complex failure reasons (Q2). Improving delivery-related operations will create the biggest overall impact on funnel performance.
- Customer cohorts from 2017–2018 consistently perform better across funnel conversion, review behavior, and anomaly rates (Q1, Q3, Q4). These cohorts should be treated as the reference standard when evaluating processes, setting KPIs, or identifying regressions.
- Drop-off reasons change across quarters (Q2), meaning a single, permanent fix is unlikely to work. Improvement efforts should focus on the dominant failure reason in each period, rather than applying one global solution across all timeframes.
- Both review behavior (Q3) and anomaly rates after delivery (Q4) are consistently low. This indicates that post-delivery engagement is functioning well and does not require major redesign. Resources are better spent preventing failures earlier in the funnel.
- Anomalies are heavily concentrated in early cohorts and early periods (Q4). In recent cohorts, anomaly rates are low and stable, suggesting that system reliability has improved. Anomaly analysis should be used to validate operational health, not as the main driver of funnel optimization.

Overall funnel performance has improved over time, with remaining opportunities concentrated before delivery rather than after, and best addressed through targeted, period-specific operational improvements.
