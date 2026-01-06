output "service_account_email" {
  description = "Cloud Run Service Account Email"
  value       = google_service_account.cloudrun_sa.email
}
output "bucket_name" {
  description = "GCS bucket name"
  value       = google_storage_bucket.app_bucket.name
}
output "container_image" {
  description = "Docker image used by Cloud Run Job"
  value       = "europe-west1-docker.pkg.dev/${var.project_id}/gcp-demo/gcs-writer:latest"
}
output "cloud_run_job_name" {
  description = "Cloud Run Job name"
  value       = google_cloud_run_v2_job.gcs_writer_job.name
}

