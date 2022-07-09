-- use database college
use College

-- display all tables in db
select * from INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = 'dbo'

-- import all tablas from college database
select *
into dsuser22.Classrooms
from dbo.Classrooms

select *
into dsuser22.Teachers
from dbo.Teachers

select *
into dsuser22.Departments
from dbo.Departments

select *
into dsuser22.courses
from dbo.courses

select *
into dsuser22.Students
from dbo.Students

-- display all tables in college database
SELECT *
  FROM [College].[dsuser22].[Classrooms]

SELECT *
  FROM [College].[dsuser22].[Teachers]

SELECT *
  FROM [College].[dsuser22].[Departments]

SELECT *
  FROM [College].[dsuser22].[Courses]

SELECT *
  FROM [College].[dsuser22].[Students]


---------------------------------------------------------------------
------  SQL - Class 1
---------------------------------------------------------------------

--- Create and drop a database
CREATE DATABASE College3;

DROP DATABASE [college3]
GO


CREATE DATABASE College2;
USE COLLEGE2

--- Create a table

CREATE TABLE dbo.Departments (
	DepartmentId	INT NOT NULL,
	DepartmentName  VARCHAR(20)
)


CREATE TABLE dbo.Course (
	CourseId		INT NOT NULL,
	CourseName		VARCHAR(100),
	DepartmentID	INT,
	TeacherId		INT
)

--- Drop a table
DROP TABLE dbo.Course

--- Change the structure of a table

ALTER TABLE dbo.Course ADD Test DECIMAL(8,3)

ALTER TABLE dbo.Course DROP COLUMN Test


--- Add some data to an existing table

INSERT INTO College2.dbo.Departments (DepartmentId,DepartmentName) VALUES (1,'English')
INSERT INTO College2.dbo.Departments (DepartmentId,DepartmentName) VALUES (2,'Science')
INSERT INTO dbo.Departments VALUES (3,'Arts')
INSERT INTO Departments VALUES (4,'Sport')

--- View the content of a table

SELECT * FROM Departments

SELECT DepartmentName, DepartmentId DepartmentName  FROM Departments

SELECT DepartmentName, DepartmentId
FROM Departments
WHERE DepartmentId  IN (2,4)
ORDER BY DepartmentId DESC

--- Create a new table based on an existing table

SELECT DepartmentName, DepartmentId
INTO DepTest -- move the columns to new tabla
FROM Departments
WHERE DepartmentId  IN (2,4)
ORDER BY DepartmentId DESC

SELECT * FROM DepTest

--- Add data to an existing table, based on data from another table

INSERT INTO DepTest
SELECT DepartmentName, DepartmentId, 1
FROM Departments
WHERE DepartmentId  IN (1,3)
ORDER BY DepartmentId DESC

--- Update a column in a table

ALTER TABLE dbo.DepTest ADD Test DECIMAL(8,3)

SELECT * FROM DepTest

UPDATE DepTest SET test = 0

UPDATE DepTest SET test = 5
WHERE DepartmentId < 3

UPDATE DepTest SET test = 10
WHERE DepartmentId >= 3

--- Delete data from a table (without deleting its structure)

DELETE FROM DepTest
WHERE DepartmentId >= 3

--- Delete will remove the data row by row, while looking the table until it finish
DELETE FROM DepTest

--- Truncate will remove the data all at once
TRUNCATE TABLE DepTest