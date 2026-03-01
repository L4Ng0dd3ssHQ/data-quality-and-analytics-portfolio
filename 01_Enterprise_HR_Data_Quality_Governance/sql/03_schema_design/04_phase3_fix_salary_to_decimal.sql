/* =========================================================
PHASE 3 (schema tweak) — Fix Salary datatype
Only run if Salary is not already DECIMAL(18,2)
========================================================= */

-- IMPORTANT:
-- If Salary currently contains non-numeric strings, this ALTER may fail.
-- In that case, we’ll do a safe convert via a new column approach.
ALTER TABLE stg.employee_raw
ALTER COLUMN Salary DECIMAL(18,2) NULL;
GO