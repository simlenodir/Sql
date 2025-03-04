CREATE TABLE employees_18 ( id INT PRIMARY KEY, name VARCHAR(100), salary DECIMAL(10, 2) );

INSERT INTO employees_18 (id, name, salary) VALUES (1, 'Alice', 50000), (2, 'Bob', 60000), (3, 'Charlie', 50000);

-- Task 1-1
SELECT * FROM employees_18 E
	WHERE E.salary = (SELECT MIN(SALARY) FROM employees_18)

CREATE TABLE products ( id INT PRIMARY KEY, product_name VARCHAR(100), price DECIMAL(10, 2) );

INSERT INTO products (id, product_name, price) VALUES (1, 'Laptop', 1200),
(2, 'Tablet', 400), (3, 'Smartphone', 800), (4, 'Monitor', 300);

-- Task 1-2
SELECT  id, product_name, price FROM products
	WHERE price >= (SELECT AVG(price) FROM products)

-- Level 2
-- Task 3
CREATE TABLE departments_1 ( id INT , department_name VARCHAR(100) );

CREATE TABLE employees_1 ( id INT, name VARCHAR(100), department_id INT
--FOREIGN KEY (department_id) REFERENCES departments(id) 
);

INSERT INTO departments_1 (id, department_name) VALUES (1, 'Sales'), (2, 'HR');

INSERT INTO employees_1 (id, name, department_id) VALUES (1, 'David', 1), (2, 'Eve', 2), (3, 'Frank', 1);

SELECT id, name, department_id FROM employees_1 AS E
	WHERE E.department_id in (SELECT d.id FROM departments_1 AS D WHERE D.department_name = 'Sales')

-- Task 4

CREATE TABLE customers ( customer_id INT PRIMARY KEY, name VARCHAR(100) );

CREATE TABLE orders ( order_id INT PRIMARY KEY, customer_id INT, FOREIGN KEY (customer_id) REFERENCES customers(customer_id) );

INSERT INTO customers (customer_id, name) VALUES (1, 'Grace'), (2, 'Heidi'), (3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES (1, 1), (2, 1);

SELECT * FROM customers AS C
	WHERE NOT EXISTS  (SELECT 1 FROM orders WHERE C.customer_id = orders.customer_id)

select * from Employees
select * from Departments
select * from Salaries

SELECT E.EmployeeID, E.EmployeeName, S.Salary, D.DepartmentName FROM Employees AS E
	JOIN Salaries AS S ON S.EmployeeID = E.EmployeeID
		JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
			WHERE Salary = (
				SELECT MAX(Salary) FROM 
				(SELECT E.EmployeeID, E.EmployeeName, S.Salary, E.DepartmentID, D.DepartmentName 
					FROM Employees AS E
						JOIN Salaries AS S ON S.EmployeeID = E.EmployeeID) as Es 
							WHERE ES.DepartmentID = E.DepartmentID) 

DROP TABLE IF EXISTS #Orders;
GO

CREATE TABLE #Orders
(
OrderID     INTEGER PRIMARY KEY,
CustomerID  INTEGER NOT NULL,
OrderDate   DATE NOT NULL,
Amount      MONEY NOT NULL,
[State]     VARCHAR(2) NOT NULL
);
GO

INSERT INTO #Orders (OrderID, CustomerID, OrderDate, Amount, [State]) VALUES
(1,1001,'1/1/2018',100,'TX'),
(2,1001,'1/1/2018',150,'TX'),
(3,1001,'1/1/2018',75,'TX'),
(4,1001,'2/1/2018',100,'TX'),
(5,1001,'3/1/2018',100,'TX'),
(6,2002,'2/1/2018',75,'TX'),
(7,2002,'2/1/2018',150,'TX'),
(8,3003,'1/1/2018',100,'IA'),
(9,3003,'2/1/2018',100,'IA'),
(10,3003,'3/1/2018',100,'IA'),
(11,4004,'4/1/2018',100,'IA'),
(12,4004,'5/1/2018',50,'IA'), 
(13,4004,'5/1/2018',100,'IA');

SELECT DISTINCT O.State FROM #Orders O
	WHERE 100 < (
		SELECT AVG(O1.Amount) FROM #Orders AS O1 WHERE O.State = O1.State AND MONTH(O1.OrderDate) = MONTH(O.OrderDate)
	)

-- Task 5
CREATE TABLE products_18 ( id INT PRIMARY KEY, product_name VARCHAR(100), price DECIMAL(10, 2), category_id INT );

INSERT INTO products_18 (id, product_name, price, category_id)
VALUES (1, 'Tablet', 400, 1), (2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2), (4, 'Speakers', 300, 2);

	
SELECT * FROM products_18 P
	WHERE price = (
		SELECT MAX(price) FROM products_18 AS P1
		WHERE P.category_id = P1.category_id
	)

-- Task 6

-- Task 6

CREATE TABLE departments_02 ( id INT PRIMARY KEY, department_name VARCHAR(100) );

CREATE TABLE employees_02 ( id INT PRIMARY KEY, name VARCHAR(100), salary DECIMAL(10, 2), department_id INT, FOREIGN KEY (department_id) REFERENCES departments_02(id) );

INSERT INTO departments_02 (id, department_name) VALUES (1, 'IT'), (2, 'Sales');

INSERT INTO employees_02 (id, name, salary, department_id) VALUES (1, 'Jack', 80000, 1), (2, 'Karen', 70000, 1), (3, 'Leo', 60000, 2);

select e.id, e.name, e.salary, d.department_name from employees_02 as e
	join departments_02 as d on e.department_id = d.id 
		where e.salary = (select MAX(salary) from employees_02 as e1 where e1.department_id = e.department_id)

select e.id, e.name, e.salary, d.department_name from employees_02 as e
	join departments_02 as d on e.department_id = d.id 
		where e.salary >= (select avg(salary) from employees_02 as e1)
	
SELECT E.id, E.name, E.salary, D.department_name FROM employees_02 AS E
	JOIN departments_02 AS D ON E.department_id = D.id
	WHERE E.department_id = (
		SELECT TOP 1 department_id from employees_02 as e1
		group by department_id
		order by AVG(e1.salary) desc)

-- Task 7

CREATE TABLE employees_03 ( id INT PRIMARY KEY, name VARCHAR(100), salary DECIMAL(10, 2), department_id INT );

INSERT INTO employees_03 (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1), (2, 'Nina', 75000, 1), 
(3, 'Olivia', 40000, 2), (4, 'Paul', 55000, 2);

select * from employees_03

select e.id, e.name, e.salary, e.department_id from employees_03 as e
		where e.salary = (select MAX(salary) from employees_03 as e1 where e1.department_id = e.department_id)

-- Task 8

CREATE TABLE students ( student_id INT PRIMARY KEY, name VARCHAR(100) );

CREATE TABLE grades ( student_id INT, course_id INT, grade DECIMAL(4, 2), FOREIGN KEY (student_id) REFERENCES students(student_id) );

INSERT INTO students (student_id, name) VALUES (1, 'Sarah'), (2, 'Tom'), (3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES (1, 101, 95), (2, 101, 85), (3, 102, 90), (1, 102, 80);

select s.name, g.course_id, g.grade from students as s
	join grades as g on g.student_id = s.student_id
		where g.grade = (select MAX(grade) from grades as g1 where g1.course_id = g.course_id)

-- Task 9
CREATE TABLE products_09 ( id INT PRIMARY KEY, product_name VARCHAR(100), price DECIMAL(10, 2), category_id INT );

INSERT INTO products_09 (id, product_name, price, category_id) VALUES (8, 'Earbuds', 250, 3),
	(1, 'Phone', 800, 3), (2, 'Laptop', 1500, 1), (3, 'Tablet', 600, 1),
	(4, 'Smartwatch', 300, 1), (5, 'Headphones', 200, 2), (6, 'Speakers', 300, 2), (7, 'Earbuds', 100, 2);
	

select * from products_09 as p
	where p.price = (select MAX(price) from products_09 as p1 where p.category_id = p1.category_id)
		order by price desc
			OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY

-- Task 10
CREATE TABLE employees_10 ( id INT PRIMARY KEY, name VARCHAR(100), salary DECIMAL(10, 2), department_id INT );

INSERT INTO employees_10 (id, name, salary, department_id) VALUES 
(1, 'Alex', 70000, 1), (2, 'Blake', 90000, 1), (3, 'Casey', 50000, 2), (4, 'Dana', 60000, 2), (5, 'Evan', 75000, 1);

select * from employees_10 as e
	where e.salary between (select Avg(salary) from employees_10 as e1) and 
		(select max(salary) from employees_10 as e2 where  e.department_id = e2.department_id)
			order by salary


