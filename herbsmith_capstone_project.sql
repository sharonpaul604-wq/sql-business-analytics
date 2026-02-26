-- ================================================
-- CAPSTONE PROJECT: Sales Order Analytics
-- Company: Herbsmith Pet Supplements (simulated)
-- Author: Sharon Paul
-- Date: February 2026
-- Tools: SQLite Online, GitHub
-- ================================================

-- DATABASE SETUP
-- ================================================

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(50),
    customer_type VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(20)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date TEXT,
    order_status VARCHAR(20)
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    payment_date TEXT,
    amount_paid DECIMAL(10,2),
    payment_status VARCHAR(20)
);

-- ================================================
-- QUERY 1: Complete Sales Order Report
-- ================================================
SELECT 
    orders.order_id,
    customers.customer_name,
    customers.customer_type,
    products.product_name,
    products.category,
    order_items.quantity,
    ROUND(order_items.quantity * products.unit_price, 2) AS total_order_value,
    orders.order_status,
    orders.order_date
FROM orders
JOIN customers   ON orders.customer_id     = customers.customer_id
JOIN order_items ON orders.order_id        = order_items.order_id
JOIN products    ON order_items.product_id = products.product_id
ORDER BY orders.order_date;

-- ================================================
-- QUERY 2: Revenue by Customer Type
-- ================================================
SELECT 
    customers.customer_type,
    COUNT(orders.order_id) AS total_orders,
    SUM(order_items.quantity) AS total_units,
    ROUND(SUM(order_items.quantity * products.unit_price), 2) AS total_revenue
FROM orders
JOIN customers   ON orders.customer_id     = customers.customer_id
JOIN order_items ON orders.order_id        = order_items.order_id
JOIN products    ON order_items.product_id = products.product_id
WHERE orders.order_status = 'Paid'
GROUP BY customers.customer_type
ORDER BY total_revenue DESC;

-- ================================================
-- QUERY 3: Top Selling Products
-- ================================================
SELECT 
    products.product_name,
    products.category,
    SUM(order_items.quantity) AS total_units_sold,
    ROUND(SUM(order_items.quantity * products.unit_price), 2) AS total_revenue
FROM orders
JOIN order_items ON orders.order_id        = order_items.order_id
JOIN products    ON order_items.product_id = products.product_id
WHERE orders.order_status = 'Paid'
GROUP BY products.product_name, products.category
ORDER BY total_revenue DESC;

-- ================================================
-- QUERY 4: Pending Orders with Overdue Flag
-- ================================================
SELECT 
    orders.order_id,
    customers.customer_name,
    products.product_name,
    ROUND(order_items.quantity * products.unit_price, 2) AS total_order_value,
    orders.order_date,
    CAST(julianday('now') - julianday(orders.order_date) AS INTEGER) 
    AS days_waiting,
    CASE
        WHEN CAST(julianday('now') - julianday(orders.order_date) 
             AS INTEGER) > 30 THEN 'Overdue'
        ELSE 'Follow Up'
    END AS status_flag
FROM orders
JOIN customers   ON orders.customer_id     = customers.customer_id
JOIN order_items ON orders.order_id        = order_items.order_id
JOIN products    ON order_items.product_id = products.product_id
WHERE orders.order_status = 'Pending'
ORDER BY days_waiting DESC;

-- ================================================
-- QUERY 5: Monthly Revenue Trend
-- ================================================
SELECT 
    strftime('%Y', orders.order_date) AS year,
    strftime('%m', orders.order_date) AS month,
    COUNT(orders.order_id) AS total_orders,
    SUM(order_items.quantity) AS total_units,
    ROUND(SUM(order_items.quantity * products.unit_price), 2) AS monthly_revenue
FROM orders
JOIN order_items ON orders.order_id        = order_items.order_id
JOIN products    ON order_items.product_id = products.product_id
WHERE orders.order_status = 'Paid'
GROUP BY strftime('%Y', orders.order_date),
         strftime('%m', orders.order_date)
ORDER BY year, month;

-- ================================================
-- QUERY 6: Payment Collection Analysis
-- ================================================
SELECT 
    orders.order_id,
    customers.customer_name,
    orders.order_date,
    payments.payment_date,
    payments.amount_paid,
    CAST(julianday(payments.payment_date) - 
         julianday(orders.order_date) AS INTEGER) AS days_to_pay,
    CASE
        WHEN CAST(julianday(payments.payment_date) - 
             julianday(orders.order_date) AS INTEGER) <= 7 
             THEN 'Fast Payer'
        WHEN CAST(julianday(payments.payment_date) - 
             julianday(orders.order_date) AS INTEGER) <= 14 
             THEN 'Normal Payer'
        ELSE 'Slow Payer'
    END AS payment_behavior
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN payments  ON orders.order_id    = payments.order_id
ORDER BY days_to_pay;

-- ================================================
-- QUERY 7: Customer Revenue Ranking
-- ================================================
SELECT customers.customer_name,
       COUNT(orders.order_id) AS total_orders,
       ROUND(SUM(order_items.quantity * products.unit_price), 2) AS total_revenue
FROM orders
JOIN customers   ON customers.customer_id  = orders.customer_id
JOIN order_items ON order_items.order_id   = orders.order_id
JOIN products    ON products.product_id    = order_items.product_id
WHERE orders.order_status = 'Paid'
GROUP BY customers.customer_name
ORDER BY total_revenue DESC;

-- ================================================
-- QUERY 8: Product Category Performance
-- ================================================
SELECT products.category,
       ROUND(SUM(order_items.quantity * products.unit_price), 2) AS total_revenue,
       SUM(order_items.quantity) AS total_units
FROM order_items
JOIN products ON order_items.product_id = products.product_id
JOIN orders   ON order_items.order_id   = orders.order_id
WHERE orders.order_status = 'Paid'
GROUP BY products.category
ORDER BY total_revenue DESC;

-- ================================================
-- QUERY 9: High Value Orders Above Average
-- ================================================
SELECT customers.customer_name,
       products.product_name,
       ROUND(order_items.quantity * products.unit_price, 2) AS total_value
FROM orders
JOIN customers   ON customers.customer_id = orders.customer_id
JOIN order_items ON order_items.order_id  = orders.order_id
JOIN products    ON products.product_id   = order_items.product_id
WHERE ROUND(order_items.quantity * products.unit_price, 2) > (
    SELECT AVG(order_items.quantity * products.unit_price)
    FROM order_items
    JOIN products ON order_items.product_id = products.product_id
)
ORDER BY total_value DESC;

-- ================================================
-- QUERY 10: Executive Customer Summary Report
-- ================================================
SELECT customers.customer_name,
       customers.customer_type,
       COUNT(orders.order_id) AS total_orders,
       SUM(order_items.quantity) AS total_units_purchased,
       ROUND(SUM(order_items.quantity * products.unit_price), 2) AS total_revenue,
       CASE 
           WHEN ROUND(SUM(order_items.quantity * products.unit_price), 2) > 1000 
                THEN 'Premium'
           WHEN ROUND(SUM(order_items.quantity * products.unit_price), 2) 
                BETWEEN 500 AND 1000 
                THEN 'Standard'
           ELSE 'Basic'
       END AS customer_tier
FROM orders
JOIN customers   ON customers.customer_id = orders.customer_id
JOIN order_items ON order_items.order_id  = orders.order_id
JOIN products    ON products.product_id   = order_items.product_id
WHERE orders.order_status = 'Paid'
GROUP BY customers.customer_name, customers.customer_type
ORDER BY total_revenue DESC;
