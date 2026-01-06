project_id  = "gcp-dummy-483112"
bucket_name = "gcp-dummy-483112-hourly-messages"

region               = "europe-west1"
bucket_location      = "EU"
service_account_name = "cloudrun-kotlin-sa"

github_repo = "yldzdilsaD/gcp-gcs-timestamp-writer"
repo_slug  = "gcs-writer"

image = "europe-west1-docker.pkg.dev/gcp-dummy-483112/gcp-demo/gcs-writer:latest"