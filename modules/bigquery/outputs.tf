output "GCP_DATASET_IDS" {
    value       = [for d in google_bigquery_dataset.datasets : d.dataset_id]
    description = "List of created BigQuery dataset IDs"
}