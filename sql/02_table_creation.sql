USE EcommerceBI;
GO

-- 1. Customers
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

-- 2. Orders
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME2,
    order_approved_at DATETIME2,
    order_delivered_carrier_date DATETIME2,
    order_delivered_customer_date DATETIME2,
    order_estimated_delivery_date DATETIME2,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- 3. Products
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(150),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);

-- 4. Sellers
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

-- 5. Order items
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME2,
    price DECIMAL(12,2),
    freight_value DECIMAL(12,2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

-- 6. Payments
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(12,2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 7. Reviews
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(500),
    review_comment_message VARCHAR(MAX),
    review_creation_date DATETIME2,
    review_answer_timestamp DATETIME2,
    PRIMARY KEY (review_id, order_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 8. Product category translations
CREATE TABLE product_category_translation (
    product_category_name VARCHAR(150) PRIMARY KEY,
    product_category_name_english VARCHAR(150)
);

-- 9. Geolocation
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

GO

-- Verify table creation
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;