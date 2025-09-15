variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID for the domain"
  type        = string
}

variable "record_name" {
  description = "The record name for the app (e.g., app.munaibrahim.com)"
  type        = string
}

variable "record_type" {
  description = "Record type (usually 'A' for ALB alias)"
  type        = string
  default     = "A"
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Hosted zone ID of the ALB"
  type        = string
}
