output "airflow_service_account" {
  value       = module.security_iam.airflow_service_account_email
  description = "Service Account email to be configured in Apache Airflow / Cloud Composer"
}