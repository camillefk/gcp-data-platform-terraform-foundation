resource "google_bigquery_dataset" "datasets" {
    for_each    = toset(var.dataset_names)

    dataset_id  = "${var.environment}_${each.value}"
    project     = var.GCP_PROJECT_ID
    location    = var.GCP_REGION

    delete_contents_on_destroy = var.environment == "dev" ? true : false

    labels = {
        environment = var.environment
        managed_by = "terraform"
    } 
}