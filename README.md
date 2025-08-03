# AdventureWorks2022 Data Warehouse Project

## Overview

This project demonstrates the implementation of both **Traditional Data Warehouse (DWH)** and **Modern Data Warehouse using the Medallion Architecture** on the popular [AdventureWorks2022](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure) database. The project covers the complete pipeline: from data extraction and ETL, to advanced data quality checks and data modeling, using Apache NiFi, PySpark, and MS SQL Server.

<br/>

---

## Table of Contents

- [Project Objectives](#project-objectives)
- [Architecture Overview](#architecture-overview)
  - [Traditional DWH](#traditional-dwh)
  - [Medallion Architecture DWH](#medallion-architecture-dwh)
- [Data Pipeline](#data-pipeline)
  - [ETL Flow with Apache NiFi](#etl-flow-with-apache-nifi)
- [Data Modeling](#data-modeling)
  - [Source Schema (AdventureWorks2022)](#source-schema-adventureworks2022)
  - [DWH Schema (Star Schema)](#dwh-schema-star-schema)
- [Data Quality & Validation](#data-quality--validation)
- [Key Features](#key-features)
- [How to Run](#how-to-run)
- [Screenshots & Diagrams](#screenshots--diagrams)
- [Credits](#credits)

---

## Project Objectives

- **Compare Traditional vs. Modern DWH:** Showcase the differences and benefits of traditional and medallion architectures.
- **End-to-End Data Pipeline:** Extract, transform, and load (ETL) data from AdventureWorks2022 into robust DWH schemas.
- **Automated Data Quality:** Implement column-level completeness, uniqueness, and validity checks.
- **Orchestration:** Use Apache NiFi and PySpark for scalable orchestration and automation.
- **Best Practices:** Follow professional standards in logging, modularity, and documentation.

---

## Architecture Overview

### Traditional DWH

- **Source:** AdventureWorks2022 (OLTP)
- **Destination:** HumanResources_DWH (OLAP)
- **ETL:** Extracted via PySpark, loaded into classic dimension (`Employee_Dim`, `Department_Dim`, `Shift_Dim`) and fact (`Rate_Fact`) tables.
- **Schema:** Star schema optimized for analytical queries.

**ERD: Traditional DWH**
![image4](image4)

---

### Medallion Architecture DWH

- **Bronze Layer:** Raw ingested data (mirrors source).
- **Silver Layer:** Cleaned and conformed (not shown in SQL, but assumed in architecture).
- **Gold Layer:** Final analytical tables.
- **Quality Layer:** Data quality metrics recorded in a dedicated schema.

**ERD: Source Schema (AdventureWorks2022)**
![image5](image5)

---

## Data Pipeline

### ETL Flow with Apache NiFi

- **Orchestration:** Apache NiFi is used for automated extraction and loading between source and DWH.
- **Process Flow Example:**
  - Query data from source using `QueryDatabaseTable`.
  - Load into DWH via `PutDatabaseRecord`.

**Sample NiFi Flow: Employee Dimension**
![image1](image1)

**NiFi High-level Flow: Dimensions and Fact Table**
![image2](image2)

---

## Data Modeling

### Source Schema (AdventureWorks2022)

- **Tables:** Employee, Department, Shift, EmployeeDepartmentHistory, EmployeePayHistory
- **Relationships:** Complex, normalized for OLTP efficiency

**See Source ERD:**  
![image5](image5)

---

### DWH Schema (Star Schema)

- **Dimension Tables:** `Employee_Dim`, `Department_Dim`, `Shift_Dim`
- **Fact Table:** `Rate_Fact` (captures measures such as rate changes, pay frequency, etc.)
- **Relationships:** Simplified for fast analytics

**See DWH ERD:**  
![image4](image4)

---

## Data Quality & Validation

- **Automated Checks:** All ETL data loads include:
  - **Completeness:** Null checks on critical columns.
  - **Uniqueness:** Distinct value checks for key columns.
  - **Validity:** Range and domain checks (e.g., valid gender, status, etc.)
- **Logging:** All actions and checks are logged in `logs.txt` for audit and debugging.
- **Quality Metrics Table:** Results are persisted in `data_quality.data_quality` schema for reporting and monitoring.

---

## Key Features

- **Dual Architecture:** Both traditional and medallion DWH architectures implemented.
- **Modular ETL:** Clean, reusable PySpark modules for connection, quality, and loading.
- **NiFi Orchestration:** Visual, scalable flow management.
- **Professional Logging:** All operations are logged with detailed timestamps and context.
- **Data Quality First:** Automated, auditable data quality at every stage.

---

## How to Run

1. **Requirements:**
   - MS SQL Server with AdventureWorks2022 installed
   - Apache NiFi (2.x recommended)
   - Python 3.x with PySpark
2. **Setup:**
   - Run the SQL scripts (`Traditional DWH.sql`, `DWH in Medallion Architecture.sql`) to create the required schemas and tables.
   - Configure NiFi connections to both source and DWH databases.
   - Place PySpark scripts (`Utilities.py`, `quality_checks.py`, etc.) and NiFi flow JSONs in your workspace.
3. **Execution:**
   - Start NiFi and import the provided flows.
   - Run PySpark scripts for quality checks and validations
   - Inspect logs and quality tables for validation and troubleshooting.

---

## Screenshots & Diagrams

### 1. NiFi Flow: Employee Dimension
![image1](image1)

### 2. NiFi Flow: All Dimensions and Fact Table
![image2](image2)

### 3. Star Schema ERD (DWH)
![image4](image4)

### 4. Source Schema ERD (AdventureWorks2022)
![image5](image5)

---

## Credits

- **Author:** OmarGHamed
- **Database:** [AdventureWorks2022 - Microsoft](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure)
- **Tools:** Apache NiFi, PySpark, MS SQL Server

---

> For questions or collaboration, please contact [OmarGHamed](https://github.com/OmarGHamed).
