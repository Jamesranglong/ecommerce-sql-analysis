# 🛒 E-Commerce Business Intelligence
### End-to-End Sales, Customer & Seller Analysis using PostgreSQL

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue?style=flat&logo=postgresql)
![Domain](https://img.shields.io/badge/Domain-E--Commerce-orange?style=flat)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat)

---

## 📌 Project Overview

This project performs an end-to-end SQL analysis on the **Brazilian E-Commerce Public Dataset by Olist** — a real-world dataset containing 100,000+ orders from a Brazilian marketplace between 2016 and 2018.

The goal is to extract meaningful business insights across **sales performance, customer behaviour, seller analysis, delivery efficiency, and customer satisfaction** — simulating the work of a real Data Analyst in an e-commerce company.

---

## 📂 Dataset

- **Source:** [Kaggle — Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Size:** 100,000+ orders across 9 relational tables
- **Period:** September 2016 — August 2018
- **Domain:** Brazilian E-Commerce Marketplace

### Database Schema

```
olist_orders                        → order status, timestamps
olist_order_items                   → products per order, price, freight
olist_order_payments                → payment type, installments, value
olist_order_reviews                 → review scores and comments
olist_customers                     → customer location info
olist_sellers                       → seller location info
olist_products                      → product category, dimensions, weight
olist_geolocation                   → lat/long of zip codes
product_category_name_translation   → Portuguese to English category names
```

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| PostgreSQL | Database & Query Execution |
| VS Code | Development Environment |
| psql | Database Management |
| SQL | Data Analysis & Querying |

---

## 🚀 How to Reproduce This Project

### Step 1 — Setup Database
```sql
CREATE DATABASE olist_db;
\c olist_db
```

### Step 2 — Create Tables
```sql
CREATE TABLE olist_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);

CREATE TABLE olist_orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE olist_order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

CREATE TABLE olist_order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

CREATE TABLE olist_order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(100),
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE olist_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE olist_sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(5)
);

CREATE TABLE olist_geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(18,15),
    geolocation_lng DECIMAL(18,15),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(5)
);

CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);
```

### Step 3 — Load Data (Mac/Linux)
```sql
\copy olist_customers FROM '/your-path/olist_customers_dataset.csv' DELIMITER ',' CSV HEADER;
\copy olist_orders FROM '/your-path/olist_orders_dataset.csv' DELIMITER ',' CSV HEADER;
\copy olist_order_items FROM '/your-path/olist_order_items_dataset.csv' DELIMITER ',' CSV HEADER;
\copy olist_order_payments FROM '/your-path/olist_order_payments_dataset.csv' DELIMITER ',' CSV HEADER;
\copy olist_order_reviews FROM '/your-path/olist_order_reviews_dataset.csv' DELIMITER ',' CSV HEADER;
\copy olist_products FROM '/your-path/olist_products_dataset.csv' DELIMITER ',' CSV HEADER;
\copy olist_sellers FROM '/your-path/olist_sellers_dataset.csv' DELIMITER ',' CSV HEADER;
\copy olist_geolocation FROM '/your-path/olist_geolocation_dataset.csv' DELIMITER ',' CSV HEADER;
\copy product_category_name_translation FROM '/your-path/product_category_name_translation.csv' DELIMITER ',' CSV HEADER;
```

### Step 4 — Verify Data Load
```sql
SELECT 'customers' AS table_name, COUNT(*) FROM olist_customers
UNION ALL
SELECT 'orders', COUNT(*) FROM olist_orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM olist_order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM olist_order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM olist_order_reviews
UNION ALL
SELECT 'products', COUNT(*) FROM olist_products
UNION ALL
SELECT 'sellers', COUNT(*) FROM olist_sellers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM olist_geolocation
UNION ALL
SELECT 'category_translation', COUNT(*) FROM product_category_name_translation;
```

---

## 📊 Business Questions & SQL Queries

### 🟢 Basic Analysis

---

#### Q1. Total Number of Orders Placed

```sql
SELECT
    COUNT(*) AS total_orders
FROM
    olist_orders;
```

**Result:** 99,441 total orders

---

#### Q2. Order Distribution by Status

```sql
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM
    olist_orders
GROUP BY
    order_status
ORDER BY
    total_orders DESC;
```

| order_status | total_orders |
|---|---|
| delivered | 96478 |
| shipped | 1107 |
| canceled | 625 |
| unavailable | 609 |
| invoiced | 314 |
| processing | 301 |

---

#### Q3. Total Product Revenue vs Gross Revenue

```sql
SELECT
    ROUND(SUM(price), 2) AS product_revenue,
    ROUND(SUM(price + freight_value), 2) AS gross_revenue
FROM
    olist_order_items;
```

| product_revenue | gross_revenue |
|---|---|
| 13,591,643.70 | 16,008,872.13 |

> Freight contributes R$2.4M — roughly 17.8% of gross revenue.

---

#### Q4. Top 10 Product Categories by Number of Orders

```sql
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
LIMIT 10;
```

| product_category | total_orders |
|---|---|
| bed_bath_table | 11115 |
| health_beauty | 9670 |
| sports_leisure | 8641 |
| furniture_decor | 8334 |
| computers_accessories | 7827 |

---

#### Q5. Average Order Value (AOV)

```sql
SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        order_id,
        SUM(price) AS order_total
    FROM
        olist_order_items
    GROUP BY
        order_id
) AS order_totals;
```

**Result:** R$137.75 per order

> AOV is calculated per order not per item — a subquery first sums items per order, then averages those totals.

---

#### Q6. Number of Unique Customers

```sql
SELECT
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM
    olist_customers;
```

**Result:** 96,096 unique customers

> `customer_unique_id` is used instead of `customer_id` because a customer receives a new `customer_id` for every order they place.

---

#### Q7. Most Popular Payment Methods

```sql
SELECT
    payment_type,
    COUNT(*) AS payment_method_count
FROM
    olist_order_payments
GROUP BY
    payment_type
ORDER BY
    payment_method_count DESC;
```

| payment_type | count |
|---|---|
| credit_card | 76795 |
| boleto | 19784 |
| voucher | 5775 |
| debit_card | 1529 |

---

#### Q8. Average Review Score & Score Distribution

```sql
-- Overall Average
SELECT
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM
    olist_order_reviews;

-- Distribution
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
```

**Overall Average: 4.09 / 5**

| review_score | total_reviews | percentage |
|---|---|---|
| 5 ⭐ | 57328 | 57.78% |
| 4 ⭐ | 19142 | 19.29% |
| 3 ⭐ | 8179 | 8.24% |
| 2 ⭐ | 3151 | 3.18% |
| 1 ⭐ | 11424 | 11.51% |

---

#### Q9. Top 10 States by Customer Count

```sql
SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM
    olist_customers
GROUP BY
    customer_state
ORDER BY
    total_customers DESC
LIMIT 10;
```

| state | total_customers |
|---|---|
| SP | 40952 |
| RJ | 12496 |
| MG | 11370 |
| RS | 5351 |
| PR | 4929 |

---

#### Q10. Monthly Order Volume Trends

```sql
SELECT
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS year_month,
    COUNT(*) AS total_orders
FROM
    olist_orders
GROUP BY
    year_month
ORDER BY
    year_month ASC;
```

**Key Finding:** Clear upward growth from 2016 → 2018, with a Black Friday spike in November 2017 (7,544 orders).

---

### 🔴 Advanced Analysis

---

#### A1. Month-over-Month Revenue Growth

```sql
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
```

**Key Finding:** November 2017 recorded +52.10% MoM growth driven by Black Friday. Revenue plateaued around R$850K–R$996K through 2018, signalling market maturation.

---

#### A2. Top 10 Sellers by Revenue

```sql
SELECT
    oi.seller_id,
    os.seller_city,
    os.seller_state,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.price) DESC) AS rank
FROM
    olist_order_items oi
JOIN
    olist_sellers os ON oi.seller_id = os.seller_id
GROUP BY
    oi.seller_id,
    os.seller_city,
    os.seller_state
ORDER BY
    rank
LIMIT 10;
```

**Key Finding:** 9 out of the top 10 sellers are based in São Paulo (SP). The #1 seller generated R$229,472 in revenue.

---

#### A3. Percentage of 5-Star Reviews

```sql
SELECT
    COUNT(*) AS total_reviews,
    ROUND(
        (SUM(CASE WHEN review_score = 5 THEN 1 ELSE 0 END) * 100.0)
        / COUNT(*),
        2
    ) AS percentage_5_star_reviews
FROM
    olist_order_reviews;
```

**Result:** 57.78% of all reviews are 5-star ratings.

---

#### A4. Average Delivery Time per State

```sql
SELECT
    oc.customer_state AS state,
    ROUND(AVG(DATE_PART('day', o.order_delivered_customer_date - o.order_purchase_timestamp))::numeric, 2) AS avg_delivery_days
FROM
    olist_orders o
JOIN
    olist_customers oc ON o.customer_id = oc.customer_id
WHERE
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY
    state
ORDER BY
    avg_delivery_days DESC;
```

**Key Finding:** São Paulo (SP) delivers in 8.3 days vs Roraima (RR) at 28.98 days — a 3.5x geographic disparity.

---

#### A5. Repeat Buyer Analysis

```sql
SELECT COUNT(*) AS repeat_customers
FROM (
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
```

| metric | value |
|---|---|
| Total unique customers | 96,096 |
| Repeat buyers | 2,997 |
| Repeat rate | 3.1% |
| One-time buyers | 96.9% |

---

#### A6. Running Total of Revenue Over Time

```sql
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
```

| Milestone | Month Achieved |
|---|---|
| R$1 Million | April 2017 |
| R$5 Million | November 2017 |
| R$10 Million | April 2018 |
| R$13.5 Million | August 2018 |

---

#### A7. Product Categories with Highest Average Freight Cost

```sql
SELECT
    pc.product_category_name_english,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_cost
FROM
    olist_order_items oi
JOIN olist_products op ON oi.product_id = op.product_id
JOIN product_category_name_translation pc ON op.product_category_name = pc.product_category_name
GROUP BY
    pc.product_category_name_english
ORDER BY
    avg_freight_cost DESC
LIMIT 10;
```

| category | avg_freight_cost |
|---|---|
| office_furniture | R$44 |
| fashion_female_clothing | R$38 |
| furniture_bedroom | R$35 |
| garden_tools | R$33 |
| furniture_living_room | R$33 |

---

#### A8. Late Deliveries vs Review Score Correlation

```sql
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
```

| delivery_status | avg_review_score | total_orders |
|---|---|---|
| On Time | 4.29 ⭐ | 88,653 |
| Late | 2.57 ⭐ | 7,700 |

> Late deliveries cause review scores to drop by 40% — logistics is the single biggest driver of customer satisfaction.

---

#### A9. Seller Retention Across Months

```sql
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
```

**Key Finding:** Top retained sellers were active for 24 consecutive months — the same sellers who appear in the Top 10 revenue list, confirming that consistency and revenue go hand in hand.

---

#### A10. Customer Ranking by Total Spend

```sql
SELECT
    oc.customer_unique_id,
    ROUND(SUM(oi.price), 2) AS total_spending,
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
```

**Key Finding:** The #1 customer spent R$13,440 — nearly double the second-place customer, revealing a clear VIP segment.

---

## 💡 Key Business Insights

| # | Insight | Business Recommendation |
|---|---|---|
| 1 | **96.9% of customers never reordered** | Launch loyalty programs and post-purchase re-engagement campaigns |
| 2 | **Late deliveries drop review scores by 40%** | Improve logistics and set realistic delivery estimates |
| 3 | **SP delivers in 8.3 days vs 29 days in Roraima** | Build regional fulfillment centers in the North |
| 4 | **Black Friday Nov 2017 spike (+52% MoM)** | Plan inventory and staffing around seasonal demand peaks |
| 5 | **9/10 top sellers are from São Paulo** | Diversify seller recruitment across other states |
| 6 | **Credit card = 74% of all payments** | Prioritize credit card UX and installment options |
| 7 | **57.78% gave 5 stars, 11.51% gave 1 star** | Investigate 1-star reviews — mostly linked to late deliveries |
| 8 | **Office furniture has highest freight cost (R$44)** | Implement category-based dynamic shipping pricing |

---

## 🧠 SQL Concepts Demonstrated

| Concept | Where Used |
|---|---|
| `COUNT`, `SUM`, `AVG`, `ROUND` | Basic Q1–Q5, Q8 |
| `GROUP BY`, `ORDER BY`, `LIMIT` | Basic Q2, Q4, Q7, Q9, Q10 |
| `JOIN` — 2 & 3 tables | Basic Q4, Advanced Q2, Q7, Q10 |
| `COUNT(DISTINCT)` | Basic Q6, Q9, Advanced Q9 |
| Subqueries | Basic Q5, Advanced Q5 |
| `CASE WHEN` | Basic Q8, Advanced Q3, A8 |
| `HAVING` | Advanced Q5, Q9 |
| `WHERE` + `IS NOT NULL` | Advanced Q4, Q8 |
| CTEs (`WITH` clause) | Advanced Q1, Q6 |
| `LAG()` Window Function | Advanced Q1 |
| `RANK()` / `DENSE_RANK()` | Advanced Q2, Q10 |
| `SUM() OVER()` Running Total | Advanced Q6 |
| `TO_CHAR()` Date Formatting | Basic Q10, Advanced Q1, Q9 |
| `DATE_PART()` Date Difference | Advanced Q4 |
| Conditional Aggregation | Advanced Q3 |

---

## 📁 Project Structure

```
ecommerce-sql-analysis/
│
├── sql/                      # All SQL queries (Basic + Advanced)
├── .gitignore
└── README.md
```

---

## 👤 Author

**James Halam**
Aspiring Data Analyst | E-Commerce Domain

- 💼 [LinkedIn](https://www.linkedin.com/in/jameshalam/)
- 🐙 [GitHub](https://github.com/Jamesranglong)

---

*Dataset credits: Olist & André Sionek — Brazilian E-Commerce Public Dataset*
