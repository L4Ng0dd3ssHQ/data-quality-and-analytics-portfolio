/* =========================================================
Enterprise HR Data Quality & Governance System
PHASE 1 — Environment Setup
========================================================= */

-- (1) Create database if it doesn't exist
IF DB_ID(N'EnterpriseDataQuality') IS NULL
BEGIN
CREATE DATABASE EnterpriseDataQuality;
END
GO

USE EnterpriseDataQuality;
GO

-- (2) Create required schemas (staging + clean + dq)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'stg')
EXEC(N'CREATE SCHEMA stg AUTHORIZATION dbo;');

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'clean')
EXEC(N'CREATE SCHEMA clean AUTHORIZATION dbo;');

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'dq')
EXEC(N'CREATE SCHEMA dq AUTHORIZATION dbo;');
GO
