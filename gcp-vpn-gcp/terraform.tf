terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.20"
    }
  }

  required_version = ">= 1.14"
}

provider "google" {
  project = var.project_id
  region  = "us-east1"
  zone    = "us-east1-b"
}
