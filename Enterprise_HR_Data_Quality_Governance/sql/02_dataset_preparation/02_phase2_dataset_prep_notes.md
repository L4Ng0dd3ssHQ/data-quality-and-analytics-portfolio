/* =========================================================
PHASE 2 — Dataset Preparation (documentation script)
=========================================================

Data source:
- Messy_Employee_dataset.csv (Kaggle)

Confirmed in preview:
- EmployeeID looks like EMP1000, EMP1001, etc. (text)
- Join_Date appears as x/x/xxxx (date-like)
- Department examples: DevOps-California, Finance-Texas, Admin-Nevada
- Salary had import warnings previously; we decided to treat Salary as numeric money-like value
and ultimately store it as DECIMAL(18,2) in staging.
- Status is text-like (nvarchar)

========================================================= */