# Modern Data Warehouse with Medallion Architecture

## Overview

This project delivers a robust, production-grade Data Warehouse solution using the Medallion Architecture (Bronze, Silver, Gold layers) enhanced with Apache NiFi workflows, PySpark ETL, and advanced Data Quality validations. It demonstrates both a modern Medallion-based design and a traditional DWH approach for comparison and learning.

> **Dataset Used:**  
> All data flows, transformations, and schema examples in this project use the [AdventureWorks2022](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16) sample dataset as the source OLTP database.

---

## Table of Contents

- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Key Features](#key-features)
- [ETL & Data Quality](#etl--data-quality)
- [NiFi Workflows](#nifi-workflows)
- [Schema Design](#schema-design)
- [Setup & Usage](#setup--usage)
- [Images & Workflow Diagrams](#images--workflow-diagrams)
- [License](#license)

---

## Architecture

The Medallion Architecture divides the data warehouse into three layers:

- **Bronze Layer**: Raw, ingested data with minimal transformation.
- **Silver Layer**: Cleansed, conformed, and enriched data structured in dimensions.
- **Gold Layer**: Aggregated fact tables optimized for analytics and business reporting.

This layered approach ensures scalable, maintainable, and high-quality analytics.

---

## Project Structure

```
├── DWH with Medallion Architecture/
│   ├── Bronze Layer/
│   │   └── Bronze Layer.sql
│   ├── Silver Layer/
│   │   └── Silver layer.sql
│   ├── Gold Layer/
│   │   └── Gold Layer.sql
├── ETL and Data Quality/
│   ├── ETL_pipeline.py
│   ├── Utilities.py
│   ├── Validations.py
│   ├── quality_checks.py
│   └── logs.txt
├── Nifi Workflow/
│   ├── DWH medallion Architecture/
│   │   ├── Employee_Table.json
│   │   ├── Department_Table.json
│   │   ├── Shift_Table.json
│   │   ├── EmployeeDepartmentHistory_Table.json
│   │   ├── EmployeePayHistory_Table.json
│   │   ├── Fact_Table.json
│   │   └── Fact Table Workflow.png
│   └── Traditional DWH/
│       ├── Employee_Dimension.json
│       ├── Department_Dimension.json
│       ├── Shift_Diemension.json
│       ├── Fact_Table.json
│       └── Nifi Flow.png
├── Schema/
│   ├── OLTP Schema.png
│   └── DWH Schema (Star Schema).png
├── Traditional Data Warehouse/
│   ├── Traditional DWH.sql
│   └── Test Environment.sql
├── LICENSE
└── README.md
```

---

## Key Features

- **Medallion Architecture**: Modular, scalable, and clear separation of concerns.
- **ETL Pipelines**: Automated PySpark scripts for loading, transforming, and validating data.
- **Data Quality**: Built-in completeness, uniqueness, and validity checks for critical entities.
- **NiFi Orchestration**: Visual workflow management for seamless data movement and monitoring.
- **Schema Documentation**: Clear Star Schema for analytical use, plus OLTP schema reference.
- **Traditional DWH Reference**: Side-by-side implementation for education and benchmarking.
- **Realistic Demo Data**: All workflows and transformations use the AdventureWorks2022 sample database.

---

## ETL & Data Quality

- **ETL_pipeline.py**: Orchestrates extraction, transformation, and loading of Employee, Department, and Shift data from Bronze layer to Silver layer.
- **Utilities.py**: Contains reusable Spark/PySpark functions for connecting, loading, and transforming table data.
- **quality_checks.py**: Runs automated column-level data quality checks (completeness, uniqueness, validity) and logs results.
- **Validations.py**: Validates source and destination tables for schema and data consistency.

Data quality results are stored in a dedicated schema (`data_quality`) for auditing.

---

## NiFi Workflows

- **Apache NiFi** is used for orchestrating data flows between layers and environments. All critical ingestion and transformation steps are visually managed for transparency and reliability.

- Workflows are described in `.json` files and visualized in PNG images for quick reference.

---

## Schema Design

- **Star Schema** for analytics
  
- **OLTP Schema** for source system reference 
- SQL files define all necessary tables for Bronze, Silver, and Gold layers, as well as traditional DWH.

---

## Setup & Usage

### Prerequisites

- Python 3.8+
- PySpark
- Apache NiFi
- MS SQL Server (for demo data)
- AdventureWorks2022 sample database (see [official docs](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16))
- JDBC driver for SQL Server

### Steps

1. **Clone the repository** and review the folder structure.
2. **Prepare your databases** using provided SQL scripts:
    - Run `Bronze Layer.sql`, `Silver layer.sql`, and `Gold Layer.sql` to initialize Medallion DWH.
    - Optionally, run scripts from `Traditional Data Warehouse` for legacy setup.
    - **Load AdventureWorks2022** into your SQL Server instance as the OLTP source.
3. **Configure NiFi**:
    - Import relevant JSON flows into NiFi.
    - Set up controller services for database connections.
    - Start the workflows and monitor data movement visually.
4. **Run ETL & Data Quality Checks**:
    - Execute `ETL_pipeline.py` to load data and transform dimensions.
    - Run `quality_checks.py` to assess and log data quality.
    - Use `Validations.py` to validate schema and row counts.
5. **Review Logs**:
    - All ETL and validation logs are stored in `logs.txt` for troubleshooting and audit.

---

## Images & Workflow Diagrams

Visual workflow and schema diagrams are provided to guide setup and illustrate architecture.

- **NiFi Fact Table Workflow**  
<img width="1918" height="846" alt="Image" src="https://github.com/user-attachments/assets/800f45cc-ca6c-4a51-a7d2-f27e030a29b7" />

- **Bronze Layer Ingestion**  
<img width="842" height="732" alt="Image" src="https://github.com/user-attachments/assets/2282616d-318d-4689-b652-c2ceae6daf13" />

- **OLTP Schema**
<img width="1410" height="785" alt="Image" src="https://github.com/user-attachments/assets/908495cf-5f5d-4575-a7b6-4a8d29ed82d2" />
 
- **Star Schema**  
<img width="1416" height="797" alt="Image" src="https://github.com/user-attachments/assets/f533104e-9a85-4f69-8100-ff91b2b7fa39" />

---

## License

See [LICENSE](LICENSE) for details.

---

## Author & Credits

Developed by Omar Gamal Hamed.  
For questions, suggestions, or contributions, please open an issue or submit a pull request.

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## References

- [Medallion Architecture](https://databricks.com/glossary/medallion-architecture)
- [Apache NiFi Documentation](https://nifi.apache.org/docs.html)
- [PySpark Documentation](https://spark.apache.org/docs/latest/api/python/)
- [AdventureWorks2022 Sample Database](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16)
