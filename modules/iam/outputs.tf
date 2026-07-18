output "airflow_service_account_email" {
  value       = google_service_account.airflow_sa.email
  description = "The email of the dedicated Airflow Service Account"
}