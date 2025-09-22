terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
data "aws_route53_zone" "this" {
  name         = "munaibrahim.com"
  private_zone = false
}
resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.record_name # e.g., app.munaibrahim.com
  type    = var.record_type

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
