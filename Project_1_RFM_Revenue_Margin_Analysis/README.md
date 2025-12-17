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
#### SQL: Customer Modeling & Aggregation
SQL was used as the primary layer for customer-level modeling and metric preparation. The main steps include:  
**1. Customer-level aggregation**   
   * Combined customer name fields  
   * Identified last purchase date per customer  
   * Calculated purchase frequency and total monetary value  
   * Normalized revenue using exchange rates  
**2. RFM metric calculation**  
   * Recency calculated as days since last transaction  
   * Frequency defined as number of unique orders  
   * Monetary defined as total customer spending  
   * Percentile-based cutoffs (20%, 40%, 60%, 80%) used to assign R, F, and M scores  
**3. Customer segmentation**  
   * Customers were classified into standard RFM segments (e.g. Champions, Loyal, At Risk) based on score combinations  
   * Results were materialized as a reusable SQL view  
**4. Category-level aggregation**  
   * Focused analysis on high-value segments (Champions and Loyal)  
   * Aggregated total units, total revenue, average revenue per customer, and revenue share by product category and subcategory  





