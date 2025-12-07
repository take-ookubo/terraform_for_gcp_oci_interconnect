output "vcn_id" {
  description = "VCN OCID"
  value       = oci_core_vcn.vcn.id
}

output "subnet_id" {
  description = "Subnet OCID"
  value       = oci_core_subnet.subnet.id
}

output "drg_id" {
  description = "DRG OCID"
  value       = oci_core_drg.drg.id
}

output "virtual_circuit_id" {
  description = "FastConnect Virtual Circuit OCID（第2段階で作成）"
  value       = length(oci_core_virtual_circuit.virtual_circuit) > 0 ? oci_core_virtual_circuit.virtual_circuit[0].id : null
}
