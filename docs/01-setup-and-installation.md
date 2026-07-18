# Setup & Installation Guide

> This guide outlines the complete step-by-step process to configure your local development workstation and Google Cloud Platform (GCP) environment to deploy this infrastructure.

## 1. Prerequisities Matrix

Ensure the following tools are installed before proceeding:

| Tool | Minimum Version | Verification Command | Purpose |
| :--- | :--- | :--- | :--- |
| **Terraform** | `1.5.0` | `terraform -version` | IaC provisioning engine |
| **Google Cloud SDK** | `400.0.0` | `gcloud --version` | GCP authentication and API communication |
| **Git** | `2.x` | `git --version` | Source code management |

---

## 2. GCP Project Preparation

To allow Terraform to provision resources, specific APIs must be enabled on your target GCP project. Execute the following command in your terminal, replacing `YOUR_GCP_PROJECT_ID` with your actual project ID:

```bash
export GCP_PROJECT_ID="YOUR_GCP_PROJECT_ID"

gcloud services enable \
  storage.googleapis.com \
  bigquery.googleapis.com \
  iam.googleapis.com \
  cloudresourcemanager.googleapis.com \
  --project=$GCP_PROJECT_ID
```

---

## 3. Local Autheticate Setup

We utilize **Application Default Credentials (ADC)** for local Terraform execution. This eliminates the security risk of downloading and storing static `.json` service account keys on your local machine.

### 1. Authenticate via Google Cloud SDK:
```bash
gcloud auth application-default login
```

### 2. Set your default active project:
```bash
gcloud config set project $GCP_PROJECT_ID
```

### 3. Verify the active identity:
```bash
gcloud auth list
```

---

## 4. Initializing the Terraform Workspace

Navigate to your target environment (e.g., `dev`) and initialize the Terraform backend and provider plugins:

```bash
cd environments/dev

# Create your local variable definitions file
cat <<EOF> terraform.tfvars
GCP_PROJECT_ID = "$GCP_PROJECT_ID"
GCP_REGION     = "us-central1"
EOF

# Initialize Terraform workspace
terraform init
```

Once initialized without errors, your local workstation is ready to execute `terraform plan` and `terraform apply`.

---

**Built by**: @camillefk  
**Created:** July 2026  
**Last Updated:** July 17, 2026