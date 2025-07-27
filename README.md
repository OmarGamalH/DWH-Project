# Human Resources Data Warehouse & ETL Project

## Overview

This project implements a data pipeline for a Human Resources (HR) data warehouse using Apache NiFi and Microsoft SQL Server. The solution extracts data from an OLTP database (AdventureWorks2022), loads it into a star schema data warehouse (HumanResources_DWH), and validates the integrity of the data movement using PySpark.

## Table of Contents

- [Project Architecture](#project-architecture)
- [Star Schema Design](#star-schema-design)
- [ETL Workflow](#etl-workflow)
- [Validation Process](#validation-process)
- [Usage](#usage)
- [File Structure](#file-structure)
- [Screenshots](#screenshots)
- [Credits](#credits)

---

## Project Architecture

- **Source Database (OLTP)**: AdventureWorks2022 (HumanResources schema)
- **Data Warehouse (OLAP)**: HumanResources_DWH (star schema)
- **ETL Tool**: Apache NiFi (for orchestration and data movement)
- **Validation**: PySpark (for post-load validation)
- **Target Tables**: Employee_Dim, Department_Dim, Shift_Dim (dimensions), Rate_Fact (fact table)

---

## Star Schema Design

The data warehouse uses a star schema:

![image2](image2)

### **Fact Table**
- **Rate_Fact**: Contains measures related to employee pay rates, department, and shift.

### **Dimension Tables**
- **Employee_Dim**: Employee personal and job information.
- **Department_Dim**: Department names and groups.
- **Shift_Dim**: Shift names and times.

Refer to the [Production Envrionment.sql](Production%20Envrionment.sql) file for DDL scripts.

#### Source-to-Target Mapping

The tables in the data warehouse are populated from the following OLTP tables:

![image3](image3)

---

## ETL Workflow

The ETL process is orchestrated via Apache NiFi:

![image1](image1)

- **Extract**: NiFi processors run queries to pull data from AdventureWorks2022.
- **Load**: NiFi writes the extracted data directly into the OLAP tables in HumanResources_DWH.
- **Note**: No transformation is performed in Spark or NiFi; data is loaded as-is from source to target tables.

Each dimension and fact table has a dedicated flow group in NiFi, ensuring modular design and easy maintenance.

---

## Validation Process

Data validation is performed using PySpark scripts (`Validations.py`):

- Checks that column structures match between OLTP and OLAP tables (excluding system columns like `rowguid`).
- Verifies row counts and latest modified dates are identical between source and target.
- Logs all steps and issues in `logs.txt`.

**No data transformation or movement is performed using Spark—only validation.**

Sample validation logic:
```python
assert sorted(df_1_cols) == sorted(df_2_cols)
assert df_1.count() == df_2.count()
assert df_1_last_date == df_2_last_date
```

---

## Usage

### Prerequisites

- **Apache NiFi** installed and running
- **PySpark** environment set up (for validation only)
- **SQL Server** instance with AdventureWorks2022 and permissions to create HumanResources_DWH
- JDBC drivers available for SQL Server

### Steps

1. **Set Up Databases**
   - Run the DDL statements in `Production Envrionment.sql` to create the OLAP database and tables.

2. **Configure NiFi**
   - Import the provided NiFi flow JSON files (`Employee_Dimension.json`, `Department_Dimension.json`, `Shift_Diemension.json`, `Fact_Table.json`).
   - Update controller service connections as needed for your environment.

3. **Run the ETL Flows**
   - Start the NiFi flows for each dimension and fact table.
   - Monitor flow status in the NiFi UI.

4. **Run Validations**
   - Execute `Validations.py` to validate the ETL process.
   - Review `logs.txt` for results and any warnings/errors.

---

## File Structure

```
├── Department_Dimension.json     # NiFi flow for Department dimension
├── Employee_Dimension.json       # NiFi flow for Employee dimension
├── Fact_Table.json               # NiFi flow for Fact table
├── Shift_Diemension.json         # NiFi flow for Shift dimension
├── Production Envrionment.sql    # DDL & example queries for the production environment
├── Test Environment.sql          # Useful queries for testing and exploration
├── Validations.py                # PySpark script for ETL validation (no transformation)
├── logs.txt                      # Output log file for validation results
```

---

## Screenshots

**NiFi Workflow Overview**
> ETL orchestration for Dimensions and Fact Table
![image1](image1)

**Star Schema Diagram**
> Logical data warehouse schema (Employee, Department, Shift, Rate Fact)
![image2](image2)

**Source Table Relationships**
> OLTP schema showing how source tables relate
![image3](image3)

---

## Credits

- **ETL Architect/Developer**: [Your Name]
- **Source Database**: AdventureWorks2022 (Microsoft sample DB)
- **Tools Used**: Apache NiFi, PySpark (validation only), SQL Server

---

## License

This project is for educational and demonstration purposes. Adapt and use freely with attribution.
