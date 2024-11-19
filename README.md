# 🚀 Sylndr Data Pipeline: BigQuery 📈 → dbt 🛠️ → Superset 📊 → Airflow 🌬️

**A robust, end-to-end data pipeline architecture leveraging Google BigQuery, dbt for transformation, Apache Superset for visualization, and Apache Airflow for orchestration.**

![Sylndr Data Pipeline Architecture](https://drive.google.com/uc?id=1GNTZ0H0MUzJd2RVWHEFvqfZVYxuOCgsp)

## 📋 Overview

The Sylndr Data Pipeline is designed to efficiently manage, transform, visualize, and orchestrate data workflows. This stack integrates:

- **Google BigQuery** as the primary data warehouse.
- **dbt (data build tool)** for data transformation and modeling.
- **Apache Superset** for interactive data exploration and visualization.
- **Apache Airflow** for workflow automation and orchestration.

## 🛠️ Technologies Used

- **Google BigQuery**: For scalable, serverless data warehousing.
- **dbt**: For transforming and modeling data.
- **Apache Superset**: For powerful data visualization and exploration.
- **Apache Airflow**: For orchestrating and scheduling data pipelines.

## 📦 Repository Structure

```plaintext
sylndr/
│
├── dbt/                # dbt models and configurations
│   ├── models/
│   ├── tests/
│   └── profiles.yml
│
├── superset/           # Superset configurations and dashboards
│   ├── docker-compose.yml
│   ├── superset_config.py
│   └── dashboards/
│
├── airflow/            # Airflow DAGs and plugins
│   ├── dags/
│   ├── plugins/
│   └── requirements.txt
│
└── README.md           # This document

🎯 Key Features
Automated Data Ingestion: Streamline data from various sources into BigQuery.
Transformative Workflows: Utilize dbt to clean, transform, and model data.
Interactive Data Visualization: Create dynamic and insightful dashboards with Superset.
Robust Orchestration: Schedule and monitor pipeline executions with Airflow.

🚀 Getting Started
Clone the Repository:

git clone https://github.com/MuhammadAlmursii/sylndr.git
cd sylndr
