output "vm1_internal_ip" {
  description = "Internal IP of test-vm1 (network1)"
  value       = google_compute_instance.vm1.network_interface[0].network_ip
}

output "vm2_internal_ip" {
  description = "Internal IP of test-vm2 (network2)"
  value       = google_compute_instance.vm2.network_interface[0].network_ip
}
