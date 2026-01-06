resource "google_project_iam_member" "cloudrun_roles" {
  for_each = toset([
    "roles/run.admin",
    "roles/run.invoker",
    "roles/storage.objectAdmin",
    "roles/logging.logWriter"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}
resource "google_project_iam_member" "github_ci_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_ci.email}"
}
resource "google_artifact_registry_repository_iam_member" "github_ci_writer" {
  project    = var.project_id
  location   = var.region
  repository = "gcp-demo"

  role   = "roles/artifactregistry.writer"
  member = "serviceAccount:${google_service_account.github_ci.email}"
}
resource "google_service_account_iam_member" "github_token_creator" {
  service_account_id = google_service_account.github_ci.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "principalSet://iam.googleapis.com/projects/14240076180/locations/global/workloadIdentityPools/github-wif-dev/*"
}

