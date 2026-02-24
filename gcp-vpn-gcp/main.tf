# Networks (VPC + subnets)
module "vpc1" {
  source                  = "terraform-google-modules/network/google"
  project_id              = var.project_id
  network_name            = "network1"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false

  subnets = [
    {
      subnet_name   = "network1-subnet1"
      subnet_region = "us-central1"
      subnet_ip     = "10.0.1.0/24"
    },
    {
      subnet_name   = "network1-subnet2"
      subnet_region = "us-west1"
      subnet_ip     = "10.0.2.0/24"
    },
  ]
}

module "vpc2" {
  source                  = "terraform-google-modules/network/google"
  project_id              = var.project_id
  network_name            = "network2"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false

  subnets = [
    {
      subnet_name   = "network2-subnet1"
      subnet_region = "us-central1"
      subnet_ip     = "192.168.1.0/24"
    },
    {
      subnet_name   = "network2-subnet2"
      subnet_region = "us-east1"
      subnet_ip     = "192.168.2.0/24"
    },
  ]
}

# HA VPNs (gateway + router + tunnels + BGP)
module "vpn1" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  project_id       = var.project_id
  region           = "us-central1"
  network          = module.vpc1.network_id
  name             = "vpn1"
  router_asn       = 64514
  peer_gcp_gateway = module.vpn2.gateway[0].self_link

  tunnels = {
    remote0 = {
      bgp_peer = {
        address = "169.254.0.2"
        asn     = 64515
      }
      bgp_peer_options = {
        route_priority = 100 # primary
      }
      bgp_session_range     = "169.254.0.1/30"
      vpn_gateway_interface = 0
      shared_secret         = "a secret message"
    }
    remote1 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64515
      }
      bgp_peer_options = {
        route_priority = 200 # standby
      }
      bgp_session_range     = "169.254.1.1/30"
      vpn_gateway_interface = 1
      shared_secret         = "a secret message"
    }
  }
}

module "vpn2" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  project_id       = var.project_id
  region           = "us-central1"
  network          = module.vpc2.network_id
  name             = "vpn2"
  router_asn       = 64515
  peer_gcp_gateway = module.vpn1.gateway[0].self_link

  tunnels = {
    remote0 = {
      bgp_peer = {
        address = "169.254.0.1"
        asn     = 64514
      }
      bgp_peer_options = {
        route_priority = 100 # primary
      }
      bgp_session_range     = "169.254.0.2/30"
      vpn_gateway_interface = 0
      shared_secret         = "a secret message"
    }
    remote1 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64514
      }
      bgp_peer_options = {
        route_priority = 200 # standby
      }
      bgp_session_range     = "169.254.1.2/30"
      vpn_gateway_interface = 1
      shared_secret         = "a secret message"
    }
  }
}

# VMs
resource "google_compute_instance" "vm1" {
  name         = "vm1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

  network_interface {
    subnetwork = module.vpc1.subnets["us-central1/network1-subnet1"].id
  }

  # enable OS Login for SSH access
  metadata = {
    enable-oslogin = "TRUE"
  }
}

resource "google_compute_instance" "vm2" {
  name         = "vm2"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

  network_interface {
    subnetwork = module.vpc2.subnets["us-central1/network2-subnet1"].id
  }

  metadata = {
    enable-oslogin = "TRUE"
  }
}


# Firewall internal (allow ICMP and SSH within each VPC for testing)
resource "google_compute_firewall" "vpc1_allow_internal" {
  name    = "vpc1-allow-internal"
  network = module.vpc1.network_name

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # allow traffic within VPCs
  source_ranges = ["10.0.0.0/16", "192.168.0.0/16"]
}

resource "google_compute_firewall" "vpc2_allow_internal" {
  name    = "vpc2-allow-internal"
  network = module.vpc2.network_name

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["10.0.0.0/16", "192.168.0.0/16"]
}

# Firewall external - allow SSH from IAP
resource "google_compute_firewall" "vpc1_allow_iap" {
  name    = "vpc1-allow-iap-ssh"
  network = module.vpc1.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Google's IAP IP range
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "vpc2_allow_iap" {
  name    = "vpc2-allow-iap-ssh"
  network = module.vpc2.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}
