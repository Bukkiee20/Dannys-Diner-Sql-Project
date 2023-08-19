USE dannys_diner;

SELECT * FROM sales;
SELECT * FROM members;
SELECT * FROM menu;

CREATE TABLE finalTable AS
SELECT s.*, m.join_date, e.product_name, e.price
FROM sales s 
JOIN members m
ON s.customer_id = m.customer_id
JOIN menu e
ON s.product_id = e.product_id;

SELECT * FROM finalTable;

#1. What is the total amount each customer spent at the restaurant?
SELECT customer_id, SUM(price) "Total Amount"
FROM finalTable
GROUP BY customer_id
ORDER BY customer_id;

#2. How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(customer_id) "Number of Days"
FROM finalTable
GROUP BY customer_id
ORDER BY customer_id;

#3. What was the first item from the menu purchased by each customer?
SELECT customer_id, product_name
FROM finalTable
GROUP BY customer_id
ORDER BY customer_id;



