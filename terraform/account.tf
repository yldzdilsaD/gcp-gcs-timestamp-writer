resource "google_service_account" "cloudrun_sa" {
  account_id   = var.service_account_name
  display_name = "Cloud Run Kotlin SA"
}

resource "google_service_account" "github_ci" {
  account_id   = "github-ci-${var.repo_slug}"
  display_name = "GitHub CI"
}