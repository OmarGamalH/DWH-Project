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

<img width="1416" height="797" alt="Image" src="https://github.com/user-attachments/assets/888735ff-bd1a-41aa-8250-13dbd125216a" />

### **Fact Table**
- **Rate_Fact**: Contains measures related to employee pay rates, department, and shift.

### **Dimension Tables**
- **Employee_Dim**: Employee personal and job information.
- **Department_Dim**: Department names and groups.
- **Shift_Dim**: Shift names and times.

Refer to the [Production Envrionment.sql](Production%20Envrionment.sql) file for DDL scripts.

#### Source-to-Target Mapping

The tables in the data warehouse are populated from the following OLTP tables:

<img width="1410" height="785" alt="Image" src="https://github.com/user-attachments/assets/acb36dcb-fc3d-44df-8b83-915dd449911b" />

---

## ETL Workflow

The ETL process is orchestrated via Apache NiFi:

<img width="1917" height="910" alt="Image" src="https://github.com/user-attachments/assets/34ce6b5a-8fce-48bf-9ec8-c65e617c1ea0" />
<img width="1918" height="907" alt="Image" src="https://github.com/user-attachments/assets/18733376-d0b3-47d3-9c43-5dd46599002e" />

- **Extract**: NiFi processors run queries to pull data from AdventureWorks2022.
- **Load**: NiFi writes the extracted data directly into the OLAP tables in HumanResources_DWH.

Each dimension and fact table has a dedicated flow group in NiFi, ensuring modular design and easy maintenance.

---

## Validation Process

Data validation is performed using PySpark scripts (`Validations.py`):

- Checks that column structures match between OLTP and OLAP tables (excluding system columns like `rowguid`).
- Verifies row counts and latest modified dates are identical between source and target.
- Logs all steps and issues in `logs.txt`.


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
   - Review `logs.txt` for results and any warnings/errors.R

---

## File Structure

```
├── Department_Dimension.json     # NiFi flow for Department dimension
├── Employee_Dimension.json       # NiFi flow for Employee dimension
├── Fact_Table.json               # NiFi flow for Fact table
├── Shift_Diemension.json         # NiFi flow for Shift dimension
├── Production Envrionment.sql    # DDL & example queries for the production environment
├── Test Environment.sql          # Useful queries for testing and exploration
├── Validations.py                # PySpark script for ETL validation
├── logs.txt                      # Output log file for validation results
```

---


## Credits

- **Source Database**: AdventureWorks2022 (Microsoft sample DB)
- **Tools Used**: Apache NiFi, PySpark (validation), SQL Server 

---

## License

This project is for educational and demonstration purposes. Adapt and use freely with attribution.
