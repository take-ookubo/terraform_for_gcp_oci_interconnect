resource "google_compute_interconnect_attachment" "partner_interconnect" {
  name   = "${var.vpc_name}-partner-interconnect"
  region = var.region
  router = google_compute_router.router.id

  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"  # OCI は "any" を受け付けないため明示的に指定
  # bandwidth は Partner Interconnect では指定不可（パートナー側で設定）
}
