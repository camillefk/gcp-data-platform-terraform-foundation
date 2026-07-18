# Data Warehouse Architecture & IAM Least-Privilege Security

> This document outlines the design principles behind the BigQuery analytical layer and the Identity and Access Management (IAM) security model implemented to support external data orchestrators such as Apache Airflow or Google Cloud Composer.

## 1. BigQuery Data Warehouse Modeling

The BigQuery processing layer is structured to separate ingestion staging workflows from production-ready analytical tables.

- **`staging` Dataset:** Acts as the landing area for data loaded directly from the GCS Medallion `raw` or `staging` buckets. Tables here are optimized for high-throughput batch insertions and transient transformations.
- **`prod` Dataset:** Houses curated, structured analytical models ready for downstream BI consumption and machine learning workloads.
- **Environment Isolation:** All datasets are dynamically prefixed by the environment (e.g., `dev_staging`, `dev_prod`) to prevent data contamination across deployment lifecycles.
- **Data Safety Controls:** In production environments (`prod`), Terraform's `delete_contents_on_destroy` parameter is strictly set to `false`, acting as an automated safeguard against accidental data destruction during infrastructure updates.

---

## 2. Least-Privilege Security Architecture (IAM)

A common security vulnerability in data engineering pipelines is assigning overly permissive roles (e.g., `Project Editor` or `BigQuery Admin`) to pipeline execution identities. 

This repository enforces strict **Least-Privilege IAM Access** by provisioning a dedicated Service Account (`airflow-orchestrator`) and binding roles exclusively at the resource level rather than the project level.

### Permission Binding Matrix

| Resource Scope | Assigned Role | Justification |
| :--- | :--- | :--- |
| **GCP Project Level** | `roles/bigquery.jobUser` | Allows the orchestrator to execute BigQuery load and query jobs. It grants *no access* to read or write table data by itself. |
| **GCS Data Lake Buckets** *(Resource Level)* | `roles/storage.objectAdmin` | Granted strictly on the specific `raw`, `staging`, and `curated` buckets. Allows reading source files and writing processed files without granting administrative control over the buckets themselves. |
| **BigQuery Datasets** *(Resource Level)* | `roles/bigquery.dataEditor` | Granted strictly on the created datasets (`staging`, `prod`). Allows creating, reading, updating, and deleting tables within those datasets without exposing other project datasets. |

### Security Flow Diagram

```text
[ Apache Airflow Pipeline ]
             │
             ▼ (Authenticates as)
[ SA: dev-airflow-orchestrator@YOUR_PROJECT.iam.gserviceaccount.com ]
             │
             ├─── (Project Scope) ──────► roles/bigquery.jobUser (Can execute compute jobs)
             │
             ├─── (GCS Bucket Scope) ───► roles/storage.objectAdmin (Access only to Medallion Buckets)
             │
             └─── (BQ Dataset Scope) ───► roles/bigquery.dataEditor (Access only to Staging/Prod Datasets)
```

By decoupling compute permissions (jobUser) from storage permissions (objectAdmin / dataEditor) and scoping them to exact resource ARNs, the data platform minimizes the blast radius of any potential credential compromise.

---

**Built by**: @camillefk  
**Created:** July 2026  
**Last Updated:** July 17, 2026