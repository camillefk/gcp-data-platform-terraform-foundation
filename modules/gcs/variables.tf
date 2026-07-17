variable "GCP_PROJECT_ID" {
    type        = string
    description = "The GCP project ID where the resources will be created"
}

variable "GCP_REGION" {
    type        = string
    description = "The region where the buckets will be created"
    default     = "us-central1"
}

variable "environment" {
    type        = string
    description = "The deployment environment (e.g., dev, staging, prod)"
}

variable "GCP_BUCKET_NAMES" {
    type        = list(string)
    description = "A list of suffixes for the Data Lake buckets (e.g., raw, staging, curated)"
    default     = ["raw", "staging", "curated"]
}