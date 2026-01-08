resource "google_storage_bucket" "app_bucket" {
  name     = var.bucket_name
  location = var.bucket_location

  uniform_bucket_level_access = true
  force_destroy               = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = 30
    }
  }
}