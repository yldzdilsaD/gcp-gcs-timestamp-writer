locals {
  wif_project_number = data.google_project.current.number
  wif_pool_id        = google_iam_workload_identity_pool.github.workload_identity_pool_id
  github_repo        = var.github_repo

  github_principal = "principalSet://iam.googleapis.com/projects/${local.wif_project_number}/locations/global/workloadIdentityPools/${local.wif_pool_id}/attribute.repository/${local.github_repo}"
}
resource "google_service_account_iam_member" "github_wif_user" {
  service_account_id = google_service_account.github_ci.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.github_principal
}

resource "google_storage_bucket_iam_member" "github_ci_tf_state" {
  bucket = "gcp-dummy-483112-tfstate"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github_ci.email}"
}
resource "google_project_iam_member" "github_ci_project_admin" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.github_ci.email}"
}

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
resource "google_storage_bucket_iam_member" "cloudrun_bucket_writer" {
  bucket = google_storage_bucket.app_bucket.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

resource "google_project_iam_member" "github_ci_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_ci.email}"
}

resource "google_service_account_iam_member" "github_token_creator" {
  service_account_id = google_service_account.github_ci.name
  role               = "roles/iam.serviceAccountTokenCreator"

  member = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/${var.github_repo}"
}
resource "google_project_iam_member" "github_ci_service_usage" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.github_ci.email}"
}

resource "google_project_iam_member" "github_ci_project_viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.github_ci.email}"
}

