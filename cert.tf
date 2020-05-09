data "aws_acm_certificate" "cert" {
  domain   = var.acm_certificate_domain
  statuses = ["ISSUED"]
}
