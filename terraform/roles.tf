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
