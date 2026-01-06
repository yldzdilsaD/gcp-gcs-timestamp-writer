resource "google_project_service" "cloud_build_api" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "artifact_registry_api" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
}
