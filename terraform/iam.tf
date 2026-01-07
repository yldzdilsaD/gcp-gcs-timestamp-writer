resource "google_service_account" "cloudrun_sa" {
  account_id   = var.service_account_name
  display_name = "Cloud Run Kotlin SA"
}

resource "google_service_account" "github_ci" {
  account_id   = "github-ci-${var.repo_slug}"
  display_name = "GitHub CI"
}

locals {
  github_principal = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/${var.github_repo}"
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
