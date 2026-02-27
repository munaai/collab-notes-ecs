variable "alb_sg_name" {
  type = string
}
variable "alb_sg_description" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "alb_ingress_http_from_port" {
  type = number
}
variable "alb_ingress_http_to_port" {
  type = number
}

variable "alb_ingress_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to access the ALB"
}

variable "alb_ingress_https_from_port" {
  type = number
}
variable "alb_ingress_https_to_port" {
  type = number
}
variable "ecs_egress_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks ECS tasks can access"
}
variable "ecs_sg_name" {
  type = string
}
variable "ecs_sg_description" {
  type = string
}

variable "ecs_ingress_from_port" {
  type = number
}
variable "ecs_ingress_to_port" {
  type = number
}
variable "ecs_egress_from_port" {
  type = number
}
variable "ecs_egress_to_port" {
  type = number
}

variable "ingress_protocol" {
  type = string
}
variable "egress_protocol" {
  type = string
}

variable "rds_sg_name" {
  type        = string
  description = "RDS security group name"
}

variable "rds_sg_description" {
  type        = string
  description = "RDS security group description"
}

variable "rds_port" {
  type        = number
  description = "Postgres port"
  default     = 5432
}

variable "rds_protocol" {
  type    = string
  default = "tcp"
}

variable "rds_ingress_description" {
  type    = string
  default = "Postgres access from ECS only"
}

variable "rds_egress_from_port" {
  type    = number
  default = 0
}

variable "rds_egress_to_port" {
  type    = number
  default = 0
}

variable "rds_egress_protocol" {
  type    = string
  default = "-1"
}

variable "rds_egress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}