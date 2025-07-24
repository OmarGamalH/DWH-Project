--SELECT count(*) FROM AdventureWorks2022.HumanResources.JobCandidate jc
--inner join AdventureWorks2022.HumanResources.Employee e on jc.BusinessEntityID = e.BusinessEntityID;



--select * from AdventureWorks2022.HumanResources.EmployeeDepartmentHistory where BusinessEntityID = 16 ;



--select BusinessEntityID 
--from AdventureWorks2022.HumanResources.EmployeeDepartmentHistory
--group by  BusinessEntityID
-- having count(*) > 1





SELECT * FROM AdventureWorks2022.HumanResources.Employee e
FULL JOIN AdventureWorks2022.HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
FULL JOIN AdventureWorks2022.HumanResources.EmployeeDepartmentHistory edh ON edh.BusinessEntityID = e.BusinessEntityID 
FULL JOIN AdventureWorks2022.HumanResources.Shift s ON s.ShiftID = edh.ShiftID 
FULL JOIN AdventureWorks2022.HumanResources.Department d ON d.DepartmentID = edh.DepartmentID; 


-- Department Table
SELECT * FROM AdventureWorks2022.HumanResources.Department;

-- DepartmentHistory Table
SELECT  *  FROM AdventureWorks2022.HumanResources.EmployeeDepartmentHistory
WHERE BusinessEntityID = 177;
-- GROUP BY DepartmentID , ShiftID HAVING DepartmentID = 7;

-- Employee Table
SELECT * FROM AdventureWorks2022.HumanResources.Employee;

-- EmployeePayHistory;
SELECT * FROM AdventureWorks2022.HumanResources.EmployeePayHistory 
WHERE BusinessEntityID = 177;
--where cast(RateChangeDate as date) > cast(ModifiedDate as date)

-- Shift
SELECT * FROM AdventureWorks2022.HumanResources.Shift;

SELECT * FROM AdventureWorks2022.HumanResources.EmployeePayHistory ebh
WHERE ebh.BusinessEntityID = 224;


--224	7	1	2009-01-07	2011-08-31	2011-08-29 00:00:00.000
--224	8	1	2011-09-01	NULL	2011-08-31 00:00:00.000

SELECT * FROM AdventureWorks2022.HumanResources.EmployeeDepartmentHistory ed 
WHERE ed.BusinessEntityID = 224;

-- False Query 

SELECT * FROM AdventureWorks2022.HumanResources.EmployeePayHistory ebh
INNER JOIN AdventureWorks2022.HumanResources.EmployeeDepartmentHistory ed 
ON ebh.BusinessEntityID = ed.BusinessEntityID ;


-- True Query 
SELECT T.*,
		( ( T.Rate - T.older_rate ) / T.older_rate * 100) AS raise_in_rate_in_percentage ,
		((T.Rate / T.total_rate) * 100) AS relative_rate
FROM (

	SELECT * , 
		LAG(Rate , 1 ,Rate) OVER(PARTITION BY BusinessEntityID ORDER BY RateChangeDate) AS older_rate , 
		SUM(Rate) OVER(PARTITION BY PayFrequency) AS total_rate , 
		PayFrequency * Rate AS Rate_per_month 
	FROM (
		SELECT * , ROW_NUMBER() OVER(PARTITION BY RateChangeDate , BusinessEntityID ORDER BY diff) AS final_diff_rank FROM (
			SELECT	 * , 
					RANK() OVER(PARTITION BY RateChangeDate , BusinessEntityID ORDER BY diff) AS diff_rank FROM (
							SELECT ed. BusinessEntityID , RateChangeDate , Rate , PayFrequency , DepartmentID , ShiftID , StartDate , EndDate , datediff(day, RateChangeDate, COALESCE(ed.EndDate , GETDATE()))  diff FROM AdventureWorks2022.HumanResources.EmployeePayHistory ebh
							INNER JOIN AdventureWorks2022.HumanResources.EmployeeDepartmentHistory ed 
							--ON ebh.RateChangeDate BETWEEN ed.StartDate AND COALESCE(ed.EndDate , GETDATE()) 
							ON ebh.BusinessEntityID = ed.BusinessEntityID  
			) AS T
		) AS T WHERE T.diff >= 0
	) AS T
	WHERE T.final_diff_rank = 1

) AS T 


-- diff < 0
--ROW_NUMBER() OVER(PARTITION BY T.RateChangeRate ORDER BY diff )


-- New Facts 
SELECT T.* ,
( ( T.Rate - T.older_rate ) / T.older_rate * 100) AS raise_in_rate_in_percentage ,
((T.Rate / T.total_rate) * 100) AS relative_rate
FROM 
(
	SELECT 
		*, 
		LAG(Rate , 1 ,Rate) OVER(PARTITION BY eph.BusinessEntityID ORDER BY eph.RateChangeDate) AS older_rate,
		SUM(Rate) OVER(PARTITION BY PayFrequency) AS total_rate ,
		PayFrequency * Rate AS Rate_per_month
	FROM AdventureWorks2022.HumanResources.EmployeePayHistory eph 
) AS T
ORDER BY T.BusinessEntityID;

