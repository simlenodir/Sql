create table #StaffInfo (id int identity, name varchar(100), salary decimal(10, 2))
INSERT INTO #StaffInfo (name, salary)  
VALUES  
('Alice Johnson', 55000.00),  
('Bob Smith', 62000.50),  
('Charlie Brown', 48000.75),  
('David Wilson', 75000.25),  
('Emma Davis', 68000.00),  
('Frank Miller', 52000.40),  
('Grace Lee', 72000.60),  
('Henry White', 57000.30),  
('Isla Green', 61000.20),  
('Jack Black', 49000.80);
select * from #StaffInfo

CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    SalesAmount DECIMAL(10, 2),
    ProductID INT,
    SaleDate DATE
);

INSERT INTO Sales (SalesID, SalesAmount, ProductID, SaleDate) VALUES
(1, 150.00, 1, '2025-01-01'),
(2, 200.00, 2, '2025-01-02'),
(3, 120.00, 3, '2025-01-03'),
(4, 180.00, 4, '2025-01-04'),
(5, 220.00, 5, '2025-01-05'),
(6, 140.00, 6, '2025-01-06'),
(7, 250.00, 1, '2025-01-07'),
(8, 170.00, 2, '2025-01-08'),
(9, 160.00, 3, '2025-01-09'),
(10, 190.00, 4, '2025-01-10'),
(11, 210.00, 5, '2025-01-11'),
(12, 130.00, 6, '2025-01-12'),
(13, 200.00, 1, '2025-01-13'),
(14, 180.00, 2, '2025-01-14'),
(15, 150.00, 3, '2025-01-15'),
(16, 220.00, 4, '2025-01-16'),
(17, 170.00, 5, '2025-01-17'),
(18, 160.00, 6, '2025-01-18'),
(19, 250.00, 1, '2025-01-19'),
(20, 180.00, 2, '2025-01-20'),
(21, 140.00, 3, '2025-01-21'),
(22, 190.00, 4, '2025-01-22'),
(23, 210.00, 5, '2025-01-23'),
(24, 160.00, 6, '2025-01-24'),
(25, 150.00, 1, '2025-01-25'),
(26, 200.00, 2, '2025-01-26'),
(27, 220.00, 3, '2025-01-27'),
(28, 130.00, 4, '2025-01-28'),
(29, 250.00, 5, '2025-01-29'),
(30, 180.00, 6, '2025-01-30'),
(31, 210.00, 1, '2025-02-01'),
(32, 170.00, 2, '2025-02-02'),
(33, 160.00, 3, '2025-02-03'),
(34, 190.00, 4, '2025-02-04'),
(35, 200.00, 5, '2025-02-05'),
(36, 220.00, 6, '2025-02-06'),
(37, 130.00, 1, '2025-02-07'),
(38, 250.00, 2, '2025-02-08'),
(39, 140.00, 3, '2025-02-09'),
(40, 180.00, 4, '2025-02-10');

-- task 9
create function fnEvenOdd (@number int)
returns varchar(50)
as 
begin
	declare @result varchar(50)
	set @result = cast(@number as varchar(10)) +
		case 
			when @number % 2 = 0 then ' is even'
			else ' is odd'
			end;
return @result;
end;

select dbo.fnEvenOdd (4)
select dbo.fnEvenOdd (7)

-- task 10
drop proc spMonthlyRevenue

create proc spMonthlyRevenue (@month int, @year int)
	as 
	begin 
	select ISNULL(SUM(s.SalesAmount), 0) AS TotalRevenue from Sales as s
	where @year = YEAR(s.SaleDate) and @month = MONTH(s.SaleDate)
	end;

exec spMonthlyRevenue 1, 2025
-- task 11
drop view vwRecentItemSales
create view vwRecentItemSales as
 select s.ProductID, SUM(s.SalesAmount) as total_Sales from Sales as s
 where YEAR(s.SaleDate) = YEAR(DATEADD(MONTH, -1, GETDATE()))
 and MONTH(s.SaleDate) = Month(DATEADD(MONTH, -1, GETDATE()))
 group by s.ProductID
 --   YEAR(DATEADD(MONTH, -1, GETDATE())) AS LastMonthYear,
	--Month(DATEADD(MONTH, -1, GETDATE())) as LastMonth 
select * from vwRecentItemSales

-- 12 task
Declare @currentDate date
set @currentDate = GETDATE()
print 'Current Date: ' + CONVERT(NVARCHAR, @currentDate);

-- task 13
DROP VIEW IF EXISTS vwHighQuantityItems;

CREATE VIEW vwHighQuantityItems AS
SELECT * 
FROM Items 
WHERE Quantity > 100;
SELECT * FROM vwHighQuantityItems;

--task 14
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
);

INSERT INTO Customers (CustomerID, CustomerName, City) VALUES
(1, 'Alice Johnson', 'New York'),
(2, 'Bob Smith', 'Los Angeles'),
(3, 'Charlie Brown', 'Chicago'),
(4, 'David Clark', 'Houston'),
(5, 'Eva Williams', 'Phoenix'),
(6, 'Frank Miller', 'San Francisco'),
(7, 'Grace Taylor', 'Boston'),
(8, 'Henry Martinez', 'Miami'),
(9, 'Irene Davis', 'Dallas'),
(10, 'James Moore', 'Atlanta'),
(11, 'Kathy Walker', 'Washington'),
(12, 'Leo Hernandez', 'Austin'),
(13, 'Maria White', 'Seattle'),
(14, 'Nancy Harris', 'Detroit'),
(15, 'Oscar Lewis', 'Philadelphia'),
(16, 'Paul Young', 'San Diego'),
(17, 'Quincy Robinson', 'Denver'),
(18, 'Rachel Scott', 'Portland'),
(19, 'Sam Evans', 'Minneapolis'),
(20, 'Tina King', 'Salt Lake City'),
(21, 'Ursula Wright', 'Orlando'),
(22, 'Victor Green', 'Las Vegas'),
(23, 'Walter Adams', 'Cleveland'),
(24, 'Xander Lopez', 'Tucson'),
(25, 'Yvonne Perez', 'Indianapolis'),
(26, 'Zachary Harris', 'Columbus'),
(27, 'Alice Moore', 'Memphis'),
(28, 'Bobby Wilson', 'Oklahoma City'),
(29, 'Catherine Lewis', 'Louisville'),
(30, 'Daniel Jackson', 'Nashville'),
(31, 'Eleanor White', 'Raleigh'),
(32, 'Felix Clark', 'New Orleans'),
(33, 'Grace Allen', 'St. Louis'),
(34, 'Howard Young', 'San Antonio'),
(35, 'Ivy King', 'Las Vegas'),
(36, 'John Wright', 'San Jose'),
(37, 'Kimberly Brown', 'Austin'),
(38, 'Liam Scott', 'Phoenix'),
(39, 'Monica Hall', 'Denver'),
(40, 'Neil Adams', 'Chicago');

drop table if exists #ClientOrders
create table #ClientOrders(id int identity, ClientID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
)

insert into #ClientOrders 
	select c.CustomerID, o.OrderDate, o.OrderAmount
	from Customers as c
	join [lesson_16].[dbo].[Orders] as o
	on c.CustomerID = o.CustomerID
	where o.OrderDate not in (select OrderDate from #ClientOrders)
select * from #ClientOrders

-- task 15
drop table staff;
use database lesson_16;
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Department VARCHAR(100) NOT NULL,
	salary decimal(10, 2)
);

INSERT INTO Staff (StaffID, Name, Department, salary) VALUES
(101, 'Alice Johnson', 'HR', 2000),
(102, 'Bob Smith', 'IT', 3000),
(103, 'Charlie Brown', 'Finance', 4000),
(104, 'David Lee', 'Marketing', 5000);


create proc spStaffDetails @StaffID int
	as 
	begin
	select Name, department from [Staff] as s
	Where s.staffId = @StaffID
	end;
exec spStaffDetails  @StaffID = 102;

-- task 16
drop function if exists fnAddNumbers 
create function fnAddNumbers (@a int, @b int)
	returns float
	as 
	begin
	return coalesce(@a, 0) + coalesce(@b, 0)
	end;

select dbo.fnAddNumbers(5, 4) as resultSum

--task 17

CREATE TABLE Items (
    ItemID INT PRIMARY KEY,
    ItemName VARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Items (ItemID, ItemName, Price) VALUES
(1, 'Laptop', 1000.00),
(2, 'Mouse', 25.00),
(3, 'Keyboard', 50.00);

CREATE TABLE #NewItemPrices (
    ItemID INT,
    NewPrice DECIMAL(10,2)
);

INSERT INTO #NewItemPrices (ItemID, NewPrice) VALUES
(1, 950.00),   
(2, 30.00);    

MERGE INTO ITEMS AS target
	USING #NewItemPrices as source
	on target.ItemID = source.ItemID
	When Matched then
	update set target.Price = source.NewPrice;

-- task 18
select * from Customers
create view vwStaffSalaries as
select name, salary from [dbo].[Staff]
select * from vwStaffSalaries

-- task 19
create proc spClientPurchases @clientID int
	as 
	begin
	select * from Customers as c
	join Orders as o
	on c.CustomerID = o.CustomerID
	where c.CustomerID = @clientID
	end;

	exec spClientPurchases @clientID = 1	 

create function fnStringLength (@parametr varchar(max))
	returns int
	as 
	begin
	return LEN(@parametr)
	end;

	select dbo.fnStringLength('adsfhm') as length_of_word
