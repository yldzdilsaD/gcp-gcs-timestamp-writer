resource "google_cloud_run_v2_job" "gcs_writer_job" {
  name     = "gcs-writer-job"
  location = var.region
  project  = var.project_id

  lifecycle {
    ignore_changes = [
      template[0].template[0].containers[0].image
    ]
  }

  template {
    template {
      service_account = google_service_account.cloudrun_sa.email

      containers {
        image = var.image

        env {
          name  = "BUCKET_NAME"
          value = var.bucket_name
        }
      }
    }
  }

  depends_on = [
    google_project_service.cloud_run_api,
    google_project_service.artifact_registry_api
  ]
}
