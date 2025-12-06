variable "compartment_id" {
  description = "OCI コンパートメント OCID"
  type        = string
}

variable "region" {
  description = "OCI リージョン"
  type        = string
}

variable "vcn_cidr" {
  description = "VCN CIDR"
  type        = string
}

variable "vcn_name" {
  description = "VCN 名"
  type        = string
}

variable "fastconnect_provider" {
  description = "FastConnect プロバイダー名"
  type        = string
}

variable "fastconnect_port_speed" {
  description = "FastConnect ポート速度"
  type        = string
}
