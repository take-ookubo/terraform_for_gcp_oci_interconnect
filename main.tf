# =============================================================================
# GCP Module
# =============================================================================

module "gcp" {
  source = "./modules/gcp"

  project_id   = var.gcp_project_id
  region       = var.gcp_region
  vpc_name     = var.gcp_vpc_name
  subnet_cidr  = var.gcp_subnet_cidr
  router_asn   = var.gcp_router_asn
  bandwidth    = var.interconnect_bandwidth
  edge_availability_domain = var.partner_interconnect_edge_availability_domain
}

# =============================================================================
# OCI Module
# =============================================================================

module "oci" {
  source = "./modules/oci"

  compartment_id           = var.oci_compartment_id
  region                   = var.oci_region
  vcn_cidr                 = var.oci_vcn_cidr
  vcn_name                 = var.oci_vcn_name
  fastconnect_provider     = var.fastconnect_provider_name
  fastconnect_port_speed   = var.fastconnect_port_speed_shape
}
