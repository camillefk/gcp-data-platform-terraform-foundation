variable "GCP_PROJECT_ID" {
  type        = string
  description = "The GCP project ID where the resources will be created"
}

variable "GCP_REGION" {
  type    = string
  default = "us-central1"
}