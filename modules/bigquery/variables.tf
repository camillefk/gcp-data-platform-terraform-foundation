variable "GCP_PROJECT_ID" {
    type        = string
    description = "GCP Project ID"
}

variable "GCP_REGION" {
    type        = string
    description = "GCP region for dataset locality"
}

variable "environment" {
    type        = string
    description = "Deployment environment (dev, prod)"
}

variable "dataset_names" {
    type        = list(string)
    description = "List os dataset names to create (e.g., staging, prod)"
    default     = ["staging", "prod"]
}