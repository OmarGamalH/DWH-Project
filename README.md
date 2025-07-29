# Human Resources Data Warehouse ETL & Quality System

## Overview

This repository provides a robust, scalable, and professional solution for building a Human Resources Data Warehouse (HR DWH) using Spark, MS SQL Server, and Apache NiFi. It includes:

- **Automated ETL pipelines** for extracting, transforming, and loading HR data.
- **Dimension and Fact table modeling** for business intelligence and analytics.
- **Data validation and quality checks** to ensure reliability and consistency.
- **Apache NiFi flows** for visual orchestration and monitoring.

This README covers the full architecture, setup, usage instructions, code structure, and visual diagrams.

---

## Architecture & Design

### Data Model

The HR DWH consists of:

- **Dimension Tables:** `Employee_Dim`, `Department_Dim`, `Shift_Dim`
- **Fact Table:** `Rate_Fact`
- **Metadata Table:** `quality_check` (for data quality metrics)

#### Entity-Relationship Diagram

![image3](image3)

#### Source Database ER Diagram

![image4](image4)

---

### ETL Flow (Apache NiFi)

ETL processes are orchestrated using Apache NiFi, with flows for each dimension and fact table.

#### NiFi Process Groups & Flow

- **Employee Dimension NiFi Flow:** Queries the source database, transforms, and loads into the Employee dimension.
- **Fact Table NiFi Flow:** Joins source tables, applies business logic, and loads into the Rate Fact table.

##### Example NiFi Flow for Employee Dimension

![image1](image1)

##### Example NiFi Environment Layout

![image2](image2)

---

## Folder & File Structure

```
.
├── Utilities.py                 # Spark utilities for data connection, loading, quality checks
├── quality_checks.py            # Script for running completeness checks and writing to metadata
├── Validations.py               # Spark data validation logic for OLTP vs OLAP
├── logs.txt                     # Logging output for ETL and validation processes
├── Employee_Dimension.json      # NiFi flow definition for Employee Dimension
├── Department_Dimension.json    # NiFi flow definition for Department Dimension
├── Shift_Diemension.json        # NiFi flow definition for Shift Dimension
├── Fact_Table.json              # NiFi flow definition for Fact Table
├── Production Envrionment.sql   # SQL DDL, source queries, and warehouse creation
└── README.md                    # This documentation
```

---

## Setup & Installation

### 1. Prerequisites

- **Python 3.8+**
- **PySpark**
- **MS SQL Server**
- **Apache NiFi**
- **JDBC Drivers:** Place `mssql-jdbc-12.10.1.jre8.jar` in `/usr/local/sqljdbc/enu/jars/`

### 2. Database Initialization

Run the SQL script:
```sql
-- In SSMS or Azure Data Studio
EXEC('Production Envrionment.sql')
```
This creates all required tables and schema (`HumanResources_DWH`, dimensions, fact, metadata).

### 3. Configure Apache NiFi

- Import the provided `.json` flows for each dimension and fact table into NiFi.
- Set up controller services for database connections (`Connection to HumanResources DWH`, `Connect to the AdventureWorks2022`).
- Ensure AvroReader is configured for record parsing.

### 4. Python Environment

Install dependencies:
```bash
pip install pyspark
```
Ensure your Python environment can access the JDBC driver and has permissions for database connections.

---

## ETL & Data Quality Workflow

### ETL Logic

- **Utilities.py:** Centralizes database connection, data ingestion, and loading.
- **Validations.py:** 
    - Class-based validation for Employee, Department, Shift.
    - Ensures column consistency, row count equality, and date synchronization between OLTP and OLAP.
- **quality_checks.py:** 
    - Runs completeness checks on tables (counting nulls in `id` columns).
    - Results are saved to the `metadata.quality_check` table for monitoring.

#### Sample Logging Output

See `logs.txt` for exact process tracking.

---

## NiFi Flows

- **Employee Dimension:** Queries source, loads into `Employee_Dim`.
- **Department Dimension:** Similar, for `Department_Dim`.
- **Shift Dimension:** Similar, for `Shift_Dim`.
- **Fact Table:** Complex SQL logic joining multiple source tables, transformations, and metrics computation.

#### Example: Employee Dimension NiFi Flow

- `QueryDatabaseTable`: Extracts source data.
- `PutDatabaseRecord`: Loads to warehouse.

---

## Data Model Details

### Dimension Tables

- **Employee_Dim**: Employee master data
- **Department_Dim**: Departments reference
- **Shift_Dim**: Shifts reference

### Fact Table

- **Rate_Fact**: Contains salary, rate change, department, shift, and calculated metrics.

### Metadata Table

- **quality_check**: Tracks completeness and quality of each table.

---

## Data Quality & Validation

- **Automated Spark checks**:
    - Column presence and order
    - Row counts
    - Last modification date
- **Completeness evaluation**:
    - Checks for nulls in critical identifier columns
    - Logs results for audit and monitoring

---

## Usage

### Running ETL & Validation

1. Start NiFi flows for each dimension & fact table.
2. Run `quality_checks.py` in Python to evaluate completeness.
3. Run `Validations.py` for cross-system consistency.

### Monitoring

- Check `logs.txt` for process status.
- Verify `metadata.quality_check` table for completeness results.

---

## Visuals & Reference Diagrams

- **Employee Dimension NiFi Flow:** ![image1](image1)
- **Environment Layout:** ![image2](image2)
- **Warehouse Entity-Relationship Diagram:** ![image3](image3)
- **Source Database ER Diagram:** ![image4](image4)

---

## Professional Practices

- **Logging:** All processes log to `logs.txt` for traceability.
- **Modular Code:** Utilities, validation, and ETL scripts are separated for maintainability.
- **NiFi Orchestration:** Visual, drag-and-drop orchestration for scaling and monitoring.
- **Data Model Documentation:** SQL and ER diagrams provided.
- **Quality Assurance:** Automated checks for completeness and consistency.

---


## License

Distributed under the MIT License. See `LICENSE` for more information.

---

## Support & Contributions

For issues and enhancements, please open a GitHub Issue or Pull Request.

---

## Appendix: Key SQL Definitions

See `Production Envrionment.sql` for full DDL and ETL SQL logic.

---

## End-to-End Flow Summary

- **Source Data** (AdventureWorks2022) → **NiFi Extraction and loading** → **DWH Tables** →  **Spark Validation & Quality Check** → **Analytics/Reporting**

---
