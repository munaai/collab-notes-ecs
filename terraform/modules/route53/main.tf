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
data "aws_route53_record" "existing" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "app.munaibrahim.com"
  type    = "A"
}

