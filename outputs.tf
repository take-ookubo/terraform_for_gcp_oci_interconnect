# =============================================================================
# GCP Outputs
# =============================================================================

output "gcp_vpc_id" {
  description = "GCP VPC ID"
  value       = module.gcp.vpc_id
}

output "gcp_vpc_self_link" {
  description = "GCP VPC Self Link"
  value       = module.gcp.vpc_self_link
}

output "gcp_subnet_id" {
  description = "GCP Subnet ID"
  value       = module.gcp.subnet_id
}

output "gcp_router_id" {
  description = "GCP Cloud Router ID"
  value       = module.gcp.router_id
}

output "gcp_interconnect_attachment_pairing_key" {
  description = "GCP Partner Interconnect ペアリングキー"
  value       = module.gcp.interconnect_attachment_pairing_key
}

# =============================================================================
# OCI Outputs
# =============================================================================

output "oci_vcn_id" {
  description = "OCI VCN OCID"
  value       = module.oci.vcn_id
}

output "oci_subnet_id" {
  description = "OCI Subnet OCID"
  value       = module.oci.subnet_id
}

output "oci_drg_id" {
  description = "OCI DRG OCID"
  value       = module.oci.drg_id
}

output "oci_virtual_circuit_id" {
  description = "OCI FastConnect Virtual Circuit OCID"
  value       = module.oci.virtual_circuit_id
}
