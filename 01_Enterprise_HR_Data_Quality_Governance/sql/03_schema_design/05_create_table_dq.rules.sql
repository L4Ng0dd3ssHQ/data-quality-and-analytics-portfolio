CREATE TABLE dq.dq_rules (
rule_id INT IDENTITY(1,1) PRIMARY KEY,
rule_name NVARCHAR(100) NOT NULL,
rule_description NVARCHAR(255) NOT NULL,
target_table NVARCHAR(128) NOT NULL, -- e.g., 'stg.employee_raw'
target_column NVARCHAR(128) NULL, -- NULL if rule spans multiple columns
severity NVARCHAR(20) NOT NULL, -- 'HIGH' | 'MEDIUM' | 'LOW'
is_active BIT NOT NULL DEFAULT(1),
created_at DATETIME2(0) NOT NULL DEFAULT(SYSDATETIME())
);

INSERT INTO dq.dq_rules (rule_name, rule_description, target_table, target_column, severity)
VALUES ('EMPID_NOT_NULL', 'EmployeeID must not be NULL or blank.', 'stg.employee_raw', 'EmployeeID', 'HIGH'),
('EMAIL_FORMAT', 'Email must contain "@" and "." (basic format check).', 'stg.employee_raw', 'Email', 'HIGH'),
('AGE_RANGE', 'Age must be between 18 and 70 when not NULL.', 'stg.employee_raw', 'Age', 'MEDIUM'),
('SALARY_POSITIVE', 'Salary must be > 0 when not NULL.', 'stg.employee_raw', 'Salary', 'HIGH'),
('JOIN_DATE_NOT_FUTURE', 'Join_Date must not be in the future when not NULL.', 'stg.employee_raw', 'Join_Date', 'MEDIUM'),
('STATUS_ALLOWED', 'Status must be one of: Active, Terminated (case-insensitive).', 'stg.employee_raw', 'Status', 'MEDIUM'),
('NAME_NOT_BLANK', 'FirstName and LastName must not be NULL or blank.', 'stg.employee_raw', NULL, 'MEDIUM'),
('DEPT_FORMAT', 'Department should follow "Dept-State" format and contain "-".', 'stg.employee_raw', 'Department','LOW');

SELECT rule_id, rule_name, severity, is_active
FROM dq.dq_rules
ORDER BY rule_id;
