# State Management & CI/CD Pipeline

> This document details the operational mechanics of the infrastructure lifecycle, focusing on state management safety and automated code validation via Continuous Integration (CI).

---

## 1. Remote State Management

To support team collaboration and prevent infrastructure drift, the `.tfstate` files are decoupled from local workstations and managed remotely via Google Cloud Storage (GCS).

* **Backend:** Native `gcs` backend.
* **State Locking:** Automatically enforced by GCS. When an operation starts, Terraform leases a lock, preventing concurrent executions (Race Conditions) from corrupting the cloud state.
* **Isolation:** The state is physically separated by prefixes (`env/dev/` and `env/prod/`) inside the bucket, mirroring the directory structure of the repository.

---

## 2. CI/CD Architecture (GitHub Actions)

Every push or pull request to the `main` branch triggers an automated Continuous Integration pipeline (`terraform-ci.yml`). This pipeline performs static analysis to guarantee code quality and security before any infrastructure changes are applied.

### Pipeline States

1. **`terraform fmt -check`:** Enforces canonical Terraform formatting across all files. If the code is not properly formatted, the pipeline fails, ensuring repository readability.
2. **`terraform init -backend=false`:** Initializes the working directory locally (downloading provider binaries) without attempting to reach the remote GCP bucket, ensuring the CI runs fast and securely without requiring cloud credentials. 
3. **`terraform validate`:** Checks the overall syntax, variable definitions, and module linkages for logical errors.
4. **`tfsec` Security Scanner:** An industry-standard static analysis tool that parses the HCL code to detect potential security misconfigurations (e.g., missing encryption, overly permissive IAM roles, exposed buckets) based on CIS benchmarks.

---

**Built by**: @camillefk  
**Created:** August 2026  
**Last Updated:** August 03, 2026