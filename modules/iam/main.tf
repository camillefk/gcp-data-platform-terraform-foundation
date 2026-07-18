# 1. Creates a dedicated Service Account for Airflow.
resource "google_service_account" "airflow_sa" {
  account_id   = "${var.environment}-airflow-orchestrator"
  display_name = "Airflow Orchestrator Service Account (${var.environment})"
  project      = var.GCP_PROJECT_ID
}

# 2. Project-level permission: Only allows running BigQuery jobs and queries (does not grant access to the data)
resource "google_project_iam_member" "bq_job_user" {
  project = var.GCP_PROJECT_ID
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.airflow_sa.email}"
}

# 3. Granular GCS permissions: Read and write access ONLY to the Data Lake buckets
resource "google_storage_bucket_iam_member" "gcs_access" {
  for_each = toset(var.GCP_BUCKET_NAMES)
  bucket   = each.value
  role     = "roles/storage.objectAdmin"
  member   = "serviceAccount:${google_service_account.airflow_sa.email}"
}

# 4. Granular BigQuery permissions: Edit access ONLY to the created datasets.
resource "google_bigquery_dataset_iam_member" "bq_access" {
  for_each   = toset(var.GCP_DATASET_IDS)
  dataset_id = each.value
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.airflow_sa.email}"
  project    = var.GCP_PROJECT_ID
}