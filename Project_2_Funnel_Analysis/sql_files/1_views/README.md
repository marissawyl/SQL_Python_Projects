# Customer and Order Views

## 1. Customer Cohort Materialized View

The query groups customers by their unique customer ID and finds the date of their first order. From that first order date, it extracts the year and uses it as the cohort year.

**Result preview:**  
![Customer Cohort Materialized View](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/images/mv.JPG)

## 2. Order Customer View

The query joins order and customer data and links each order to a unique customer and cohort year. It also adds simple flags to show whether an order was approved, delivered, or reviewed.

**Result preview:** 
![Order Customer View](https://github.com/marissawyl/SQL_Python_Projects/blob/main/Project_2_Funnel_Analysis/images/order_customer_view.png)
