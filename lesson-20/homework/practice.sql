-- Task 1
SELECT s.* 
	,SUM(sales_amount) 
	OVER(PARTITION BY employee_id
	ORDER BY employee_id
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
	FROM sales AS s

-- Task 2
SELECT O.* 
	,ISnull(total_amount - LEAD(total_amount) OVER(ORDER BY order_date), 0) as difference_amount
	FROM orders AS O

-- Task 3
SELECT * FROM (
	SELECT p.* 
	,ROW_NUMBER() OVER(ORDER BY sales_amount DESC) as rank_amount
	FROM products as p
) AS A
WHERE a.rank_amount between 1 and 5

-- Task 4
SELECT * FROM (
	SELECT * 
	,RANK() OVER(ORDER BY sales_amount) as rank_amount
	FROM products AS p
) AS A
WHERE A.rank_amount	BETWEEN 1 AND 10
--OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Task 5
drop table sales
CREATE TABLE SALES (
    order_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    employee_id INT,
    sales_amount DECIMAL(10,2),
    sales_date DATE
);
INSERT INTO SALES (order_id, product_id, customer_id, employee_id, sales_amount, sales_date)
VALUES
    (1, 101, 201, 301, 500.00, '2024-03-01'),
    (2, 102, 202, 302, 150.75, '2024-03-02'),
    (3, 103, 203, 303, 200.50, '2024-03-03'),
    (4, 101, 204, 304, 750.00, '2024-03-04'),
    (5, 104, 205, 305, 320.25, '2024-03-05'),
    (6, 105, 206, 306, 620.90, '2024-03-06'),
    (7, 102, 207, 307, 430.60, '2024-03-07'),
    (8, 106, 208, 308, 890.10, '2024-03-08'),
    (9, 107, 209, 309, 275.35, '2024-03-09'),
    (10, 103, 210, 310, 640.80, '2024-03-10'),
    (11, 108, 211, 311, 150.00, '2024-03-11'),
    (12, 109, 212, 312, 730.25, '2024-03-12'),
    (13, 110, 213, 313, 520.50, '2024-03-13'),
    (14, 105, 214, 314, 300.75, '2024-03-14'),
    (15, 101, 215, 315, 410.30, '2024-03-15'),
    (16, 102, 216, 316, 295.60, '2024-03-16'),
    (17, 106, 217, 317, 680.45, '2024-03-17'),
    (18, 107, 218, 318, 510.00, '2024-03-18');

SELECT 
    order_id, 
    product_id, 
    COUNT(order_id) OVER (PARTITION BY product_id) AS total_orders_per_product
FROM Sales
ORDER BY product_id, order_id;

-- Task 6
--select * from products
SELECT p.*
	,SUM(sales_amount) 
	OVER(PARTITION BY category ORDER BY sales_amount
	ROWS BETWEEN UNBOUNDED PRECEDING  AND CURRENT ROW) AS running_total_category_sales
	FROM PRODUCTS AS p
 
 -- Task 7
 CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    departmentID INT,
    salary DECIMAL(10,2)
);

INSERT INTO employees (id, name, departmentID, salary)
VALUES 
    (1, 'Alice Johnson', 101, 5000.00),
    (2, 'Bob Smith', 102, 6000.00),
    (3, 'Charlie Brown', 103, 5500.00),
    (4, 'David Williams', 101, 7000.00),
    (5, 'Eva Davis', 102, 7200.00),
    (6, 'Frank Thomas', 103, 6800.00),
    (7, 'Grace Lee', 104, 5200.00),
    (8, 'Henry Adams', 101, 4800.00),
    (9, 'Isabel Carter', 102, 6500.00),
    (10, 'Jack Wilson', 103, 5900.00),
    (11, 'Karen White', 104, 6200.00),
    (12, 'Leo Martinez', 101, 5800.00),
    (13, 'Mona Harris', 102, 7100.00),
    (14, 'Nolan Scott', 103, 6400.00),
    (15, 'Olivia Green', 104, 5300.00),
    (16, 'Paul Anderson', 101, 7500.00),
    (17, 'Quincy Baker', 102, 7700.00),
    (18, 'Rachel Cooper', 103, 7200.00);

SELECT e.* 
	,DENSE_RANK() OVER(PARTITION BY departmentID ORDER BY salary DESC) AS rank_salary
	FROM employees as e

-- Task 8
select s.*
	,CAST(AVG(sales_amount)
	OVER(PARTITION BY product_id ORDER BY order_id 
	ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS decimal(10, 2)) AS moving_avg
	from SALES as s

-- Task 9
SELECT p.* 
	,NTILE(3) OVER(ORDER BY price) AS price_group
	FROM products AS p

-- Task 10
SELECT s.*
	,LAG(sales_amount) 
	OVER(PARTITION BY employee_id 
	ORDER BY order_id) as prev_sales_amount
	FROM SALES AS s

-- Task 11
SELECT * 
	,SUM(sales_amount)
	OVER(PARTITION BY employee_id 
	ORDER BY employee_id
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
	FROM SALES AS s

-- Task 12
SELECT * 
	, LEAD(sales_amount) OVER(ORDER BY sales_date) as prew_sales_amount
	FROM SALES

-- Task 13
SELECT *
	,SUM(sales_amount) OVER(ORDER BY ID ROWS BETWEEN
	UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_running_total
	FROM products
	
-- Task 14
SELECT 
	A.id, A.name, A.departmentID,
	A.salary, A.rank_salary  FROM (
	SELECT *,
	RANK() OVER(ORDER BY SALARY DESC) AS rank_salary
	FROM employees
) AS A
WHERE rank_salary BETWEEN 0 AND 5

-- Task 15
select *
	,CAST(AVG(total_amount)
	OVER(
	PARTITION BY customer_id
	ORDER BY order_id) AS decimal(10, 2) 
	) as average_amount_by_customer
	from orders

-- Task 16
SELECT *
	,ROW_NUMBER() 
	OVER(ORDER BY order_date) as row_number_by_orderdate
	FROM orders

-- Task 17
SELECT 
    s.EmployeeID, 
    d.DepartmentID, 
    s.SalesAmount, 
    SUM(s.SalesAmount) OVER (
        PARTITION BY d.DepartmentID 
        ORDER BY s.EmployeeID
    ) AS RunningTotal
FROM Sales s
JOIN Department d ON s.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentID, s.EmployeeID;

-- Task 18
SELECT *
	,NTILE(5) OVER(ORDER BY salary) as ntile_salary
		FROM employees

-- Task 19
SELECT *
	,SUM(salesAmount) 
	OVER(PARTITION BY ProductId
	ORDER BY salesamount) AS sum_by_productID
	FROM sales

-- Task 20
SELECT * FROM (
	SELECT *
	,DENSE_RANK() OVER(ORDER BY SalesAmount DESC) AS rank_sales_amount
	FROM SALES
) AS A
WHERE A.rank_sales_amount BETWEEN 1 AND 5
