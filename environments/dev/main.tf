terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.GCP_PROJECT_ID
  region  = var.GCP_REGION
}

module "data_lake" {
  source      = "../../modules/gcs"
  GCP_PROJECT_ID  = var.GCP_PROJECT_ID
  GCP_REGION      = var.GCP_REGION
  environment = "dev"
}