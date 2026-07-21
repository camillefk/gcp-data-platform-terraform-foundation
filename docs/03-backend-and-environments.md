# Remote State Management & Environment Isolation

> This document details the architecture implemented to safeguard Terraform's state files and ensure strict physical and logical boundary isolation across deployment lifecycles (`dev` vs `prod`).

---

## 1. The *"Chicken-and-Egg"* Bootstrap Strategy

A fundamental infrastructure mistake is allowing Terraform to manage the remote cloud bucket that stores its own `.tfstate` file. If an automated CI/CD pipeline or engineer executes a `terraform destroy` on the foundational workspace, the state bucket itself would be deleted, leading to irreversible state corruption and tracking loss.

To resolve this, the state storage bucket is deployed as **Bootstrap Infrastructure** via the Google Cloud CLI prior to workspace initialization:

- **Uniform Bucket-Level Access:** Enforced to guarantee IAM-only authentication.
- **Object Versioning:** Enable by default. Every `terraform apply` generates a new immutable versions of the state file. If a state curruption occurs or an accidental race condition causes data drift, administrators can roll back to the previous timestamped state version in GCS.

---

## 2. Remote Backend & State Locking Architecture

By migrating from local workstation storage to a Google Cloud Storage (`gcs`) backend, the engineering workflows achieves enterprise-grade reliability:

- **Single Source of Truth:** Centralizes the state, ensuring all team members and automated GitHub Actions pipelines operate against the exact same infrastructure map.
- **Native State Locking:** GCS natively supports distributed locks. When an execution (`plan`or `apply`) starts, Terraform leases a lock on the `.tfstate` object. Concurrent execution attempts are automatically rejected until the lock is released, completely eliminating race conditions.

---

## 3. Environment Isolation Matrix

To prevent blast-radius spillover from experimental development work into production data pipelines, the project enforces **Directory-Based Workspace Isolation** combined with **State Prefixing**.

### State Prefix Isolation Diagram

```text
[ GCS Remote State Bucket: gs://tf-state-YOUR_PROJECT_ID ]
       │
       ├─── /env/dev/default.tfstate  ──► (Managed by: environments/dev/)
       │
       └─── /env/prod/default.tfstate ──► (Managed by: environments/prod/)
```

### Environment Parameterization (`.tfvars`)

Each environment operates entirely independently by injecting specific variable definitions at runtime using targeted `-var-file` configurations:

| Feature / Behavior | Development (`dev.tfvars`) | Production (`prod.tfvars`) |
| ----- | ----- | ----- |
| **GCS** `force_destroy` | `true` (Allows rapid teardown) | `false` (Prevents accidental data lake deletion) |
| **BigQuery** `delete_contents` | `true` (Allows schema dropping) | `false` (Protects analytical warehouses) |
| **Service Account Identity** | `dev-airflow-orchestrator@...` | `prod-airflow-orchestrator@...` |
| **State Storage Prefix** | `env/dev` | `env/prod` |

By physically separating the state paths and injecting dynamic safety safeguards through HCL ternary logic, the data platform achieves high velocity in development while maintaining zero-trust safety in production.

---

**Built by**: @camillefk  
**Created:** July 2026  
**Last Updated:** July 20, 2026