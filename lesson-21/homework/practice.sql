create database lesson_21
use lesson_21
DROP TABLE EMPLOYEES
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary) VALUES
(1, 'Alice Johnson', 'HR', 60000.00),
(2, 'Bob Smith', 'IT', 70000.00),
(3, 'Charlie Brown', 'Finance', 65000.00),
(4, 'David Wilson', 'Marketing', 55000.00),
(5, 'Eve Adams', 'IT', 72000.00);

SELECT * FROM EMPLOYEES
SELECT * FROM NEWEMPLOYEES

-- Task 1
MERGE INTO Employees AS target
	USING NewEmployees AS source
	ON target.EmployeeID = source.EmployeeID
		WHEN NOT MATCHED THEN
		INSERT (EmployeeID, Name, Position, Salary)
		VALUES(source.EmployeeID, source.Name, source.Position, source.Salary);

-- Task 2
-- Target table: OldProducts
CREATE TABLE OldProducts (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

-- Source table: CurrentProducts
CREATE TABLE CurrentProducts (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

-- Inserting data into OldProducts (Existing Products)
INSERT INTO OldProducts (ProductID, ProductName, Category, Price, Stock) VALUES
(1, 'Laptop X1', 'Electronics', 1200.00, 50),
(2, 'Smartphone Z5', 'Electronics', 800.00, 100),
(3, 'Wireless Headphones', 'Accessories', 150.00, 200),
(4, 'Gaming Mouse', 'Accessories', 60.00, 150),
(5, 'Office Chair', 'Furniture', 300.00, 75);

-- Inserting data into CurrentProducts (Updated/New Products)
INSERT INTO CurrentProducts (ProductID, ProductName, Category, Price, Stock) VALUES
(2, 'Smartphone Z5 Pro', 'Electronics', 850.00, 90),   -- Updated Name, Price, Stock
(3, 'Wireless Headphones', 'Accessories', 140.00, 220), -- Updated Price, Stock
(5, 'Ergonomic Office Chair', 'Furniture', 320.00, 80), -- Updated Name, Price, Stock
(6, 'Mechanical Keyboard', 'Accessories', 120.00, 150), -- New Product
(7, '4K Monitor', 'Electronics', 500.00, 60);          -- New Product

select * from OldProducts
select * from CurrentProducts

MERGE INTO OldProducts  AS target
	USING CurrentProducts AS source
	ON target.ProductID = source.ProductID
		WHEN Matched THEN UPDATE SET
		target.ProductName = source.ProductName,
		target.Category = source.Category,
		target.Price = source.Price,
		target.Stock = source.Stock
	WHEN NOT MATCHED BY source THEN DELETE;

-- Task 3
CREATE TABLE NewSalaryDetails (
    EmployeeID INT PRIMARY KEY,
    NewSalary DECIMAL(10,2)
);

INSERT INTO NewSalaryDetails (EmployeeID, NewSalary) VALUES
(2, 75000.00),  
(3, 68000.00), 
(5, 73000.00),  
(6, 58000.00),  
(7, 62000.00);
select * from NewSalaryDetails;
MERGE INTO Employees as t
	USING NewSalaryDetails AS S
	ON t.EmployeeID = s.EmployeeID
	WHEN MATCHED AND t.salary < s.Newsalary THEN UPDATE SET
	t.salary = s.NewSalary;

-- Task 4
-- Target Table: Orders (Existing Orders)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    OrderAmount DECIMAL(10,2),  -- Added OrderAmount column
    OrderDate DATE
);

-- Source Table: NewOrders (New or Updated Orders)
CREATE TABLE NewOrders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    OrderAmount DECIMAL(10,2),  -- Added OrderAmount column
    OrderDate DATE
);

-- Insert data into Orders table (Existing Orders)
INSERT INTO Orders (OrderID, CustomerName, Product, Quantity, OrderAmount, OrderDate) VALUES
(1, 'Alice Johnson', 'Laptop', 1, 1200.00, '2024-03-01'),
(2, 'Bob Smith', 'Smartphone', 2, 1600.00, '2024-03-02'),  -- $800 each
(3, 'Charlie Brown', 'Tablet', 1, 500.00, '2024-03-03'),
(4, 'David Wilson', 'Headphones', 3, 300.00, '2024-03-04'), -- $100 each
(5, 'Eve Adams', 'Monitor', 1, 250.00, '2024-03-05');

-- Insert data into NewOrders table (Updated and New Orders)
INSERT INTO NewOrders (OrderID, CustomerName, Product, Quantity, OrderAmount, OrderDate) VALUES
(2, 'Bob Smith', 'Smartphone', 3, 2400.00, '2024-03-02'),  -- Updated quantity and amount
(3, 'Charlie Brown', 'Tablet', 2, 1000.00, '2024-03-03'),  -- Updated quantity and amount
(5, 'Eve Adams', 'Monitor', 1, 250.00, '2024-03-05'),      -- Same order, no change
(6, 'Frank Miller', 'Keyboard', 1, 80.00, '2024-03-06'),   -- New order
(7, 'Grace Hall', 'Mouse', 2, 50.00, '2024-03-07');        -- New order


select * from Orders
select * from NewOrders;

MERGE INTO ORDERS AS T
	USING NEWORDERS AS SN
	ON T.CustomerName = SN.CustomerName AND t.OrderAmount < sn.OrderAmount
	WHEN MATCHED THEN UPDATE SET
	T.OrderAmount = SN.OrderAmount
	WHEN NOT MATCHED THEN INSERT (OrderID, CustomerName, Product, Quantity, OrderAmount, OrderDate)
	VALUES(sn.orderID, sn.CustomerName, sn.Product, sn.Quantity, sn.OrderAmount, sn.OrderDate);

-- Task 5

CREATE TABLE StudentRecords (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT CHECK (Age BETWEEN 17 AND 31),
    GradeLevel INT,
    GPA DECIMAL(3,2),
    EnrollmentDate DATE
);

CREATE TABLE NewStudentRecords (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT CHECK (Age BETWEEN 17 AND 31),  
    GradeLevel INT,
    GPA DECIMAL(3,2),
    EnrollmentDate DATE
);

CREATE TABLE MergeLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    ActionType VARCHAR(10), -- 'INSERT' or 'UPDATE'
    OldGPA DECIMAL(3,2) NULL,
    NewGPA DECIMAL(3,2) NULL,
    ChangeDate DATETIME DEFAULT GETDATE()
);
  
MERGE INTO StudentRecords AS T
USING NewStudentRecords AS S
ON T.StudentID = S.StudentID

-- Update existing students only if the new GPA is higher
WHEN MATCHED AND S.GPA > T.GPA THEN 
    UPDATE SET 
        T.GPA = S.GPA,
        T.GradeLevel = S.GradeLevel,
        T.EnrollmentDate = S.EnrollmentDate
    OUTPUT inserted.StudentID, 
           'UPDATE' AS ActionType, 
           deleted.GPA AS OldGPA, 
           inserted.GPA AS NewGPA, 
           GETDATE() AS ChangeDate
    INTO MergeLog (StudentID, ActionType, OldGPA, NewGPA, ChangeDate)

-- Insert new students only if Age > 18
WHEN NOT MATCHED AND S.Age > 18 THEN 
    INSERT (StudentID, Name, Age, GradeLevel, GPA, EnrollmentDate)
    VALUES (S.StudentID, S.Name, S.Age, S.GradeLevel, S.GPA, S.EnrollmentDate)
    OUTPUT inserted.StudentID, 
           'INSERT' AS ActionType, 
           NULL AS OldGPA, 
           inserted.GPA AS NewGPA, 
           GETDATE() AS ChangeDate
    INTO MergeLog (StudentID, ActionType, OldGPA, NewGPA, ChangeDate);

	CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    SalesAmount DECIMAL(10,2),
    SaleDate DATE
);
truncate table sales

INSERT INTO Sales (SaleID, OrderID, CustomerName, Product, Quantity, SalesAmount, SaleDate) VALUES
(1, 101, 'Alice Johnson', 'Laptop', 1, 1200.50, '2024-03-01'),
(2, 102, 'Bob Smith', 'Smartphone', 2, 1500.00, '2024-03-05'),
(3, 103, 'Alice Johnson', 'Tablet', 1, 450.25, '2024-03-07'), -- Alice Johnson repeats
(4, 104, 'Charlie Brown', 'Headphones', 3, 300.75, '2024-03-10'),
(5, 105, 'David Wilson', 'Smartwatch', 2, 700.00, '2024-03-12'),
(6, 106, 'Bob Smith', 'Laptop Bag', 1, 80.00, '2024-03-14'), -- Bob Smith repeats
(7, 107, 'Alice Johnson', 'Mouse', 2, 40.00, '2024-03-16'), -- Alice Johnson repeats again
(8, 108, 'David Wilson', 'Keyboard', 1, 100.00, '2024-03-18'), -- David Wilson repeats
(9, 109, 'Ella Martinez', 'Monitor', 1, 300.00, '2024-03-20'),
(10, 110, 'Charlie Brown', 'USB Drive', 2, 50.00, '2024-03-22'); -- Charlie Brown repeats


drop view salesSummary
CREATE VIEW SalesSummary AS
SELECT 
    CustomerName,
    SUM(SalesAmount) OVER (PARTITION BY CustomerName) AS TotalSalesAmount, -- Total sales per customer
    COUNT(OrderID) OVER (PARTITION BY CustomerName) AS TotalOrders, -- Total number of orders per customer
    DENSE_RANK() OVER (PARTITION BY CustomerName ORDER BY OrderID) AS RankByCustomer -- Ranking orders per customer
FROM Sales;

select * from SalesSummary

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT CHECK (Age BETWEEN 18 AND 65),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    HireDate DATE,
    --FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100),
    Location VARCHAR(100)
)
-- Insert data into Department table
INSERT INTO Department (DepartmentID, DepartmentName, Location) VALUES
(1, 'HR', 'New York'),
(2, 'IT', 'San Francisco'),
(3, 'Finance', 'Chicago'),
(4, 'Marketing', 'Los Angeles'),
(5, 'Sales', 'Houston');

-- Insert data into Employee table
INSERT INTO Employee (EmployeeID, Name, Age, DepartmentID, Salary, HireDate) VALUES
(101, 'Alice Johnson', 29, 2, 75000.00, '2020-05-15'),
(102, 'Bob Smith', 35, 1, 60000.00, '2018-03-22'),
(103, 'Charlie Brown', 42, 3, 90000.00, '2015-07-10'),
(104, 'David Wilson', 28, 4, 70000.00, '2019-11-05'),
(105, 'Ella Martinez', 31, 2, 80000.00, '2021-06-20'),
(106, 'Frank Green', 45, 5, 95000.00, '2013-09-17'),
(107, 'Grace Lee', 39, 3, 85000.00, '2017-02-28'),
(108, 'Hannah White', 26, 1, 55000.00, '2022-01-15'),
(109, 'Ian Black', 33, 4, 72000.00, '2020-08-19'),
(110, 'Jackie Brown', 30, 5, 77000.00, '2019-12-30');

CREATE VIEW EmployeeDepartmentDetails AS
SELECT E.EmployeeID, E.Name, E.Age,
	E.Salary, E.HireDate, D.DepartmentName, D.Location
	FROM Employee AS E
	JOIN Department AS D ON E.DepartmentID = D.DepartmentID

SELECT * FROM EmployeeDepartmentDetails

CREATE TABLE ProductInventory (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    QuantityInStock INT CHECK (QuantityInStock >= 0),
    Price DECIMAL(10,2),
    LastRestocked DATE
);
INSERT INTO ProductInventory (ProductID, ProductName, Category, QuantityInStock, Price, LastRestocked) VALUES
(1, 'Laptop', 'Electronics', 15, 1200.00, '2024-03-01'),
(2, 'Smartphone', 'Electronics', 25, 800.00, '2024-02-20'),
(3, 'Office Chair', 'Furniture', 10, 150.00, '2024-03-10'),
(4, 'Desk Lamp', 'Furniture', 30, 45.00, '2024-03-05'),
(5, 'Bluetooth Speaker', 'Electronics', 20, 100.00, '2024-02-28'),
(6, 'Coffee Maker', 'Appliances', 5, 90.00, '2024-01-15'),
(7, 'Running Shoes', 'Footwear', 18, 75.00, '2024-02-25'),
(8, 'Backpack', 'Accessories', 22, 60.00, '2024-03-08'),
(9, 'Wristwatch', 'Accessories', 12, 250.00, '2024-02-18'),
(10, 'Keyboard', 'Electronics', 35, 45.00, '2024-03-12');

CREATE VIEW InventoryStatus AS 
	SELECT * 
	, CASE
	WHEN p.QuantityInStock BETWEEN 0 AND 5 then 'Out of stock'
	WHEN p.QuantityInStock BETWEEN 5 AND 10 then 'Low stock'
	WHEN p.QuantityInStock BETWEEN 10 AND 50then 'In stock'
	END AS Status_stock
	FROM ProductInventory AS p

SELECT * FROM InventoryStatus;
drop function fn_GetFullName

CREATE FUNCTION fn_GetFullName
(@firstName varchar(50), @lastName varchar(50))
RETURNS VARCHAR(100)
	AS 
		BEGIN
			RETURN CONCAT(@firstName, ' ', @lastName)
	END;

SELECT
	dbo.fn_GetFullName('Smailov', 'Nodir') as FullName

CREATE FUNCTION fn_GetHighSales (@Threshold DECIMAL(10,2))
	RETURNS TABLE
	AS 
	RETURN (
		SELECT * FROM Sales WHERE SalesAmount > @Threshold
		);

SELECT * FROM DBO.fn_GetHighSales(450)
SELECT CustomerName,
	SUM(SalesAmount) as customer_salesAmount
	,AVG(SalesAmount) AS customer_salesAVG
	,COUNT(OrderID) as customer_countOrders
	,SUM(Quantity) as customer_countQuantity
	,MAX(SaleDate) AS last_orderDate
	FROM Sales
	GROUP BY CustomerName

--DROP FUNCTION fn_GetCustomerStats
CREATE FUNCTION fn_GetCustomerStats ()
	RETURNS @CustomersStats TABLE
	(
	ID INT IDENTITY,
	Customer VARCHAR(100),
	customer_salesAmount DECIMAL(10, 2),
	customer_salesAVG DECIMAL(10, 2),
	customer_countOrders INT,
	customer_countQuantity INT,
	last_orderDate DATE 
	)
		AS 
			BEGIN
	INSERT INTO @CustomersStats
	SELECT CustomerName,
	SUM(SalesAmount) as customer_salesAmount
	,AVG(SalesAmount) AS customer_salesAVG
	,COUNT(OrderID) as customer_countOrders
	,SUM(Quantity) as customer_countQuantity
	,MAX(SaleDate) AS last_orderDate
	FROM Sales
	GROUP BY CustomerName
RETURN;
END;
SELECT * FROM dbo.fn_GetCustomerStats()

--Task 2-1
SELECT *,
	SUM(SalesAmount)
	OVER(ORDER BY SaleID ROWS BETWEEN
	UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
	FROM Sales
--Task 2-2

SELECT e.Name, e.Salary ,D.DepartmentName,
	CAST(AVG(Salary) OVER(PARTITION BY e.DepartmentID ORDER BY Salary DESC) as decimal(10,2)) AS avg_salary_byDepartment
	FROM Employee AS E
JOIN Department AS D ON E.DepartmentID = D.DepartmentID;

SELECT
	--E.Name, E.DepartmentID,
	D.DepartmentName
	,AVG(Salary) AS avg_salaryByDepartment
	FROM Employee AS E
	JOIN Department AS D ON E.DepartmentID = D.DepartmentID
	GROUP BY
	--E.DepartmentID, E.Name,
	D.DepartmentName
	ORDER BY AVG(Salary)

SELECT *,
	SUM(Price) OVER(PARTITION BY Category ORDER BY ProductID ROWS BETWEEN 
	UNBOUNDED PRECEDING AND CURRENT ROW) as sum_price_byCategory
	FROM ProductInventory

SELECT
	--P.ProductName,
	P.Category,
	SUM(Price) AS total_sum_byCategory
	FROM ProductInventory AS P
	GROUP BY P.Category 

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    Age INT CHECK (Age BETWEEN 17 AND 31),  -- Age restriction
    TestScore DECIMAL(5,2) CHECK (TestScore BETWEEN 0 AND 100),  -- Test scores range
    Grade CHAR(1),  -- A, B, C, etc.
    ExamDate DATE
);
INSERT INTO Students (StudentID, StudentName, Age, TestScore, Grade, ExamDate) 
VALUES
(1, 'Alice Johnson', 20, 85.50, 'A', '2024-02-10'),
(2, 'Bob Smith', 22, 78.00, 'B', '2024-02-12'),
(3, 'Charlie Brown', 19, 92.30, 'A', '2024-02-15'),
(4, 'David Williams', 23, 65.75, 'C', '2024-02-17'),
(5, 'Emily Davis', 21, 88.90, 'A', '2024-02-20'),
(6, 'Frank Miller', 18, 55.00, 'D', '2024-02-22'),
(7, 'Grace Wilson', 24, 73.60, 'B', '2024-02-25'),
(8, 'Hannah Thomas', 20, 95.20, 'A', '2024-02-28');


SELECT *,
	ROW_NUMBER() OVER (ORDER BY TestScore desc) as rnk
	FROM Students

SELECT *,
	dense_rank() OVER (ORDER BY TestScore desc) as rnk
	FROM Students

SELECT *,
	RANK() OVER (ORDER BY TestScore desc) as rnk
	FROM Students

CREATE TABLE StockPrices (
    StockID INT,                     -- Unique identifier for each stock
    StockName VARCHAR(50),           -- Name of the stock (e.g., Apple, Tesla)
    TradeDate DATE,                  -- The day of stock trading
    OpenPrice DECIMAL(10,2),         -- Opening price of the stock
    ClosePrice DECIMAL(10,2),        -- Closing price of the stock
    HighPrice DECIMAL(10,2),         -- Highest price during the day
    LowPrice DECIMAL(10,2),          -- Lowest price during the day
    Volume BIGINT,                   -- Number of shares traded
    PRIMARY KEY (StockID, TradeDate) -- Composite key to ensure unique stock per day
);

INSERT INTO StockPrices (StockID, StockName, TradeDate, OpenPrice, ClosePrice, HighPrice, LowPrice, Volume) 
VALUES
(1, 'Apple', '2024-03-01', 150.00, 155.00, 157.00, 149.50, 2000000),
(1, 'Apple', '2024-03-02', 155.50, 158.75, 160.00, 154.50, 2200000),
(1, 'Apple', '2024-03-03', 159.00, 162.00, 164.00, 158.50, 2100000),
(1, 'Apple', '2024-03-04', 162.50, 160.00, 163.50, 159.00, 1900000),

(2, 'Tesla', '2024-03-01', 700.00, 715.50, 720.00, 695.00, 1500000),
(2, 'Tesla', '2024-03-02', 718.00, 730.00, 735.00, 715.00, 1600000),
(2, 'Tesla', '2024-03-03', 732.00, 740.50, 745.00, 730.00, 1700000),
(2, 'Tesla', '2024-03-04', 741.00, 738.00, 743.50, 735.50, 1650000);

SELECT sp.StockName,
	sp.TradeDate,
	sp.ClosePrice,
	ISNULL(LAG(ClosePrice) OVER(PARTITION BY StockName ORDER BY TradeDate), 0) as prev_price,
	ISNULL(sp.ClosePrice - LAG(ClosePrice) OVER(PARTITION BY StockName ORDER BY TradeDate), 0) as difference_prev_price 
	FROM StockPrices sp

	SELECT sp.StockName,
	sp.TradeDate,
	sp.ClosePrice,
	ISNULL(Lead(ClosePrice) OVER(PARTITION BY StockName ORDER BY TradeDate), 0) as prev_price,
	ISNULL(sp.ClosePrice - Lead(ClosePrice) OVER(PARTITION BY StockName ORDER BY TradeDate), 0) as difference_next_price 
	FROM StockPrices sp

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,       
    CustomerName VARCHAR(100),         
    Email VARCHAR(100) UNIQUE,         
    PhoneNumber VARCHAR(15),      
    Address VARCHAR(255),              
    City VARCHAR(50),                  
    Country VARCHAR(50),               
    RegistrationDate DATE              
);
INSERT INTO Customers (CustomerID, CustomerName, Email, PhoneNumber, Address, City, Country, RegistrationDate) 
VALUES
(1, 'Alice Johnson', 'alice@example.com', '+1234567890', '123 Main St', 'New York', 'USA', '2023-06-15'),
(2, 'Bob Smith', 'bob@example.com', '+1987654321', '456 Elm St', 'Los Angeles', 'USA', '2023-07-20'),
(3, 'Charlie Brown', 'charlie@example.com', '+1122334455', '789 Oak St', 'Chicago', 'USA', '2023-08-10'),
(4, 'David Williams', 'david@example.com', '+1555666777', '101 Pine St', 'Houston', 'USA', '2023-09-05'),
(5, 'Emily Davis', 'emily@example.com', '+1666777888', '202 Birch St', 'San Francisco', 'USA', '2023-10-12'),
(6, 'Frank Miller', 'frank@example.com', '+1777888999', '303 Cedar St', 'Seattle', 'USA', '2023-11-25'),
(7, 'Grace Wilson', 'grace@example.com', '+1888999000', '404 Willow St', 'Boston', 'USA', '2023-12-01'),
(8, 'Hannah Thomas', 'hannah@example.com', '+1999000111', '505 Maple St', 'Miami', 'USA', '2024-01-15');

select *
	,NTILE(4) OVER(ORDER BY CustomerID)
	from Customers
select *
	,NTILE(5) OVER(ORDER BY CustomerID)
	from Customers
