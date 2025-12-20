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
- Aggregated customer-level transaction data to calculate recency, frequency, and monetary value.
- Assigned RFM scores using percentile-based thresholds.
- Classified customers into standard RFM segments.
- Compared segment size and total revenue contribution.

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
- At-Risk Segments:  
Use targeted re-engagement campaigns and personalized incentives to bring at-risk customers back, protecting revenue that could be lost if they churn.
- Overall, shifting customers up the RFM ladder is likely to be more impactful than acquiring new low-value customers.

### Q2. How are recency, frequency, and monetary value distributed across customers?
#### **Approach**
- Converted recency from days to months for easier interpretation.
- Analyzed the distribution of recency, frequency, and monetary value at the customer level.
- Compared mean and median values to understand skewness in customer behavior.

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
- Recency: Prioritize targeted win-back campaigns (emails, offers, retargeting) for recently dormant customers to increase engagement.
- Frequency: Encourage repeat purchases through loyalty programs, subscription models, or post-purchase engagement.
- Monetary: Focus on high-value customer retention and upsell opportunities with VIP perks and personalized recommendations.

### Q3. Which product categories generate the highest sales volume among high-value customer segments, such as Champions and Loyal customers?
#### **Approach**
- Focused on high-value RFM segments: Champions and Loyal customers.
- Aggregated total units sold by product category for each segment.
- Compared category-level purchase patterns between the two segments.

#### **SQL**
- Query: [2_high_value_customer_category_analysis.sql](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/2_high_value_customer_category_analysis.sql)  
This query aggregates category-level sales metrics for Champions and Loyal customers.

#### **Visualization**
- Horizontal bar charts showing total units sold by product category
- Built using Python (Pandas, Seaborn, Matplotlib). Code: [3_visualization.ipynb](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/3_visualization.ipynb)  

![Product Category Performance](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/images/product_category_performance.png)

#### **Key Findings**
- Computers and Cell Phones are the top-selling categories for both Champions and Loyal customers.
- Entertainment-related categories (Music, Movies, and Audio Books; Games and Toys) show strong demand from both segments.
- Cameras and Audio show limited demand among high-value customers, suggesting a smaller market compared to core categories like Computers and Cell Phones.
- Loyal customers purchase higher volumes overall compared to Champions across most categories.

#### **Business Insights**
- Computers and Cell Phones are key volume drivers for high-value customers and should remain a priority for inventory and promotions.
- Loyal customers contribute higher purchase volumes across most categories, making them good targets for cross-category campaigns, bundles, and repeat-purchase incentives.
- Champions generate high value despite lower purchase volume, so focusing on premium offerings and exclusive benefits is likely more effective than pushing discounts to increase quantity.
- Categories like Movies, Games, and Music are popular in both segments and can be used as complementary products to increase basket size.

### Q4. How does revenue break down by category and subcategory for high-value customer segments?
#### **Approach**
- Focused on high-value RFM segments: Champions and Loyal customers.
- Aggregated total revenue at the product subcategory level and grouped it under each main product category.
- Compared revenue patterns between Champions and Loyal customers to understand which categories and subcategories generate the most revenue.

#### **SQL**
- Query: [2_high_value_customer_category_analysis.sql](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/2_high_value_customer_category_analysis.sql)  
This query aggregates category-level sales metrics for Champions and Loyal customers.

#### **Visualization**
- Revenue distribution by product category and subcategory using horizontal stacked bar charts.
- Built using Python (Pandas, Matplotlib). Code: [3_visualization.ipynb](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/3_visualization.ipynb)  

![Revenue Distribution Subcat](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/images/revenue_distribution_subcat.png)

#### **Key Findings**
- Revenue in Computers category is mainly driven by a few dominant subcategories such as Desktops, Laptops, and Projectors for both Champions and Loyal customers.
- Within the Cell Phones category, revenue is concentrated in a small number of core subcategories, while other subcategories contribute relatively less to total revenue.
- Some Home Appliances subcategories generate relatively high revenue in Q4 despite having lower sales volume in Q3, suggesting higher-priced or higher-value products.
- Cameras and Audio subcategories generate relatively low revenue, which is consistent with their lower sales volume observed in Q3 and indicates lower demand among high-value customers.
- Although Loyal customers purchase higher volumes overall (as shown in Q3), both Champions and Loyal show similar subcategory preferences.

#### **Business Insights**
- Most revenue comes from a small number of core subcategories, such as laptops, desktops, and main phone products. Focusing pricing, inventory, and promotions on these subcategories will have a much bigger impact than spreading effort across many smaller products.
- Some Home Appliances subcategories generate strong revenue despite lower sales volume. These products should be positioned as higher-value items, where margin and pricing matter more than pushing volume through discounts.
- Subcategories with consistently low revenue and low sales volume should be treated as supporting or add-on products, while Champions and Loyal customers can be served with a similar product mix but different pricing or bundle strategies.

### Q5. Which categories drive revenue, and which ones are actually more profitable?
#### **Approach**
- Aggregated total revenue by product category for high-value customer segments (Champions and Loyal).
- Calculated category-level margin using a weighted average based on revenue contribution.
- Compared revenue size and margin level side by side to identify trade-offs between volume and profitability.

#### **SQL**
- Query: [2_high_value_customer_category_analysis.sql](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/2_high_value_customer_category_analysis.sql)  
This query aggregates category-level sales metrics for Champions and Loyal customers.

#### **Visualization**
- Revenue and margin comparison by product category for Champions and Loyal customers (bar + line chart).
- Built using Python (Pandas, Matplotlib). Code: [3_visualization.ipynb](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/3_visualization.ipynb)  

![Revenue Margin](https://github.com/marissawyl/SQL-Python-Projects/blob/main/Project_1_RFM_Revenue_Margin_Analysis/images/revenue_margin.png)

#### **Key Findings**
- Computers generate the highest revenue for both Champions and Loyal customers, with relatively strong margins.
- Some mid-revenue categories, such as TV & Video and Music, Movies, and Audio Books, show good margins even though their revenue is not very high.
- Audio and Games & Toys contribute little revenue and low margins, making them less important for overall performance.

#### **Business Insights**
- Categories like Computers should remain a top priority because they combine high revenue with strong margins, giving the biggest impact on overall results.
- Mid-revenue but higher-margin categories (such as TV & Video and Music, Movies, and Audio Books) can be used to improve profitability, especially when bundled with core products like Computers or Cell Phones rather than heavily discounted.
- Champions and Loyal customers buy similar product categories, so category-level pricing and product decisions are likely more effective than segment-specific promotions.

## Strategic Recommendations
- Prioritize retention for Champions and Loyal customers with loyalty programs, exclusive offers, and premium benefits to protect key revenue.
- Focus on upsell and engagement strategies for Potential Loyalists and Need Attention customers to move them up the RFM ladder.
- Re-engage At-Risk customers with targeted campaigns and personalized incentives to recover potentially lost revenue.
- Prioritize core categories like Computers and Cell Phones for inventory, promotions, and premium offerings.
- Use complementary categories like Movies, Games, and Music to increase basket size among Loyal and Champion customers.
- Focus on high-revenue, high-margin categories for maximum impact, and bundle mid-margin categories with core products to improve profitability.
