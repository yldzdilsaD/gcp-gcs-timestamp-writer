output "service_account_email" {
  description = "Cloud Run Service Account Email"
  value       = google_service_account.cloudrun_sa.email
}
output "bucket_name" {
  description = "GCS bucket name"
  value       = google_storage_bucket.app_bucket.name
}