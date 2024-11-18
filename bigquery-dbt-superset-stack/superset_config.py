# superset_config.py
# SECRET_KEY = 'k5gOK2dhMTdOqGxwzXJaRk0tAPTmegh4rmfAIoOWHbGDKovkJJtok4DB'

from superset.config import *  # Import the default settings

# BigQuery connection configuration
SQLALCHEMY_DATABASE_URI = 'bigquery://scenic-style-421412/sylndr_task'

# Replace <your-gcp-project-id> with your Google Cloud project ID.
# Replace <your-dataset> with the dataset name in BigQuery you want to query.

# Optionally, specify the path to your service account key JSON file for authentication.
# This assumes that GOOGLE_APPLICATION_CREDENTIALS is set up properly.
GOOGLE_APPLICATION_CREDENTIALS = "C:/Users/mohamed.almursi/.dbt/keyfile.json"
