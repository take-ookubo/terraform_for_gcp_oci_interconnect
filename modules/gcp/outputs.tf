output "vpc_id" {
  description = "VPC ID"
  value       = google_compute_network.vpc.id
}

output "vpc_self_link" {
  description = "VPC Self Link"
  value       = google_compute_network.vpc.self_link
}

output "subnet_id" {
  description = "Subnet ID"
  value       = google_compute_subnetwork.subnet.id
}

output "router_id" {
  description = "Cloud Router ID"
  value       = google_compute_router.router.id
}

output "interconnect_attachment_pairing_key" {
  description = "Partner Interconnect ペアリングキー"
  value       = google_compute_interconnect_attachment.partner_interconnect.pairing_key
}
