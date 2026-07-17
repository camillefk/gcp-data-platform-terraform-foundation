output "GCP_BUCKET_NAMES" {
  value       = [for b in google_storage_bucket.data_lake_buckets : b.name]
  description = "A list of all generated bucket names."
}

output "GCP_BUCKET_URLS" {
  value       = [for b in google_storage_bucket.data_lake_buckets : b.url]
  description = "A list of gs:// URLs for all created buckets."
}