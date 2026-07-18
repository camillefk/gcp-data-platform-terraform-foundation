variable "GCP_PROJECT_ID" {
  type        = string
  description = "GCP Project ID"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "GCP_BUCKET_NAMES" {
  type        = list(string)
  description = "List of GCS bucket names the Service Account needs access to"
}

variable "GCP_DATASET_IDS" {
  type        = list(string)
  description = "List of BigQuery dataset IDs the Service Account needs access to"
}