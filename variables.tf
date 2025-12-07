# =============================================================================
# GCP Variables
# =============================================================================

variable "gcp_project_id" {
  description = "GCP プロジェクト ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP リージョン"
  type        = string
  default     = "asia-northeast1"
}

variable "gcp_vpc_name" {
  description = "GCP VPC 名"
  type        = string
  default     = "gcp-oci-vpc"
}

variable "gcp_subnet_cidr" {
  description = "GCP サブネット CIDR"
  type        = string
  default     = "10.0.0.0/24"
}

variable "gcp_router_asn" {
  description = "GCP Cloud Router の BGP ASN"
  type        = number
  default     = 16550
}

# =============================================================================
# OCI Variables
# =============================================================================

variable "oci_tenancy_ocid" {
  description = "OCI テナンシー OCID"
  type        = string
}

variable "oci_user_ocid" {
  description = "OCI ユーザー OCID"
  type        = string
}

variable "oci_fingerprint" {
  description = "OCI API キーのフィンガープリント"
  type        = string
}

variable "oci_private_key_path" {
  description = "OCI API プライベートキーのパス"
  type        = string
}

variable "oci_region" {
  description = "OCI リージョン"
  type        = string
  default     = "ap-tokyo-1"
}

variable "oci_compartment_id" {
  description = "OCI コンパートメント OCID"
  type        = string
}

variable "oci_vcn_cidr" {
  description = "OCI VCN CIDR"
  type        = string
  default     = "192.168.0.0/24"
}

variable "oci_vcn_name" {
  description = "OCI VCN 名"
  type        = string
  default     = "default"
}

# =============================================================================
# Interconnect Variables
# =============================================================================

variable "interconnect_bandwidth" {
  description = "Interconnect 帯域幅 (例: BPS_1G, BPS_10G)"
  type        = string
  default     = "BPS_1G"
}

variable "partner_interconnect_edge_availability_domain" {
  description = "Partner Interconnect のエッジロケーション"
  type        = string
  default     = "ASIA_EAST1_EDGE1"
}

variable "fastconnect_provider_name" {
  description = "FastConnect プロバイダー名"
  type        = string
  default     = "Google Cloud"
}

variable "fastconnect_port_speed_shape" {
  description = "FastConnect ポート速度"
  type        = string
  default     = "1 Gbps"
}

variable "gcp_pairing_key" {
  description = "GCP VLAN Attachment のペアリングキー（第2段階で設定するので空のまま）"
  type        = string
  default     = ""
}
