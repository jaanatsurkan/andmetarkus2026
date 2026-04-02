Siin on andmetarkuse materjalid.

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
