IF OBJECT_ID('clean.employee_cleaned','U') IS NULL
BEGIN
CREATE TABLE clean.employee_cleaned
(
Employee_ID NVARCHAR(50) NULL,
First_Name NVARCHAR(100) NULL,
Last_Name NVARCHAR(100) NULL,
Age INT NULL,
Department_Region NVARCHAR(150) NULL,
Status NVARCHAR(50) NULL,
Join_Date DATE NULL,
Salary DECIMAL(18,2) NULL,
Email NVARCHAR(255) NULL,
Phone NVARCHAR(50) NULL,
Performance_Score NVARCHAR(50) NULL,
Remote_Work NVARCHAR(50) NULL,

cleaned_at DATETIME2(0) NOT NULL CONSTRAINT DF_employee_cleaned_cleaned_at DEFAULT (SYSDATETIME()),
source_table SYSNAME NOT NULL CONSTRAINT DF_employee_cleaned_source DEFAULT ('stg.employee_raw')
);
END;
GO