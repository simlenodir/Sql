 select * from Employees

; with cte_emp as (
	select e1.EmployeeID, e1.EmployeeName
	,CAST('No manager' as varchar(100)) as Manager
	,0 as level
	from Employees e1
	where ManagerID is null

	union all 

	select e2.EmployeeID, e2.EmployeeName
		,isnull(cte_emp.EmployeeName, 'No manager')
		,cte_emp.level + 1
		from Employees as E2
		join cte_emp on cte_emp.EmployeeID = E2.ManagerID
 )
-- select  * from cte_emp
 select cte_emp.level, count(*) as count_of_level from cte_emp 
 group by level
 order by level

 ;with cte_emp1 as (
	select E1.EmployeeID, E1.EmployeeName, ISNULL(e2.EmployeeName, 'No manager') as manager
	from Employees as E1
	left join Employees as E2 on E1.ManagerID = E2.EmployeeID 
 )
 select * from cte_emp1

 -- Task 7
SELECT e.EmployeeID, e.EmployeeName
FROM Employees e
LEFT JOIN (SELECT DISTINCT ManagerID FROM Employees WHERE ManagerID IS NOT NULL) m
ON e.EmployeeID = m.ManagerID
WHERE m.ManagerID IS NULL;

WITH Managers AS (
    -- Get a list of all distinct ManagerIDs from the Employees table
    SELECT DISTINCT ManagerID 
    FROM Employees 
    WHERE ManagerID IS NOT NULL
)
SELECT e.EmployeeID, e.EmployeeName
FROM Employees e
LEFT JOIN Managers m ON e.EmployeeID = m.ManagerID
WHERE m.ManagerID IS NULL;

-- task 9
;with cte_lvl as (
	select  e.EmployeeID, EmployeeName, 0 as lvl, ManagerID
		from Employees as E
		where e.ManagerID is null
	union all
		select m.EmployeeID, m.EmployeeName, cte_lvl.lvl + 1, m.ManagerID
			from Employees as m
		inner join cte_lvl on cte_lvl.EmployeeID = m.ManagerID
)
select * from cte_lvl
where cte_lvl.ManagerID = 1;

;with cte_lvl as (
	select  e.EmployeeID, EmployeeName, 0 as lvl, ManagerID
		from Employees as E
		where e.ManagerID is null
	union all
		select m.EmployeeID, m.EmployeeName, cte_lvl.lvl + 1, m.ManagerID
			from Employees as m
		inner join cte_lvl on cte_lvl.EmployeeID = m.ManagerID
)
select MAX(lvl) 
	from cte_lvl
