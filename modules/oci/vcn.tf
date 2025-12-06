resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr]
  display_name   = var.vcn_name
  dns_label      = replace(var.vcn_name, "-", "")
}

resource "oci_core_subnet" "subnet" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  cidr_block     = var.vcn_cidr
  display_name   = "${var.vcn_name}-subnet"
  dns_label      = "subnet"

  route_table_id    = oci_core_route_table.route_table.id
  security_list_ids = [oci_core_security_list.security_list.id]
}

resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-rt"

  route_rules {
    network_entity_id = oci_core_drg.drg.id
    destination       = "10.0.0.0/24"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-sl"

  ingress_security_rules {
    protocol = "all"
    source   = "10.0.0.0/24"
  }

  ingress_security_rules {
    protocol = "all"
    source   = var.vcn_cidr
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}
