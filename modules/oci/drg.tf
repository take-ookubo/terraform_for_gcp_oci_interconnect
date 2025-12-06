resource "oci_core_drg" "drg" {
  compartment_id = var.compartment_id
  display_name   = "${var.vcn_name}-drg"
}

resource "oci_core_drg_attachment" "drg_attachment" {
  drg_id       = oci_core_drg.drg.id
  display_name = "${var.vcn_name}-drg-attachment"

  network_details {
    id   = oci_core_vcn.vcn.id
    type = "VCN"
  }
}
