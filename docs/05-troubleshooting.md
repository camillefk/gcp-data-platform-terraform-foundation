# Trobleshooting & Debugging Guide

> This guide provides rapid resolution workflows for the most common errors encountered during the deployment of this GCP data platform.

---

## 1. Error: `oauth2: "invalid_grant" "reauth related error"`

**Symptom:**  
Terraform fails during `init`, `plan`, or `apply` with an authentication-related error pointing to an invalid token.  
**Root Cause:**  
Your local Google Cloud CLI session (Application Default Credentials) has expired.  
**Resolution:**  
Re-authenticate your terminal session:
```bash
gcloud auth application-default login
gcloud config set project YOUR_GCP_PROJECT_ID
```

## 2. Error: `Error acquiring the state lock`

**Symptom:**  
Terraform is blocked from running, stating that the state is locked by another process.  
**Root Cause:**
Another team member is currently running an apply, or a previous execution crashed/timed out before releasing the GCS lock.  
**Resolution:**  
1. Wait a few minutes to ensure no active pipelines are running.
2. Identify the Lock ID from the error message.
3. Force unlock the state (Use with extreme caution!):
```bash
terraform force-unlock <LOCK_ID>
```

## 3. Error: `403 Permission Denied` on GCS or BigQuery

**Symptom:**  
Terraform fails to create or modify resources, citing insufficient permissions.  
**Root Cause:**  
The active identity lacks the necessary IAM roles in the GCP project.  
**Resolution:**  
Ensure your user account has at least the following roles at the project level:

* `roles/storage.admin`
* `roles/bigquery.admin`
* `roles/iam.serviceAccountAdmin`
* `roles/iam.securityAdmin` (To create and bind IAM policies)

---

**Built by**: @camillefk  
**Created:** August 2026  
**Last Updated:** August 03, 2026