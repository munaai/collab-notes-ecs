// VPC
variable "region" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

// SECURITUY GROUPS
variable "alb_sg_name" {
  type = string
}

variable "alb_sg_description" {
  type = string
}

variable "alb_ingress_http_from_port" {
  type = number
}

variable "alb_ingress_http_to_port" {
  type = number
}

variable "alb_ingress_https_from_port" {
  type = number
}

variable "alb_ingress_https_to_port" {
  type = number
}

variable "ingress_protocol" {
  type = string
}

variable "egress_protocol" {
  type = string
}

variable "alb_ingress_cidr_blocks" {
  type = list(string)
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

variable "ecs_egress_cidr_blocks" {
  type = list(string)
}

// IAM ROLES
variable "role_name" {
  description = "IAM role name"
  type        = string
}

variable "assume_service" {
  type = string
}

variable "policy_name" {
  type = string
}
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
}
variable "account_id" {
  description = "AWS account ID"
  type        = string
}
