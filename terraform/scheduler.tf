resource "google_cloud_scheduler_job" "hourly_gcs_writer" {
  name     = "hourly-gcs-writer"
  project  = var.project_id
  region   = var.region
  schedule = "0 * * * *" # her saat başı
  time_zone = "Europe/Istanbul"

  http_target {
    http_method = "POST"
    uri = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${google_cloud_run_v2_job.gcs_writer_job.name}:run"

    oauth_token {
      service_account_email = google_service_account.cloudrun_sa.email
    }

    headers = {
      "Content-Type" = "application/json"
    }
  }
  depends_on = [
    google_project_service.cloud_scheduler_api,
    google_project_service.cloud_run_api,
    google_cloud_run_v2_job.gcs_writer_job
  ]
}
