CREATE TABLE dq.dq_validation_results (
result_id INT IDENTITY(1,1) PRIMARY KEY,
rule_id INT NOT NULL,
employee_id NVARCHAR(50) NULL,
column_name NVARCHAR(128) NULL,
failure_value NVARCHAR(255) NULL,
detected_at DATETIME2(0) NOT NULL DEFAULT(SYSDATETIME())
);

SELECT COUNT(*)
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE s.name='dq' AND t.name='dq_validation_results';

SELECT COUNT(*) FROM dq.vw_duplicate_employees;