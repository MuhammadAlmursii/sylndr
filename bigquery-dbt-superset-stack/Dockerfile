# Use the latest dbt base image
FROM fishtownanalytics/dbt:1.0.0

# Upgrade pip and install required dependencies for BigQuery
RUN pip install --upgrade pip \
    && pip install dbt-bigquery google-cloud-bigquery google-cloud-storage
