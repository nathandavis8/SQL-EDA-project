/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
	- CONCAT(): for '%' integration for easier reading
===============================================================================
*/
--Which categories contribute the most to overall sales?
WITH category_sales AS (
SELECT
category,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY category)

SELECT
category,
total_sales,
SUM(total_sales) OVER() overall_sales,
CONCAT(ROUND((CAST (total_sales AS FLOAT) / SUM(total_sales) OVER())*100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;


--Which categories has the least orders?
WITH category_sales AS (
SELECT
category,
SUM(quantity) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY category)

SELECT
category,
total_orders,
SUM(total_orders) OVER() overall_sales,
CONCAT(ROUND((CAST (total_orders AS FLOAT) / SUM(total_orders) OVER())*100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_orders;
