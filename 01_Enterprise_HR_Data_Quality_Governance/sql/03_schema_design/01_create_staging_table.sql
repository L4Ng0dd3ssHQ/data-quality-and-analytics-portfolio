/* =========================================================

   PHASE 3 — Create Staging Table

   Table: stg.employee_raw

   Purpose: Raw landing table for imported HR dataset

========================================================= */

IF OBJECT_ID('stg.employee_raw','U') IS NULL
BEGIN
CREATE TABLE stg.employee_raw (EmployeeID NVARCHAR (50) NULL,
FirstName NVARCHAR (100) NULL,
LastName NVARCHAR(100) NULL, 
Email NVARCHAR(255) NULL,
Department NVARCHAR(150) NULL,
Salary DECIMAL(18,2) NULL,
Age INT NULL,
Join_Date DATE NULL,
Status NVARCHAR(50) NULL);
END;
GO