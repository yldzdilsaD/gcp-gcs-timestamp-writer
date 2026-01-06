variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west1"
}

variable "service_account_name" {
  description = "Cloud Run service account name"
  type        = string
  default     = "cloudrun-kotlin-sa"
}
variable "bucket_name" {
  description = "GCS bucket name (globally unique)"
  type        = string
}

variable "bucket_location" {
  description = "Bucket location"
  type        = string
  default     = "EU"
}
variable "image" {
  description = "Docker image for Cloud Run Job"
  type        = string
}


