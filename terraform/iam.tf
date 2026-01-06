resource "google_service_account" "cloudrun_sa" {
  account_id   = var.service_account_name
  display_name = "Cloud Run Kotlin Service Account"
}