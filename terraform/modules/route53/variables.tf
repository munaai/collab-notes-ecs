variable "zone_id" {
  type        = string
  description = "Route53 hosted zone ID"
}

variable "record_name" {
  type        = string
  description = "DNS record name (e.g. app.example.com)"
}

variable "alb_dns_name" {
  type        = string
  description = "ALB DNS name"
}

variable "alb_zone_id" {
  type        = string
  description = "ALB hosted zone ID"
}