# GCP Data Platform Foundation - Terraform IaC

> A production-grade, modular Infrastructure as Code (IaC) project built with **Terraform (HCL)** to provision a secure, multi-environment data analytics foundation on Google Cloud Platform (GCP).

This repository serves as the core infrastructure layer designed to support robust enterprise data pipelines-such as event-driven orchestration workflows, data lakes, and analytical data warehouses-enforcing strict isolation, least-privilege IAM, and cost-optimized lifecycle management.

## Architecture Overview

The infrastruture follows a modular design pattern, allowing seamless provisioning across distinct environments (`dev`, `staging`, `prod`) without code duplication.

- **Storage Layer (GCS):** Implements a Medallion architecture Data Lake (`raw`, `staging`, `curated`) with automated lifecycle rules to minimize storage costs and Uniform Bucket-Level Access for strict security.
- **Processing & Warehouse Layer (BigQuery):** Provisions isolated datasets formatted for enterprise analytics and staging workflows *(In Progress)*.
- **Security & Governance (IAM):** Enforces the principle of least privilege using dedicated Service Accounts for external orchestrators (e.g., Apache Airflow / Cloud Composer) *(In Progress)*.

---

## Prerequisites

Before executing the Terraform scripts, ensure your local development environment meets the following requirements:

- **Terraform:** Version `>= 1.5.0` ([Installation Guide](https://developer.hashicorp.com/terraform/install))
- **Google Cloud SDK (gcloud CLI):** Installed and authenticated ([Installation Guide](https://cloud.google.com/sdk/docs/install))
- **GCP Project:** An active Google Cloud Project with billing enabled.
- **IAM Permissions:** The executing identity must have sufficient roles (e.g., `Editor` or specific `Storage/BigQuery Admin` roles) to create IAM policies, GCS buckets, and BigQuery datasets.

> **For a comprehensive, step-by-step environment configuration guide, refer to our [Detailed Setup & Installation Guide](docs/01-setup-and-installation.md).**

---

## Quick Start & Execution

The project is structured by environments. To deploy the infrastructure to your target environment (e.g., `dev`), follow this standard Terraform workflow:

### 1. Authenticate with Google Cloud
```bash
gcloud auth application-default login
```

### 2. Navigate to the Environment Workspace
```bash
cd environments/dev
```

### 3. Initialize the Working Directory
Downloads required providers and initializes the backend:
```bash
terraform init
```

### 4. Review the Execution Plan
Always preview changes before applying. Ensure your `terraform.tfvars` contains your `GCP_PROJECT_ID` and `GCP_REGION`
```bash
terraform plan
```

### 5. Provision the Infrastructure
Apply the configuration to create the cloud resources:
```bash
terraform apply
```

---

## Documentation Index
For in-depth architectural decisions, security standards, and operational guidelines, explore the `docs/` directory:

| Document | Description |
| ----- | ----- |
| 01. Setup & Installation | Step-by-step prerequisite installation, CLI auth, and GCP project prep. |
| 02. Data Lake Architecture | GCS Medallion design, lifecycle rules, and storage security enforcement. |
| 03. Warehouse & IAM Security | BigQuery dataset modeling and least-privilege service account matrix. |
| 04. State Management & CI/CD | Remote backend configuration, environment isolation, and GitHub Actions pipelines. |
| 05. Troubleshooting Guide | Detailed debugging workflows and solutions for common deployment errors. |

---

## Quick Debugging Tips
If you encounter issues during `terraform plan` or `terraform apply`, check these common culprits first:

- **403 Permission Denied:** Verify that your local ADC (Application Default Credentials) identity has the necessary GCP IAM roles:
```bash
gcloud auth application-default print-access-token
```

- **APIs Not Enabled:** Ensure the required GCP APIs (Cloud Storage, BigQuery, IAM) are enabled in your project:
```bash
gcloud services enable storage.googleapis.com bigquery.googleapis.com iam.googleapis.com --project=YOUR_GCP_PROJECT_ID
```

- **State Lock Errors**: If a previous execution crashed, the state might remain locked. Verify your remote state bucket status before forcing an unlock.

**For deeper root-cause analysis and resolution commands, check the Troubleshooting & Debugging Guide.**

*Built with professional engineering standards for scalable GCP orchestration.*

---

**Built by**: @camillefk  
**Created:** July 2026  
**Last Updated:** July 16, 2026