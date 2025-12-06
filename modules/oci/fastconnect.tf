data "oci_core_fast_connect_provider_services" "provider_services" {
  compartment_id = var.compartment_id

  filter {
    name   = "provider_name"
    values = [var.fastconnect_provider]
  }
}

resource "oci_core_virtual_circuit" "virtual_circuit" {
  compartment_id = var.compartment_id
  display_name   = "${var.vcn_name}-virtual-circuit"

  type                           = "PRIVATE"
  bandwidth_shape_name           = var.fastconnect_port_speed
  gateway_id                     = oci_core_drg.drg.id
  provider_service_id            = data.oci_core_fast_connect_provider_services.provider_services.fast_connect_provider_services[0].id
  customer_asn                   = 31898
  cross_connect_mappings {
    customer_bgp_peering_ip = "169.254.0.2/30"
    oracle_bgp_peering_ip   = "169.254.0.1/30"
  }
}
