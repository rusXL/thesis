# ──────────────────────────────────────────────
# VM IPs (for ping testing)
# ──────────────────────────────────────────────

output "g_vm_internal_ip" {
  description = "Internal IP of the GCP VM (ping target from AWS)."
  value       = google_compute_instance.vm_g.network_interface[0].network_ip
}

output "a_vm_internal_ip" {
  description = "Internal IP of the AWS VM (ping target from GCP)."
  value       = aws_instance.vm_a.private_ip
}

# ──────────────────────────────────────────────
# VM public IPs (for SSH access)
# ──────────────────────────────────────────────

output "g_vm_public_ip" {
  description = "Public IP of the GCP VM (SSH access)."
  value       = google_compute_instance.vm_g.network_interface[0].access_config[0].nat_ip
}

output "a_vm_public_ip" {
  description = "Public IP of the AWS VM (SSH access)."
  value       = aws_instance.vm_a.public_ip
}

# ──────────────────────────────────────────────
# VPN connection info
# ──────────────────────────────────────────────

output "a_vpn_connection_0_id" {
  description = "AWS VPN Connection 0 ID (GCP interface 0)."
  value       = aws_vpn_connection.vpn_conn_0.id
}

output "a_vpn_connection_1_id" {
  description = "AWS VPN Connection 1 ID (GCP interface 1)."
  value       = aws_vpn_connection.vpn_conn_1.id
}
