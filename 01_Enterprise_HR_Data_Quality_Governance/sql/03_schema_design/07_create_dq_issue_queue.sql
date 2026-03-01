IF OBJECT_ID('dq.dq_issue_queue','U') IS NULL
BEGIN
CREATE TABLE dq.dq_issue_queue
(
issue_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_dq_issue_queue PRIMARY KEY,
run_id UNIQUEIDENTIFIER NOT NULL,
rule_id INT NOT NULL,
employee_key NVARCHAR(50) NULL, -- Employee_ID (or other identifier)
field_name SYSNAME NULL,
issue_detail NVARCHAR(4000) NULL,

status NVARCHAR(20) NOT NULL CONSTRAINT DF_issue_status DEFAULT ('Pending'), -- Pending/Resolved
detected_at DATETIME2(0) NOT NULL CONSTRAINT DF_issue_detected DEFAULT (SYSDATETIME()),
resolved_at DATETIME2(0) NULL,
resolved_by NVARCHAR(100) NULL
);
END;
GO