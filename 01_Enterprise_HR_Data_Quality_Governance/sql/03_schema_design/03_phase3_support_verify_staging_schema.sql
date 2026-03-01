/* =========================================================
Support / Proof Queries 
========================================================= */

-- Check Salary datatype on staging table (adjust table name if yours differs)
SELECT
c.COLUMN_NAME,
c.DATA_TYPE,
c.NUMERIC_PRECISION,
c.NUMERIC_SCALE,
c.CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_SCHEMA = 'stg'
AND c.TABLE_NAME = 'employee_raw'
AND c.COLUMN_NAME = 'Salary';

