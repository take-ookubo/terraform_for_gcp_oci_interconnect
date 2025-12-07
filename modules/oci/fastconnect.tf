# ペアリングキーが設定されている場合のみ FastConnect プロバイダー情報を取得
data "oci_core_fast_connect_provider_services" "provider_services" {
  count          = var.gcp_pairing_key != "" ? 1 : 0
  compartment_id = var.compartment_id

  filter {
    name   = "provider_name"
    values = [var.fastconnect_provider]
  }
}

# ペアリングキーが設定されている場合のみ Virtual Circuit を作成（第2段階）
resource "oci_core_virtual_circuit" "virtual_circuit" {
  count          = var.gcp_pairing_key != "" ? 1 : 0
  compartment_id = var.compartment_id
  display_name   = "${var.vcn_name}-virtual-circuit"

  type                      = "PRIVATE"
  bandwidth_shape_name      = var.fastconnect_port_speed
  gateway_id                = oci_core_drg.drg.id
  provider_service_id       = data.oci_core_fast_connect_provider_services.provider_services[0].fast_connect_provider_services[0].id
  provider_service_key_name = var.gcp_pairing_key
}
