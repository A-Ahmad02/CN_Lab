-- Setting up database lab11_task3, and delete tables if already exists
CREATE DATABASE IF NOT EXISTS lab11_task3;
USE lab11_task3;
DROP TABLE IF EXISTS `lab11_task3`.`departments`;
DROP TABLE IF EXISTS `lab11_task3`.`employees`;

-- TASK 3-1: Creating Table Departments
CREATE TABLE Departments (
	 DepartmentID INT PRIMARY KEY, 
     DepartmentName Varchar(20), 
     DeptHeadID INT
    );

-- TASK 3-2: Creating Table  Employees
CREATE TABLE Employees (
	 EmployeeID INT PRIMARY KEY, 
     EmployeeName Varchar(20)
    );
    
-- TASK 3-3: Altering Table Departments
ALTER TABLE Departments
ADD COLUMN DepartmentCode Varchar(5);

-- TASK 3-4: Inserting Records
INSERT INTO Departments
	(DepartmentID, DepartmentName, DeptHeadID, DepartmentCode)
VALUES
	(1, 'Marketing' , 12345, 'MRKT'),
	(2, 'Accounting', 67890, 'ACNT');

INSERT INTO Employees
	(EmployeeID, EmployeeName)
VALUES
	(12345, 'Ahmad'),
	(67890, 'Rizwan');

-- TASK 3-5, 3-6, 3-7: Declare Foreign Key and set referential integrity constraints
ALTER TABLE Departments
ADD FOREIGN KEY (DeptHeadID) 
	REFERENCES Employees(EmployeeID)
    ON DELETE SET NULL
    ON UPDATE CASCADE;