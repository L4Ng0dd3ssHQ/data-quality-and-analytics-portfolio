IF OBJECT_ID('dq.dq_run_log','U') IS NULL
BEGIN
CREATE TABLE dq.dq_run_log
(
run_id UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_dq_run_log PRIMARY KEY,
run_started_at DATETIME2(0) NOT NULL CONSTRAINT DF_run_started DEFAULT (SYSDATETIME()),
run_ended_at DATETIME2(0) NULL,

source_table SYSNAME NOT NULL,
target_table SYSNAME NULL,

total_rows INT NULL,
rules_executed INT NULL,
fail_count INT NULL,
pass_count INT NULL,

notes NVARCHAR(2000) NULL
);
END;
GO