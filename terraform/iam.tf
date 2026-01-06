data "google_project" "current" {
  project_id = var.project_id
}

resource "google_service_account" "cloudrun_sa" {
  account_id   = var.service_account_name
  display_name = "Cloud Run Kotlin SA"
}

resource "google_service_account" "github_ci" {
  account_id   = "github-ci-${var.repo_slug}"
  display_name = "GitHub CI"
}

resource "google_service_account_iam_member" "github_wif_binding" {
  service_account_id = google_service_account.github_ci.name
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/${var.github_repo}/attribute.ref/refs/heads/master"
}

resource "google_service_account_iam_member" "github_wif_token_creator" {
  service_account_id = google_service_account.github_ci.name
  role               = "roles/iam.serviceAccountTokenCreator"

  member = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/${var.github_repo}/attribute.ref/refs/heads/master"
}

