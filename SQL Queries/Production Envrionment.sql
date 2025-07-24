IF NOT EXISTS ( SELECT * FROM sys.databases WHERE name = 'HumanResources_DWH')
BEGIN 
	CREATE DATABASE "HumanResources_DWH"
END

USE HumanResources_DWH; 
-- Employee Dimension 

SELECT 
		BusinessEntityID , 
		NationalIDNumber , 
		LoginID ,
		OrganizationNode ,
		OrganizationLevel,
		JobTitle,
		BirthDate,
		MaritalStatus,
		Gender,
		HireDate,
		SalariedFlag,
		VacationHours,
		SickLeaveHours,
		CurrentFlag
FROM AdventureWorks2022.HumanResources.Employee;

SELECT  COUNT(JobTitle) , COUNT(*) FROM AdventureWorks2022.HumanResources.Employee;

SELECT  *  FROM HumanResources_DWH.dbo.Employee_Dim;

CREATE TABLE Employee_Dim(
	BusinessEntityID BIGINT PRIMARY KEY,
	NationalIDNumber BIGINT UNIQUE ,
	LoginID VARCHAR(255) ,
	OrganizationNode HierarchyID ,
	OrganizationLevel INT,
	JobTitle VARCHAR(255) NOT NULL,
	BirthDate DATE,
	MaritalStatus CHAR(1) NOT NULL,
	Gender CHAR(1) NOT NULL,
	HireDate DATE ,
	SalariedFlag BIT,
	VacationHours INT,
	SickLeaveHours INT,
	CurrentFlag BIT,
)



-- Shift Dimension

SELECT 
	ShiftID , 
	Name , 
	StartTime , 
	EndTime 
FROM AdventureWorks2022.HumanResources.Shift;

CREATE TABLE Shift_Dim (
	ShiftID BIGINT PRIMARY KEY,
	Name VARCHAR(255),
	StartTime TIME,
	EndTime TIME,
)

SELECT * FROM Shift_Dim;

-- Department Dim
SELECT 
	DepartmentID,
	Name,
	GroupName
FROM AdventureWorks2022.HumanResources.Department;

CREATE TABLE Department_Dim (
	DepartmentID BIGINT PRIMARY KEY,
	Name VARCHAR(255) , 
	GroupName VARCHAR(255)
)

SELECT * FROM Department_Dim;

-- Fact Table 

SELECT	T.BusinessEntityID , 
		T.DepartmentID ,
		T.ShiftID,
		T.RateChangeDate,
		T.Rate,
		T.PayFrequency,
		T.Rate_per_month,
		( ( T.Rate - T.older_rate ) / T.older_rate * 100) AS RaiseInRate ,
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
ORDER BY BusinessEntityID


CREATE TABLE Rate_Fact (
	BusinessEntityID BIGINT FOREIGN KEY  REFERENCES Employee_Dim(BusinessEntityID),
	DepartmentID BIGINT FOREIGN KEY REFERENCES Department_Dim(DepartmentID),
	ShiftID BIGINT FOREIGN KEY REFERENCES Shift_Dim(ShiftID),
	RateChangeDate DATETIME ,
	Rate DECIMAL(10 ,4),
	PayFrequency INT,
	Rate_per_month DECIMAL(10 , 4),
	RaiseInRate DECIMAL(10 , 4),
	relative_rate Decimal(10,4)
)

SELECT * FROM Rate_Fact ORDER BY BusinessEntityID;