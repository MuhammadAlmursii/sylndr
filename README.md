 # 🚀 Sylndr Data Pipeline: BigQuery 📈 → dbt 🛠️ → Superset 📊 → Airflow 🌬️

**A robust, end-to-end data pipeline architecture leveraging Google BigQuery, dbt for transformation, Apache Superset for visualization, and Apache Airflow for orchestration.**

![Sylndr Data Pipeline Architecture](![images](![image](https://github.com/user-attachments/assets/dc247ec7-a280-46ca-8f33-e5f30b71b018)
)
)
)

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
```

## 🎯 Key Features

- **Automated Data Ingestion**: Streamline data from various sources into BigQuery.
- **Transformative Workflows**: Utilize dbt to clean, transform, and model data.
- **Interactive Data Visualization**: Create dynamic and insightful dashboards with Superset.
- **Robust Orchestration**: Schedule and monitor pipeline executions with Airflow.

## 🚀 Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/MuhammadAlmursii/sylndr.git
   cd sylndr
   ```

2. **Set Up Environment Variables**:
   Create a `.env` file to store sensitive information and configurations.

3. **Initialize and Run Services**:
   - **dbt**:
     ```bash
     cd dbt
     dbt init
     ```
   - **Superset**:
     ```bash
     cd superset
     docker-compose up -d
     ```
   - **Airflow**:
     ```bash
     cd airflow
     airflow db init
     airflow webserver -p 8080
     airflow scheduler &

## 📊 Visualizing the Stack

![Sylndr Data Pipeline Architecture Diagram](https://i.imgur.com/8Zf1W0C.png)

## 📝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

**Empower your data journey with Sylndr's comprehensive data pipeline solution!**
