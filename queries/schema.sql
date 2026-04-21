CREATE DATABASE olist_db;

-- Tables

CREATE TABLE olist_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);

CREATE TABLE olist_geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(18,15),
    geolocation_lng DECIMAL(18,15),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(5)
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

CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);


-- Import CSV 
-- Change the path according to your PATH
-- I am using psql terminal Commands

\copy olist_customers FROM '/Users/james/Desktop/Data Analytics /SQL/portfolio_project/E-commerce_sales_Analysis/Dataset/olist_customers_dataset.csv' DELIMITER ',' CSV HEADER;

\copy olist_geolocation FROM '/Users/james/Desktop/Data Analytics /SQL/portfolio_project/E-commerce_sales_Analysis/Dataset/olist_geolocation_dataset.csv' DELIMITER ',' CSV HEADER;

\copy olist_orders FROM '/Users/james/Desktop/Data Analytics /SQL/portfolio_project/E-commerce_sales_Analysis/Dataset/olist_orders_dataset.csv' DELIMITER ',' CSV HEADER;

\copy olist_order_items FROM '/Users/james/Desktop/Data Analytics /SQL/portfolio_project/E-commerce_sales_Analysis/Dataset/olist_order_items_dataset.csv' DELIMITER ',' CSV HEADER;

\copy olist_order_payments FROM '/Users/james/Desktop/Data Analytics /SQL/portfolio_project/E-commerce_sales_Analysis/Dataset/olist_order_payments_dataset.csv' DELIMITER ',' CSV HEADER;

\copy olist_order_reviews FROM '/Users/james/Desktop/Data Analytics /SQL/portfolio_project/E-commerce_sales_Analysis/Dataset/olist_order_reviews_dataset.csv' DELIMITER ',' CSV HEADER;

\copy olist_products FROM '/Users/james/Desktop/Data Analytics /SQL/portfolio_project/E-commerce_sales_Analysis/Dataset/olist_products_dataset.csv' DELIMITER ',' CSV HEADER;

\copy olist_sellers FROM '/Users/james/Desktop/Data Analytics /SQL/portfolio_project/E-commerce_sales_Analysis/Dataset/olist_sellers_dataset.csv' DELIMITER ',' CSV HEADER;

\copy product_category_name_translation FROM '/Users/james/Desktop/Data Analytics /SQL/portfolio_project/E-commerce_sales_Analysis/Dataset/product_category_name_translation.csv' DELIMITER ',' CSV HEADER;



