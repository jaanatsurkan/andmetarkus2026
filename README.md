# Data Analytics Portfolio
This repository includes projects from my Data Analytics studies. Each project shows the full process—from cleaning and preparing data to analyzing it and creating insights using Power BI.


# Sales Report
You can find the Power BI file for Sales Report: https://github.com/jaanatsurkan/andmetarkus2026/blob/main/SalesReport.pbix
This file can be opened in Power BI Desktop.
Next, the analysis steps are explained.

## Overview of Dataset
This is an example dataset created by OpenAI.

## Data Cleaning
The original table was "SalesTable.csv" which was controlled for data quality through PowerQuery.
I checked for format issues and outliers.

Fixes made:
1) CustomerID: C005 should be C004, corrected in the source file on 31.03.2026 based on sales representative input
2) ProductID: P005 and P006 should be P004, corrected in the source file on 31.03.2026 based on sales representative input
3) Incorrect quantity on sales row S00009, was 300, corrected to 3 in the cleaned file on 31.03.2026 based on sales representative input
4) Incorrect quantity on sales row S00010, was 2000, corrected to 20 in the cleaned file on 31.03.2026 based on sales representative input


# Employee Report

## Problem Statement
HR department wants an overview of active and left employee over time and results of the satisfaction survey.  

## Plan
I will create a Power BI report to give this overview.  

## Data
HR department gave me to files:
- "Employee_Satisfaction_Survey.xlsx"
- "HR_dataset.CSV"

### Data Cleaning
I checked data for uniquess, formats and outliers through Powerquery.
Survey dataset didn't have a unique key column. I created new column "AnswerKey" whitch combined "Question Round" and "Answer ID".
In HR dataset, I removed columns with personal data: "First Name", "Last Name" and "Email". Also removed "Employee Status" as the data in that column was not up to date according to the HR department.
Column "Salary" was changed to Decimal Number format. 
