variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "bucket_name" {
  type = string
}

variable "bucket_location" {
  type    = string
  default = "EU"
}

variable "service_account_name" {
  type    = string
  default = "cloudrun-kotlin-sa"
}

variable "image" {
  type = string
}

variable "github_repo" {
  description = "owner/repo"
  type        = string
}

variable "repo_slug" {
  type = string
}
