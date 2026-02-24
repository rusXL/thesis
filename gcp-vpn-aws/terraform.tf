terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.20"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
  }

  required_version = ">= 1.5"
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "aws" {
  region = var.aws_region
}
