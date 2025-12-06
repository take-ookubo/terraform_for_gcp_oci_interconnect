variable "project_id" {
  description = "GCP プロジェクト ID"
  type        = string
}

variable "region" {
  description = "GCP リージョン"
  type        = string
}

variable "vpc_name" {
  description = "VPC 名"
  type        = string
}

variable "subnet_cidr" {
  description = "サブネット CIDR"
  type        = string
}

variable "router_asn" {
  description = "Cloud Router の BGP ASN"
  type        = number
}

variable "bandwidth" {
  description = "Interconnect 帯域幅"
  type        = string
}

variable "edge_availability_domain" {
  description = "Partner Interconnect のエッジロケーション"
  type        = string
}
