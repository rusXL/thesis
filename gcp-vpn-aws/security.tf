# ══════════════════════════════════════════════
# GCP Firewall Rules
# ══════════════════════════════════════════════

resource "google_compute_firewall" "g_allow_internal" {
  name    = "g-allow-internal"
  network = google_compute_network.vpc_g.name

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # allow traffic within GCP subnet and from AWS VPC
  source_ranges = [var.gcp_subnet_cidr, var.aws_vpc_cidr]
}

resource "google_compute_firewall" "g_allow_ssh" {
  name    = "g-allow-ssh"
  network = google_compute_network.vpc_g.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # allow SSH from anywhere (consistent with AWS)
  source_ranges = ["0.0.0.0/0"]
}

# ══════════════════════════════════════════════
# AWS Security Group
# ══════════════════════════════════════════════

resource "aws_security_group" "sg_a" {
  name        = "a-sg"
  description = "Allow ICMP + SSH for VPN testing"
  vpc_id      = aws_vpc.vpc_a.id

  tags = { Name = "a-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "a_allow_icmp_g" {
  security_group_id = aws_security_group.sg_a.id
  description       = "ICMP from GCP subnet"
  cidr_ipv4         = var.gcp_subnet_cidr
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
}

resource "aws_vpc_security_group_ingress_rule" "a_allow_icmp_internal" {
  security_group_id = aws_security_group.sg_a.id
  description       = "ICMP from AWS VPC"
  cidr_ipv4         = var.aws_vpc_cidr
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
}

resource "aws_vpc_security_group_ingress_rule" "a_allow_ssh" {
  security_group_id = aws_security_group.sg_a.id
  description       = "SSH from anywhere"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "a_allow_all_out" {
  security_group_id = aws_security_group.sg_a.id
  description       = "All outbound"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
