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
#### **Approach**
- Aggregated customer-level transaction data to calculate recency, frequency, and monetary value
- Assigned RFM scores using percentile-based thresholds
- Classified customers into standard RFM segments
- Compared segment size and total revenue contribution

#### **SQL**
- Query: [1_create_rfm_segmentation_view.sql](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/1_create_rfm_segmentation_view.sql)  
This query creates a reusable RFM segmentation view using percentile-based scoring.

#### **Visualization**
- RFM segment distribution and revenue contribution (treemap)
- Built using Python (Pandas, Matplotlib). Code: [3_visualization.ipynb](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/3_visualization.ipynb)  

![RFM Segment Treemap](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/images/rfm_segment_treemap.png)

#### **Key Findings**
- High-value segments (Champions & Loyal) represent a small share of customers (~14%) but contribute a disproportionately large portion of total revenue.
- Mid-value segments (Potential Loyalists, Need Attention, Promising) make up the largest customer base and generate a solid share of revenue.
- Low-value and inactive segments (About to Sleep, Lost, Active Low Spenders) account for a large number of customers but contribute relatively low revenue.
- Revenue contribution is highly concentrated among a few customer segments rather than evenly distributed.

#### **Business Insights**
- High-Value Segments (Champions & Loyal):  
Prioritize retention through loyalty programs, exclusive offers, or premium benefits, as losing even a small number of these customers would have a strong revenue impact.
- Mid-Value Segments (Potential Loyalists & Need Attention):  
Focus on upsell and engagement strategies to move these customers into higher-value segments, as they represent the biggest growth opportunity.
- Low-Value / At-Risk Segments:  
Use targeted re-engagement or cost-efficient promotions to improve activity, while carefully managing marketing spend due to lower revenue return.
- Overall, shifting customers up the RFM ladder is likely to be more impactful than acquiring new low-value customers.

### Q2. How are recency, frequency, and monetary value distributed across customers?
#### **Approach**
- Converted recency from days to months for easier interpretation
- Analyzed the distribution of recency, frequency, and monetary value at the customer level
- Compared mean and median values to understand skewness in customer behavior

#### **SQL**
- Query: [1_create_rfm_segmentation_view.sql](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/1_create_rfm_segmentation_view.sql)  
This query creates a reusable RFM segmentation view using percentile-based scoring.

#### **Visualization**
- Distribution of recency, frequency, and monetary value across customers (histograms)
- Built using Python (Pandas, Matplotlib, Seaborn). Code: [3_visualization.ipynb](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/3_visualization.ipynb)  

![RFM Distribution](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/images/rfm_distribution.png)

#### **Key Findings**
- Recency shows a wide spread, with many customers purchasing recently, but a long tail of inactive customers.
- Frequency is heavily right-skewed, with most customers making only one or two purchases.
- Monetary value is also highly skewed, where a small group of customers accounts for very high spending.
- For all three metrics, the mean is higher than the median, indicating the presence of high-value outliers.

#### **Business Insights**
- Most customers purchase infrequently, suggesting opportunities to increase repeat purchases through reminders, bundles, or incentives.
- A small group of customers drives a disproportionate share of total spending and should be carefully retained.
- Median values better represent the “typical” customer than averages, which are influenced by a few extreme cases.
- Growth efforts should balance activating the large low-engagement base while protecting high-spending customers who skew overall performance.
