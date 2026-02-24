# ──────────────────────────────────────────────
# Cloud Providers
# ──────────────────────────────────────────────

variable "gcp_project_id" {
  description = "GCP project ID."
  type        = string
}

variable "gcp_region" {
  description = "GCP region for VPC and resources."
  type        = string
  default     = "us-central1"
}

variable "aws_region" {
  description = "AWS region for VPC and resources."
  type        = string
  default     = "us-east-1"
}

# ──────────────────────────────────────────────
# Network CIDRs
# ──────────────────────────────────────────────

variable "gcp_subnet_cidr" {
  description = "CIDR for the GCP subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "aws_vpc_cidr" {
  description = "CIDR for the AWS VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "aws_subnet_cidr" {
  description = "CIDR for the AWS subnet."
  type        = string
  default     = "10.1.1.0/24"
}

# ──────────────────────────────────────────────
# VPN
# ──────────────────────────────────────────────

variable "gcp_bgp_asn" {
  description = "BGP ASN for the GCP Cloud Router."
  type        = number
  default     = 64514
}

variable "aws_bgp_asn" {
  description = "BGP ASN for the AWS VPN Gateway."
  type        = number
  default     = 64512
}

variable "vpn_psk" {
  description = "Pre-shared key for all IPsec VPN tunnels. Set in terraform.tfvars."
  type        = string
  sensitive   = true
}

# ──────────────────────────────────────────────
# Compute / SSH
# ──────────────────────────────────────────────

variable "ssh_public_key" {
  description = "SSH public key for VM access on both clouds. Set in terraform.tfvars."
  type        = string
}

variable "ssh_user" {
  description = "SSH username for GCP VM metadata."
  type        = string
  default     = "admin"
}
