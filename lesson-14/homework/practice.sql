drop table Sales

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY, 
    EmployeeID INT, 
    CustomerID INT, 
    Product VARCHAR(50), 
    Amount DECIMAL(10,2), 
    OrderDate DATE
);

-- Step 2: Insert Sample Data with Repetitions
INSERT INTO Sales (SaleID, EmployeeID, CustomerID, Product, Amount, OrderDate) VALUES
(1, 101, 201, 'Laptop', 1200.00, '2024-01-10'),
(2, 102, 202, 'Phone', 800.00, '2024-01-10'),
(3, 101, 201, 'Tablet', 500.00, '2024-01-15'),
(4, 103, 203, 'Laptop', 1300.00, '2024-02-05'),
(5, 104, 204, 'Phone', 750.00, '2024-02-10'),
(6, 102, 202, 'Laptop', 1250.00, '2024-02-15'),
(7, 101, 201, 'Phone', 850.00, '2024-03-01'),
(8, 103, 203, 'Tablet', 400.00, '2024-03-05'),
(9, 101, 205, 'Laptop', 1350.00, '2024-03-10'),
(10, 102, 202, 'Phone', 900.00, '2024-03-15'),
(11, 104, 204, 'Laptop', 1100.00, '2024-03-20'),
(12, 101, 201, 'Laptop', 1200.00, '2024-04-01'),
(13, 103, 203, 'Phone', 850.00, '2024-04-05'),
(14, 101, 205, 'Tablet', 500.00, '2024-04-10'),
(15, 102, 202, 'Laptop', 1400.00, '2024-04-15'),
(16, 104, 204, 'Phone', 750.00, '2024-04-20'),
(17, 101, 201, 'Tablet', 450.00, '2024-05-01'),
(18, 103, 203, 'Laptop', 1250.00, '2024-05-05'),
(19, 102, 202, 'Phone', 950.00, '2024-05-10'),
(20, 101, 205, 'Laptop', 1300.00, '2024-05-15');
-- Task 1


SELECT e.EmployeeID, SUM(e.Amount) as totalSales FROM Sales as e
	WHERE E.EmployeeID = (SELECT S.EmployeeID FROM Sales as s 
	WHERE e.CustomerID = s.CustomerID AND E.SaleID = S.SaleID)
	group by e.EmployeeID

-- Task 2
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    Position VARCHAR(50),
    HireDate DATE
);
INSERT INTO Employees (EmployeeID, EmployeeName, Position, HireDate) VALUES
(101, 'Alice', 'Sales Manager', '2020-06-15'),
(102, 'Bob', 'Sales Associate', '2019-04-10'),
(103, 'Charlie', 'Sales Representative', '2021-08-21'),
(104, 'David', 'Sales Associate', '2018-12-05'),
(105, 'Eve', 'Regional Manager', '2017-03-30');

drop table Sales
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    CustomerID INT,
    Product VARCHAR(50),
    Amount DECIMAL(10,2),
    OrderDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

;WITH CTE AS (
	SELECT AVG(SALARY) AS avg_salary FROM Employees
	)
SELECT * FROM Employees
cross join CTE

-- Task 3
select S.Product, S.Amount AS highest_amount from Sales as S
	JOIN (
		SELECT Product, MAX(Amount) as maxSales FROM Sales
		GROUP BY Product
	) AS maxAmountProduct
	ON S.Product = maxAmountProduct.Product
	AND S.Amount = maxAmountProduct.maxSales

-- Task 4
WITH cte_countEmp as (
	select E.EmployeeName, COUNT(S.EmployeeID) AS countEmpName
	from Sales AS S
	join Employees AS E on S.EmployeeID = E.EmployeeID
	GROUP BY E.EmployeeName
) 
select * from cte_countEmp
WHERE countEmpName >= 5

-- Task 5
drop table Customers
CREATE TABLE Customers_12 (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Email VARCHAR(100)
);
INSERT INTO Customers_12 (CustomerID, CustomerName, City, State, Email) VALUES
(201, 'John Smith', 'Dallas', 'TX', 'john.smith@email.com'),
(202, 'Emma Johnson', 'Austin', 'TX', 'emma.johnson@email.com'),
(203, 'Michael Brown', 'Houston', 'TX', 'michael.brown@email.com'),
(204, 'Sophia Williams', 'San Antonio', 'TX', 'sophia.williams@email.com'),
(205, 'David Miller', 'Des Moines', 'IA', 'david.miller@email.com');

SELECT top 5 * FROM (
	SELECT C.CustomerName, SUM(S.Amount) AS total_amount FROM Sales AS S
		JOIN Customers_12 AS C ON S.CustomerID = C.CustomerID
		GROUP BY C.CustomerName
) as derived_byAmount
ORDER BY  total_amount DESC

--SELECT * FROM Sales
--create database lesson_14
--use lesson_14
--drop table sales

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    InventoryLevel INT
);
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    CustomerID INT,
    ProductID INT,
    Amount DECIMAL(10,2),
    OrderDate DATE,
    --FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Position VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Email VARCHAR(100)
);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

select * from Orders;

-- Task 6
WITH CTE AS(
	SELECT p.ProductID, p.ProductName, p.Category, sum(s.Amount) as total_sum
	FROM Products as p
	join Sales as s ON p.ProductID = s.ProductID
	group by p.ProductID, p.ProductName, p.Category
	having sum(s.Amount) > 500
	--WHERE SalesAmount > 500
) 
SELECT * FROM CTE

-- Task 7
SELECT * FROM (
	SELECT C.CustomerID, C.CustomerName, COUNT(O.CustomerID) AS total_count
		FROM Customers AS C
		JOIN Orders AS o ON C.CustomerID = O.CustomerID
		GROUP BY C.CustomerID, C.CustomerName
		HAVING COUNT(O.CustomerID) > 5
) AS A

-- Task 8
WITH cte_emp AS (
	SELECT CAST(AVG(Salary) AS decimal(10, 2)) AS avg_salary FROM Employees
)
--SELECT * FROM Employees 
--	WHERE Salary > (SELECT * FROM cte_emp)
SELECT * FROM Employees as e
	JOIN cte_emp AS c ON Salary > c.avg_salary

-- Task 9
SELECT * FROM (
	SELECT P.ProductID, P.ProductName, COUNT(S.ProductID) AS count_product
		FROM Products AS P
		JOIN Sales AS S ON P.ProductID = S.ProductID
		GROUP BY P.ProductID, P.ProductName
) AS A
SELECT * FROM Employees

CREATE TABLE Employees_1 (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

-- Task 10
WITH longWorkedEmp AS (
	SELECT *, DATEDIFF(YEAR, HireDate, GETDATE()) as yearsWorked FROM Employees_1
	WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5
)
SELECT * FROM longWorkedEmp

-- Task 11
;WITH cte_runningTotal AS (
	SELECT S1.EmployeeID, S1.OrderDate, S1.Amount, SUM(S2.Amount) AS running_total FROM Sales AS S1
	JOIN Sales AS S2 ON S1.EmployeeID = S2.EmployeeID AND S1.OrderDate >= S2.OrderDate
		GROUP BY S1.EmployeeID, S1.OrderDate,  S1.Amount
			ORDER BY S1.EmployeeID, S1.OrderDate
)
SELECT * FROM cte_runningTotal

SELECT *,
	SUM(Amount) OVER(PARTITION BY EmployeeID ORDER BY OrderDate 
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_Total
	FROM Sales

-- Task 12
DECLARE @NUMBER INT = 1
;WITH cte_num AS (
	SELECT 1 AS NUM
	UNION ALL
	SELECT NUM + 1 FROM cte_num
	WHERE NUM < 10
)
SELECT * FROM cte_num

-- Task 13
SELECT * FROM (
	SELECT  E.Department, AVG(Salary) AS avg_salary
	FROM Employees_12 AS E
	GROUP BY E.Department
) AS AVERAGE_SALARY

-- Task 14
SELECT *,
	RANK() OVER (ORDER BY totalSum DESC) AS rankSales
	FROM (
	SELECT E.EmployeeID, E.EmployeeName, SUM(Amount)as totalSum FROM Employees AS E
	JOIN Sales AS S ON E.EmployeeID = S.EmployeeID
	GROUP BY E.EmployeeID, E.EmployeeName
)AS totalSales

--Task 15
DROP TABLE Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    EmployeeID INT,
    CustomerID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2),
);

SELECT TOP 5 * FROM (
SELECT e.EmployeeID, e.EmployeeName, COUNT(o.EmployeeID) AS count_Emp FROM ORDERS AS O
	JOIN Employees AS E ON E.EmployeeID = O.EmployeeID
		GROUP BY e.EmployeeID, e.EmployeeName
			
) AS CountEmployees
ORDER BY count_Emp DESC;

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT NULL,
    HireDate DATE,
    Salary DECIMAL(10,2),
    Department VARCHAR(50),
);

--Task 16
select * from Employee
; WITH cte_manager AS (
	select e.EmployeeID,
	e.EmployeeName,
	E.ManagerID,
	ISNULL(E1.EmployeeName, 'No manager') AS managerName
		from Employee as e
		LEFT JOIN Employee AS E1 ON E.ManagerID = E1.EmployeeID
		WHERE E.ManagerID IS NULL
		UNION ALL
		SELECT E1.EmployeeID, 
			E1.EmployeeName,
			E1.ManagerID,
			ISNULL(M.EmployeeName, 'No manager') AS managerName
		FROM Employee AS E1
		JOIN cte_manager AS M ON E1.ManagerID = M.EmployeeID
)
SELECT * FROM cte_manager

--Task 17
;WITH MonthlySales AS (
	SELECT FORMAT(OrderDate, 'yyyy-MM') as months, SUM(amount) as monthlyAmount
	 FROM Sales
		GROUP BY FORMAT(OrderDate, 'yyyy-MM')
)
SELECT *, 
	ISNULL(LAG(monthlyAmount) OVER(ORDER BY (SELECT 1)), 0) AS prevMonthlySales
	,ISNULL(monthlyAmount - LAG(monthlyAmount) OVER(ORDER BY (SELECT 1)) , 0) AS differenceMonthlySales
	FROM MonthlySales

-- Task 18
SELECT *
	FROM (
	SELECT E.EmployeeID, E.EmployeeName, e.Department, SUM(S.Amount) AS SumAmount
	,DENSE_RANK() OVER(PARTITION BY e.Department ORDER BY  SUM(S.Amount) DESC) AS rk
	FROM Employees AS E JOIN Sales AS S ON E.EmployeeID = S.EmployeeID
	GROUP BY  E.EmployeeID, E.EmployeeName, e.Department
)AS HighestSale
where rk = 1

-- Task 19
;WITH employeeHirary AS (
	select e.EmployeeID, e.EmployeeName, e.ManagerID
	,1 as lvl
	from Employee as e
	WHERE E.EmployeeID = 107
	UNION ALL
	SELECT e.EmployeeID, e.EmployeeName, e.ManagerID
	,M.lvl + 1
	FROM Employee AS E
	JOIN employeeHirary AS M ON M.ManagerID = E.EmployeeID
)
SELECT * FROM employeeHirary

-- Task 20;

;WITH sales_amountEmp AS (
	SELECT E.EmployeeID, E.EmployeeName FROM Employees AS E
	WHERE  NOT EXISTS ( SELECT 1 FROM Sales AS S WHERE S.EmployeeID = E.EmployeeID
		AND YEAR(OrderDate) = YEAR(GETDATE()) -1
	)
)
SELECT * FROM sales_amountEmp

SELECT * FROM Sales
