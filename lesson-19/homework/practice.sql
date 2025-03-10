CREATE TABLE [dbo].[MissingValue] (
    [Value] [varchar](1) NULL,
    [ayValue] [int] NULL
)

--Insert Data
INSERT INTO [dbo].[MissingValue] (Value, ayValue)
    VALUES ('A', 1),
    ('', 23),
    ('', 21),
    ('', 22),
    ('B', 34),
    ('', 31),
    ('', 89),
    ('C', 222),
    ('', 10);

SELECT ayValue, MAX(Value)
	over(ORDER BY (select 1) 
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
			) AS VALUE FROM MissingValue
-- Task 1
SELECT E.id, E.name, E.department_id, e.salary, RANK() OVER( ORDER BY SALARY desc) AS rank
FROM employees_02 AS E

-- Task 2
--;with cte_rank as (
select id, product_name, price,
	RANK() OVER( ORDER BY PRICE DESC) AS Rank from products
	--)
--select * from cte_rank 
--	where Rank = 1

--Task 3
select id, name, salary,
	dense_RANK() OVER( ORDER BY Salary DESC) AS Rank from employees_02

-- Task 4
select *, LEAD(Salary) over(partition by departmentID order by salary
--, epmployeeID
) as leadSalary  from Employees

-- Task 5
select *, ROW_NUMBER() over(order by orderDate) as rk from orders

-- Task 6
SELECT * FROM 
(select *, DENSE_RANK() over( order by salary desc) AS RK from Employees as E) AS A
WHERE RK = 2

-- Task 7
select *, Lag(Salary) over( order by salary desc) AS RK from Employees as E

-- Task 8
select *, Ntile(4) over( order by salary desc) AS group_tile from Employees as E

-- Task 9
--select * from employees_02
select *, Row_Number() over( partition by departmentID order by salary desc) AS RK from Employees as E

-- Task 10
select *, DENSE_RANK() over(order by price) as rk from products_09

-- Task 11
select *,
	AVG(salary) over(order by salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS cumulative_avg_salary
		from employees_02

 CREATE TABLE sales_table (
    product_id INT,
    product_name VARCHAR(50),
    sales_amount INT
);

INSERT INTO sales_table (product_id, product_name, sales_amount) VALUES
(1, 'Laptop', 1000),
(2, 'Smartphone', 1500),
(3, 'Tablet', 900),
(4, 'Laptop', 1200),
(5, 'Smartphone', 1300),
(6, 'Tablet', 1100),
(7, 'Headphones', 700);

-- Task 12

select product_id, product_name
	, SUM(sales_amount) total_sales,
	Rank() over (order by sum(sales_amount) desc)as rank_sales
	from sales_table as st
	group by product_id, product_name

drop table orders

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    total_amount DECIMAL(10,2)
);
INSERT INTO orders (order_id, customer_name, order_date, total_amount) VALUES
(1, 'Alice', '2024-03-01', 250.50),
(2, 'Bob', '2024-03-02', 180.75),
(3, 'Charlie', '2024-03-02', 320.40),
(4, 'David', '2024-03-03', 150.00),
(5, 'Emma', '2024-03-04', 500.25),
(6, 'Frank', '2024-03-04', 275.90),
(7, 'Grace', '2024-03-05', 450.60),
(8, 'Henry', '2024-03-06', 300.00),
(9, 'Ivy', '2024-03-06', 220.80),
(10, 'Jack', '2024-03-07', 400.15);

-- Task 13

select o.*,
	ISNULL(CAST(LAG(o.order_date) over (order by o.order_date) as varchar), 'No date') as prev_date
	from orders as o

-- Task 14

select p.*,
	SUM(price) over(order by id
	ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS sum_3_rows
	from products_09 as p

-- Task 15
select e.*
	,NTILE(4) over( order by salary) as salary_range
	from employees_03 as e

-- Task 16
drop table sales_table
CREATE TABLE sales_table (
    id INT,
    name VARCHAR(50),
    sales_amount DECIMAL(10,2)
);
INSERT INTO sales_table (id, name, sales_amount) VALUES
(1, 'Alice', 5000.00),
(2, 'Bob', 7000.00),
(2, 'Bob', 6500.00),  
(3, 'Charlie', 10000.00),
(4, 'David', 4000.00),
(5, 'Emma', 12000.00),
(5, 'Emma', 11000.00),  
(6, 'Frank', 8000.00),
(7, 'Grace', 6000.00),
(8, 'Henry', 9000.00),
(8, 'Henry', 9500.00),  
(9, 'Ivy', 3000.00),
(10, 'Jack', 11000.00),
(10, 'Jack', 10500.00);


select st.id, name
	,SUM(sales_amount) OVER(PARTITION BY id ORDER BY SUM(sales_amount) DESC) as sum_sales
	from sales_table as st
	GROUP BY ID, name, sales_amount

-- Task 17
drop table products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    stock_quantity INT
);
INSERT INTO products (product_id, product_name, stock_quantity) VALUES
(1, 'Laptop', 10),
(2, 'Smartphone', 25),
(3, 'Tablet', 15),
(4, 'Headphones', 50),
(5, 'Smartwatch', 30),
(6, 'Monitor', 20),
(7, 'Keyboard', 40),
(8, 'Mouse', 35),
(9, 'Printer', 5),
(10, 'External Hard Drive', 12);

select p.* 
	,DENSE_RANK() OVER (ORDER BY stock_quantity desc) as rank_quantity
	from products as p;

-- Task 18
-- WITH CTE 
with rank_salary_cte as (
	select e.*
	,ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rank_salary
	from employees_03 as e
)
select * from rank_salary_cte 
where rank_salary = 2

-- WITH DERIVED TABLE
SELECT * FROM(
	 SELECT E.* 
		,ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary) as rank_salaries
		FROM employees_03 AS E
) AS rank_salary_table
WHERE rank_salaries = 2

-- Task 19
select * from sales_table
select st.*
	,sum(st.sales_amount)
	OVER(ORDER BY (SELECT NULL) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS running_total
	from sales_table st

-- Task 20
select * from sales_table
select st.*
	,LEAD(sales_amount) OVER(PARTITION BY ID ORDER BY (SELECT 1)) AS prev_sale
	from sales_table as st       
