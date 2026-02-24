SELECT * FROM demo;
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(50),
    product_name VARCHAR(100),
    quantity INTEGER,
    order_status VARCHAR(20),
    order_date TEXT
);

INSERT INTO orders VALUES (1001, 'PetSmart Chicago', 'Hip and Joint Chews', 30, 'Shipped', '2024-01-05');
INSERT INTO orders VALUES (1002, 'Amazon Reseller', 'Smooth BM Plus', 15, 'Pending', '2024-01-07');
INSERT INTO orders VALUES (1003, 'Holistic Pet Store', 'Crunchy Beef Liver', 50, 'Invoiced', '2024-01-10');
INSERT INTO orders VALUES (1004, 'PetSmart Chicago', 'Fish Oil Chews', 20, 'Paid', '2024-01-12');
INSERT INTO orders VALUES (1005, 'Amazon Reseller', 'Hip and Joint Chews', 10, 'Pending', '2024-01-15');

SELECT * from orders;

SELECT customer_name, product_name, order_status
FROM orders;

--show me only the orders that are still Pending. We need to follow up
SELECT customer_name, product_name, order_status
FROM orders
WHERE order_status = 'Pending';

--Out of those Pending orders — which one has the higher quantity? We want to prioritize fulfillment.
SELECT customer_name, product_name, quantity, order_status
FROM orders
WHERE order_status = 'Pending'
ORDER BY quantity DESC;

--How many total orders exist?
SELECT COUNT(*) FROM orders;

--What is the total quantity across all orders?
SELECT SUM(quantity) FROM orders;

--What is the largest single order quantity?
SELECT MAX(quantity) FROM orders;

--What is the total quantity of orders that are still Pending? I need to know how much stock to hold back
SELECT SUM(quantity) AS total_pending_quantity
FROM orders
WHERE order_status = 'Pending';

--Show me the total quantity ordered — broken down by each customer.
SELECT customer_name, SUM(quantity) AS total_quantity
FROM orders
GROUP BY customer_name;

-- Biggest customers by total quantity ordered
SELECT customer_name, SUM(quantity) AS total_quantity
FROM orders
GROUP BY customer_name;

-- total quantity for only the Shipped and Paid orders, grouped by product name. Sort it so the highest quantity product appears first
SELECT product_name,SUM(quantity) AS total_quantity
FROM orders
WHERE order_status = 'Shipped' OR order_status = 'Paid'
GROUP BY product_name
ORDER BY total_quantity DESC;

-- =============================================
-- Lesson 2: JOIN Queries
-- Date: February 2026
-- =============================================
-- Create customers table
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(20)
);

-- Create products table
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);

-- Create orders table with foreign keys
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    order_status VARCHAR(20),
    order_date TEXT
);

-- Insert customers
INSERT INTO customers VALUES (1, 'PetSmart Chicago', 'Chicago', 'Illinois');
INSERT INTO customers VALUES (2, 'Amazon Reseller', 'Seattle', 'Washington');
INSERT INTO customers VALUES (3, 'Holistic Pet Store', 'Milwaukee', 'Wisconsin');
INSERT INTO customers VALUES (4, 'Pet Supplies Plus', 'Detroit', 'Michigan');

-- Insert products
INSERT INTO products VALUES (1, 'Hip and Joint Chews', 'Joint Health', 29.99);
INSERT INTO products VALUES (2, 'Smooth BM Plus', 'Digestive Health', 24.99);
INSERT INTO products VALUES (3, 'Crunchy Beef Liver', 'Treats', 14.99);
INSERT INTO products VALUES (4, 'Fish Oil Chews', 'Skin and Coat', 19.99);

-- Insert orders
INSERT INTO orders VALUES (1001, 1, 1, 30, 'Shipped', '2024-01-05');
INSERT INTO orders VALUES (1002, 2, 2, 15, 'Pending', '2024-01-07');
INSERT INTO orders VALUES (1003, 3, 3, 50, 'Invoiced', '2024-01-10');
INSERT INTO orders VALUES (1004, 1, 4, 20, 'Paid', '2024-01-12');
INSERT INTO orders VALUES (1005, 2, 1, 10, 'Pending', '2024-01-15');
INSERT INTO orders VALUES (1006, 4, 2, 25, 'Shipped', '2024-01-18');

-- Orders with customer names using JOIN
SELECT orders.order_id,
       customers.customer_name,
       orders.quantity,
       orders.order_status
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id;

-- Orders with customer names AND product details
SELECT orders.order_id,
       customers.customer_name,
       products.product_name,
       products.unit_price,
       orders.quantity,
       orders.order_status
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN products ON orders.product_id = products.product_id;

-- Orders with total value calculated
SELECT orders.order_id,
       customers.customer_name,
       products.product_name,
       products.unit_price,
       orders.quantity,
       ROUND(products.unit_price * orders.quantity,2) AS total_order_value,
       orders.order_status
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN products ON orders.product_id = products.product_id;

SELECT customers.customer_name,
ROUND(SUM(products.unit_price * orders.quantity),2) AS total_revenue
from orders
JOIn customers ON orders.customer_id = customers.customer_id
JOIN products ON orders.product_id = products.product_id
GROUP BY customers.customer_name
HAVING total_revenue > 500
ORDER by total_revenue DESC;

SELECT products.category,
ROUND(SUM(products.unit_price * orders.quantity), 2) AS total_revenue,
COUNT(orders.order_id) AS number_of_orders
FROM orders
JOIN products ON orders.product_id = products.product_id
GROUP BY products.category
HAVING COUNT(orders.order_id)>1
ORDER by total_revenue DESC;

-- =============================================
-- Lesson 2 Revision: JOIN Practice Challenges
-- Date: February 2026
-- =============================================

-- Challenge 1: Orders with product name and quantity sorted highest first
SELECT products.product_name, 
       orders.quantity, 
       orders.order_status
FROM orders
JOIN products ON orders.product_id = products.product_id
ORDER BY orders.quantity DESC;

-- Challenge 2: Customer orders with city and order date sorted newest first
SELECT customers.customer_name, 
       customers.city, 
       orders.order_date
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
ORDER BY orders.order_date DESC;

-- Challenge 3: Full sales report - Shipped and Paid orders sorted by total value
SELECT customers.customer_name, 
       products.product_name, 
       ROUND((orders.quantity * products.unit_price), 2) AS total_order_value, 
       orders.order_status
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
JOIN products ON orders.product_id = products.product_id
WHERE orders.order_status IN ('Shipped', 'Paid')
ORDER BY total_order_value DESC;

