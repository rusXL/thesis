# ══════════════════════════════════════════════
# GCP VM
# ══════════════════════════════════════════════

resource "google_compute_instance" "vm_g" {
  name         = "vm-g"
  machine_type = "e2-micro"
  zone         = "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_g.id

    # public IP for SSH access
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}

# ══════════════════════════════════════════════
# AWS VM
# ══════════════════════════════════════════════

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "g-vpn-a-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "vm_a" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.sg_a.id]
  key_name               = aws_key_pair.ssh_key.key_name

  tags = { Name = "vm-a" }
}
