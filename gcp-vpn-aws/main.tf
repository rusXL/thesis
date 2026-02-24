# Resources are defined in separate files:
#   network.tf  — GCP VPC + AWS VPC, subnets, gateways
#   vpn.tf      — HA VPN, Cloud Router, VGW, CGWs, tunnels, BGP
#   compute.tf  — VMs (GCP e2-micro + AWS t3.micro)
#   security.tf — GCP firewall rules + AWS security group
#   outputs.tf  — VM IPs, VPN connection IDs
