output "service_account_email" {
  description = "Cloud Run Service Account Email"
  value       = google_service_account.cloudrun_sa.email
}
output "bucket_name" {
  description = "GCS bucket name"
  value       = google_storage_bucket.app_bucket.name
}
output "container_image" {
  value = google_cloud_run_v2_job.gcs_writer_job.template[0].template[0].containers[0].image
}
output "cloud_run_job_name" {
  description = "Cloud Run Job name"
  value       = google_cloud_run_v2_job.gcs_writer_job.name
}

