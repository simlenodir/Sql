Create Table Match_Result (
Team_1 Varchar(20),
Team_2 Varchar(20),
Result Varchar(20)
)

Insert into Match_Result Values('India', 'Australia','India');
Insert into Match_Result Values('India', 'England','England');
Insert into Match_Result Values('SouthAfrica', 'India','India');
Insert into Match_Result Values('Australia', 'England',NULL);
Insert into Match_Result Values('England', 'SouthAfrica','SouthAfrica');
Insert into Match_Result Values('Australia', 'India','Australia');

with cte_matches as (
	select Team_1 from Match_Result
	union all
	select Team_2 from Match_Result
), cte_wins as(
	select Team_1, count(Result) as Total_wins from Match_Result group by Team_1
),cte_draws as (
	select Team_1, count(*) as total_draws from Match_Result where result is null group by Team_1
	union all 
	select Team_2, count(*) as total_draws from Match_Result where result is null group by Team_2
)

select cte_matches.Team_1, count(*) as total_matches,
	cte_wins.Total_wins,
	isnull(cte_draws.total_draws, 0) as total_draws
	,count(*) - cte_wins.Total_wins - isnull(cte_draws.total_draws, 0) as total_loses
	from cte_matches
	inner join cte_wins on cte_matches.Team_1 = cte_wins.Team_1 
	left join cte_draws on cte_matches.Team_1 = cte_draws.Team_1
	group by cte_matches.Team_1, cte_wins.Total_wins, cte_draws.total_draws

drop table Employees
CREATE TABLE Employees (
    employee_id int,
    first_name varchar(50),
    last_name varchar(50),
    department_id int,
    salary decimal(10, 2),
    hire_date date
)

INSERT INTO employees (employee_id, first_name, last_name, department_id, salary, hire_date)
VALUES
    (1, 'Alice', 'Johnson', 101, 75000.00, '2020-02-15'),
    (2, 'Bob', 'Smith', 102, 64000.00, '2019-07-22'),
    (3, 'Charlie', 'Brown', 103, 82000.00, '2021-03-18'),
    (4, 'Diana', 'Evans', 101, 92000.00, '2018-11-05'),
    (5, 'Eve', 'Campbell', 104, 56000.00, '2022-01-10'),
    (6, 'Frank', 'Harris', 102, 72000.00, '2020-05-29'),
    (7, 'Grace', 'Lee', 103, 81000.00, '2019-09-17'),
    (8, 'Henry', 'Green', 104, 59000.00, '2021-06-01'),
    (9, 'Isabella', 'Garcia', 101, 66000.00, '2020-12-08'),
    (10, 'Jack', 'White', 102, 87000.00, '2017-08-25'),
  (11, 'Joe', 'Smith', 101, 75000.00, '2017-08-25'),
  (12, 'Lily', 'Pete', 102, 72000.00, '2017-08-25')

 with cte_emp as (
   select 
   e1.department_id
  ,MIN(e1.hire_date) as min_hired_date
  ,MAX(e1.hire_date) max_hired_date
  from Employees as E1
  group by e1.department_id
 )

 select cte_emp.department_id, e.salary as max_date_salary,
  e1.salary as min_hire_salary,
  cte_emp.max_hired_date 
  ,(e.salary - e1.salary) as difference,
  cte_emp.min_hired_date from cte_emp
  join Employees as e
  on e.department_id = cte_emp.department_id 
  and e.hire_date = cte_emp.max_hired_date
  join Employees as E1
  on E1.department_id = cte_emp.department_id 
  and e1.hire_date = cte_emp.min_hired_date
