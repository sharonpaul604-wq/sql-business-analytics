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
