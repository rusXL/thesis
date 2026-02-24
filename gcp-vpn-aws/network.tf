# ══════════════════════════════════════════════
# GCP Network
# ══════════════════════════════════════════════

resource "google_compute_network" "vpc_g" {
  name                    = "vpc-g"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "subnet_g" {
  name          = "subnet-g"
  network       = google_compute_network.vpc_g.id
  region        = var.gcp_region
  ip_cidr_range = var.gcp_subnet_cidr
}

# ══════════════════════════════════════════════
# AWS Network
# ══════════════════════════════════════════════

resource "aws_vpc" "vpc_a" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "vpc-a" }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = var.aws_subnet_cidr
  map_public_ip_on_launch = true

  tags = { Name = "subnet-a" }
}

resource "aws_internet_gateway" "igw_a" {
  vpc_id = aws_vpc.vpc_a.id

  tags = { Name = "igw-a" }
}

resource "aws_route_table" "rt_a" {
  vpc_id = aws_vpc.vpc_a.id

  # default route to internet (SSH access)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_a.id
  }

  tags = { Name = "rt-a" }
}

resource "aws_route_table_association" "rta_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt_a.id
}
