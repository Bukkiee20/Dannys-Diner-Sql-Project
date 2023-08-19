USE dannys_diner;

# Creating my main table
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
WITH firstPurchases AS(
SELECT customer_id, MIN(order_date) AS order_date
FROM finaltable
GROUP BY customer_id)

SELECT p.customer_id, p.order_date, t.product_name
FROM firstPurchases p
INNER JOIN finaltable t
ON p.customer_id = t.customer_id
AND p.order_date = t.order_date
ORDER BY customer_id;

#4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT product_name, COUNT(product_name) "Number Of Order"
FROM finaltable
GROUP BY product_name
ORDER BY COUNT(product_name) DESC LIMIT 1;

#5. Which item was the most popular for each customer?
WITH PopularityCount AS (
SELECT customer_id, product_name, COUNT(product_name) AS ProductCount
FROM finaltable
GROUP BY customer_id, product_name
ORDER BY customer_id)

SELECT p.customer_id, p.product_name, p.ProductCount
FROM PopularityCount p
JOIN(
SELECT customer_id, product_name, MAX(ProductCount) AS MaxCount
FROM PopularityCount
GROUP BY customer_id) AS Max
ON p.customer_id = Max.customer_id
AND p.ProductCount = Max.MaxCount;

#6. Which item was purchased first by the customer after they became a member?
SELECT customer_id, product_name, MIN(order_date) "Date Purchased"
FROM finaltable
WHERE order_date >= join_date
GROUP BY customer_id
ORDER BY customer_id;

#7. Which item was purchased just before the customer became a member?
SELECT customer_id, product_name, MAX(order_date) "Date Purchased"
FROM finaltable
WHERE order_date < join_date
GROUP BY customer_id
ORDER BY customer_id;

#8. What is the total items and amount spent for each member before they became a member?
SELECT customer_id, COUNT(product_name) "Total Items", SUM(price) "Amount Spent"
FROM finaltable
WHERE order_date < join_date
GROUP BY customer_id
ORDER BY customer_id;

#9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
WITH PointsMultiplier AS (
    SELECT product_name,
        CASE 
           WHEN product_name = 'sushi' THEN 2 
           ELSE 1 
		END AS multiplier
    FROM menu
)
SELECT f.customer_id, SUM(f.price * p.multiplier * 10) AS total_points
FROM finaltable f
JOIN PointsMultiplier p 
ON f.product_name = p.product_name
GROUP BY f.customer_id
ORDER BY f.customer_id;

#10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT f.customer_id,
    SUM(
        CASE
            WHEN DAY(TIMEDIFF(f.order_date, f.join_date)) <= 7 THEN f.price * 20
            ELSE f.price * 10
        END
    ) AS total_points
FROM
    finaltable f
WHERE f.order_date >= '2021-01-01' AND f.order_date <= '2021-01-31'
GROUP BY f.customer_id
ORDER BY f.customer_id;