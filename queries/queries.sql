-- Q1: How many orders were placed?

SELECT
    COUNT(*) AS total_orders
FROM
    olist_orders;

-- Q2: How many orders were delivered vs cancelled vs other statuses?

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM
    olist_orders
GROUP BY
    order_status
ORDER BY
    total_orders DESC;


-- Q3: what is the total revenue generated?

SELECT
    ROUND(SUM(price), 2)AS product_revenue,
    ROUND(SUM(price + freight_value), 2) AS gross_revenue
FROM
    olist_order_items;


-- Q4: which are the top 10 product categories by number of orders?

SELECT
    e.product_category_name_english,
    COUNT(*) AS total_orders
FROM
    olist_products p
JOIN olist_order_items o ON p.product_id = o.product_id
JOIN product_category_name_translation e ON p.product_category_name = e.product_category_name
GROUP BY
    e.product_category_name_english
ORDER BY
    total_orders DESC
LIMIT 
    10;



-- Q5: What is the average order Value(AOV)?

SELECT
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT
        order_id,
        SUM(price) AS order_total
    FROM
        olist_order_items
    GROUP BY
        order_id
) AS order_totals;


-- Q6: How many Unique customers placed orders?

SELECT
    COUNT( DISTINCT customer_unique_id) AS unique_customers
FROM
    olist_customers;


-- Q7: which Payment method is the most popular?

SELECT
    payment_type,
    COUNT(*) AS payment_method_count
FROM
    olist_order_payments
GROUP BY
    payment_type
ORDER BY
    payment_method_count DESC;


-- Q8: what is the average review scores across all orders?

SELECT
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM
    olist_order_reviews;


SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM
    olist_order_reviews
GROUP BY
    review_score
ORDER BY
    review_score DESC;
    

-- Q9: which state has the most customers?

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM
    olist_customers
GROUP BY
    customer_state
ORDER BY
    total_customers DESC
LIMIT
    10;


-- Q10: How many orders were placed each Month ?

SELECT
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS year_month,
    COUNT(*) AS total_orders
FROM
    olist_orders
GROUP BY
    year_month
ORDER BY
    year_month ASC;


-- Q11: what is the month over month reveneu growth?

WITH monthly_revenue AS (
    SELECT
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS year_month,
        ROUND(SUM(oi.price), 2) AS revenue
    FROM
        olist_orders o
    JOIN
        olist_order_items oi ON o.order_id = oi.order_id
    GROUP BY
        year_month
),
growth AS (
    SELECT
        year_month,
        revenue AS monthly_revenue,
        LAG(revenue, 1) OVER (ORDER BY year_month) AS prev_month_revenue
    FROM
        monthly_revenue
)
SELECT
    year_month,
    monthly_revenue,
    prev_month_revenue,
    ROUND(((monthly_revenue - prev_month_revenue) / prev_month_revenue) * 100, 2) AS growth_percentage
FROM
    growth
ORDER BY
    year_month;


-- Q12: who are top 10 sellers by revenue?

SELECT  
    oi.seller_id,
    os.seller_city,
    os.seller_state,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.price) DESC) AS rank
FROM
    olist_order_items oi
JOIN olist_sellers os ON oi.seller_id = os.seller_id
GROUP BY
    oi.seller_id,
    os.seller_city,
    os.seller_state
ORDER BY
    rank
LIMIT
    10;


-- Q13: what percentage of orders had a 5-star review?

SELECT
    COUNT(*) AS total_reviews,
    ROUND(
        (SUM(CASE WHEN review_score = 5 THEN 1 ELSE 0 END) * 100.0)
        / COUNT(*),
        2
    ) AS percentage_5_star_reviews
FROM
    olist_order_reviews;


-- Q14: What is the average Delivery time in days per state?

SELECT
    ROUND(
        AVG(DATE_PART('day', o.order_delivered_customer_date - o.order_purchase_timestamp))::numeric,
        2) AS avg_delivery_days,
    oc.customer_state AS states
FROM
    olist_orders o
JOIN olist_customers oc ON o.customer_id = oc.customer_id
WHERE
    o.order_status = 'delivered' AND
    o.order_delivered_customer_date IS NOT NULL
GROUP BY
    states
ORDER BY   
    avg_delivery_days DESC;


-- Q15: which customers are repeat buyers - placed more than 1 order?

SELECT COUNT(*) AS repeat_customers
FROM(
    SELECT
        oc.customer_unique_id
    FROM
        olist_orders o
    JOIN olist_customers oc ON o.customer_id = oc.customer_id
    GROUP BY
        oc.customer_unique_id
    HAVING
        COUNT(o.order_id) > 1
);



-- Q16: What is the running total of the revenue ovetime?
WITH monthly_revenue AS (
    SELECT
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS year_month,
        ROUND(SUM(oi.price), 2) AS monthly_revenue
    FROM
        olist_orders o
    JOIN
        olist_order_items oi ON o.order_id = oi.order_id
    GROUP BY
        year_month
)
SELECT
    year_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY year_month) AS running_total
FROM
    monthly_revenue;


-- Q17: which product categories have the highest average frieght cost?

SELECT
    pc.product_category_name_english,
    ROUND(AVG(oi.freight_value), 2) AS avg_fregiht_cost
FROM
    olist_order_items oi
JOIN olist_products op ON oi.product_id = op.product_id
JOIN product_category_name_translation pc ON op.product_category_name = pc.product_category_name
GROUP BY   
    pc.product_category_name_english
ORDER BY
    avg_fregiht_cost DESC
LIMIT 
    10;



-- Q18: Are late deliveries correlated with low review scores?

SELECT
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS total_orders
FROM
    olist_orders o
JOIN 
    olist_order_reviews r ON o.order_id = r.order_id
WHERE
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY
    delivery_status
ORDER BY
    avg_review_score DESC;



-- Q19: Which seller were active across multiple months? -Seller retention

SELECT
    seller_id,
    COUNT(DISTINCT TO_CHAR(shipping_limit_date, 'YYYY-MM')) AS active_months
FROM
    olist_order_items
GROUP BY
    seller_id
HAVING
    COUNT(DISTINCT TO_CHAR(shipping_limit_date, 'YYYY-MM')) > 6
ORDER BY
    active_months DESC;



-- Q20: Rank customers by Total Spending

SELECT
    oc.customer_unique_id,
    SUM(oi.price) AS total_spending,
    DENSE_RANK() OVER (ORDER BY SUM(oi.price) DESC) AS rank
FROM
    olist_order_items oi     
JOIN 
    olist_orders o ON oi.order_id = o.order_id
JOIN
    olist_customers oc ON o.customer_id = oc.customer_id
GROUP BY
    oc.customer_unique_id
ORDER BY
    rank
LIMIT 10;





