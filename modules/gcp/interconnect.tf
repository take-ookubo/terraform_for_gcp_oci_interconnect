resource "google_compute_interconnect_attachment" "partner_interconnect" {
  name   = "${var.vpc_name}-partner-interconnect"
  region = var.region
  router = google_compute_router.router.id

  type                     = "PARTNER"
  edge_availability_domain = var.edge_availability_domain
  bandwidth                = var.bandwidth
}
