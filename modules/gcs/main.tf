resource "google_storage_bucket" "data_lake_buckets" {
    for_each = toset(var.GCP_BUCKET_NAMES)

    name          = "${var.GCP_PROJECT_ID}-${var.environment}-datalake-${each.value}"
    location      = var.GCP_REGION
    force_destroy = var.environment == "dev" ? true : false

    public_access_prevention    = "enforced"
    uniform_bucket_level_access = true

    dynamic "lifecycle_rule" {
    for_each = each.value == "raw" ? [1] : []
    content {
      condition {
        age = 30 # dias
      }
      action {
        type = "Delete"
      }
    }
  }
}
