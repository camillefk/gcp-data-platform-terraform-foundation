terraform {
  required_version = ">= 1.5.0"

  backend "gcs" {
    bucket = "tf-state-peppy-coda-483817-b1"
    prefix = "env/prod"
  }
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
  environment    = "prod"
}

module "data_warehouse" {
  source         = "../../modules/bigquery"
  GCP_PROJECT_ID = var.GCP_PROJECT_ID
  GCP_REGION     = var.GCP_REGION
  environment    = "prod"
}

module "security_iam" {
  source = "../../modules/iam"
  GCP_PROJECT_ID = var.GCP_PROJECT_ID
  environment = "prod"
  GCP_BUCKET_NAMES = module.data_lake.GCP_BUCKET_NAMES
  GCP_DATASET_IDS = module.data_warehouse.GCP_DATASET_IDS
}