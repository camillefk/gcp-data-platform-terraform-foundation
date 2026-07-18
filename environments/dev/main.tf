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
  source         = "../../modules/gcs"
  GCP_PROJECT_ID = var.GCP_PROJECT_ID
  GCP_REGION     = var.GCP_REGION
  environment    = "dev"
}

module "data_warehouse" {
  source         = "../../modules/bigquery"
  GCP_PROJECT_ID = var.GCP_PROJECT_ID
  GCP_REGION     = var.GCP_REGION
  environment    = "dev"
}

module "security_iam" {
  source = "../../modules/iam"
  GCP_PROJECT_ID = var.GCP_PROJECT_ID
  environment = "dev"
  GCP_BUCKET_NAMES = module.data_lake.GCP_BUCKET_NAMES
  GCP_DATASET_IDS = module.data_warehouse.GCP_DATASET_IDS
}