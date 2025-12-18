# 📊 Customer Segmentation & Revenue Analysis (RFM)

## Introduction
Understanding customer value goes beyond knowing who buys the most. In many businesses, a small group of customers often contributes a large portion of revenue, but high revenue does not always mean high profit.

This project uses RFM (Recency, Frequency, Monetary) analysis to segment customers and connects those segments with product-level revenue and margin performance.
The goal is to better understand customer behavior, product demand, and profitability trade-offs in a practical, business-oriented way.

## Business Questions
This project focuses on understanding customer value and product performance using RFM segmentation. The analysis is guided by the following business questions: 
1. How are customers spread across different RFM segments, and which segments generate the most revenue relative to their size? 
2. How are recency, frequency, and monetary value distributed across customers?
3. Which product categories generate the highest sales volume among high-value customer segments, such as Champions and Loyal customers?
4. How does revenue break down by category and subcategory for high-value customer segments?
5. Which categories drive revenue, and which ones are actually more profitable? 

## Data & Methodology
### Data Source
The analysis uses the Microsoft Contoso sample dataset (~199,000 rows), obtained from Luke Barousse’s data analytics resources. The dataset contains transactional sales data along with customer and product attributes. The dataset is relatively clean and structured, so no extensive data cleaning was required.

### Methodology
This project combines SQL and Python to analyze customer behavior and product performance. SQL is used to prepare analytical datasets by aggregating transactional data, segmenting customers, and calculating key business metrics. Python is then used to further analyze these datasets and create visualizations that highlight patterns, comparisons, and trade-offs across customer segments and product categories.

## Tools Used
- **PostgreSQL**: Customer-level metric preparation, RFM scoring, and aggregation for analysis
- **Python**: Exploratory analysis and data visualization
  - **Pandas**
  - **Matplotlib**
  - **Seaborn**
- **Visual Studio Code** and **DBeaver**: Development and database tools
- **Jupyter Notebook**: Notebook environment

## Analysis
### Q1. How are customers spread across different RFM segments, and which segments generate the most revenue relative to their size?
**Approach**
- Aggregated customer-level transaction data to calculate recency, frequency, and monetary value
- Assigned RFM scores using percentile-based thresholds
- Classified customers into standard RFM segments
- Compared segment size and total revenue contribution

**SQL**
- Query: [1_create_rfm_segmentation_view.sql](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/1_create_rfm_segmentation_view.sql)  
This query creates a reusable RFM segmentation view using percentile-based scoring.

**Visualization**
- RFM segment distribution and revenue contribution (treemap)
- Built using Python (Pandas, Matplotlib), code: [3_visualization.ipynb](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/3_visualization.ipynb)  
![RFM Segment Treemap](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/images/RFM_segment_treemap.png)
