resource "google_storage_bucket" "app_bucket" {
  name     = var.bucket_name
  location = var.bucket_location

  # Güvenlik & best practice
  uniform_bucket_level_access = true
  force_destroy               = true # eğitim için OK, prod'da dikkat

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

/*| Ayar                          | Açıklama                        |
| ----------------------------- | ------------------------------- |
| `uniform_bucket_level_access` | IAM ile kontrol (ACL yok)       |
| `force_destroy`               | Bucket boş değilken silinebilir |
| `versioning`                  | Object version tutar            |
| `lifecycle_rule`              | 30 gün sonra objeleri siler     |
*/