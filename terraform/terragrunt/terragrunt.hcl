locals {
  aws_region = "eu-west-2"
}

# --------------------
# Remote state (shared)
# --------------------
remote_state {
  backend = "s3"

  disable_init = false

  config = {
    bucket         = "my-terraform-config-bucket-muna"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "terraform-locks"
    key            = "${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

# --------------------
# Shared inputs (ALL envs)
# --------------------
inputs = {
  # Region / AZs
  region = local.aws_region
  azs    = ["eu-west-2a", "eu-west-2b"]

  # ALB security group
  alb_ingress_http_from_port  = 80
  alb_ingress_http_to_port    = 80
  alb_ingress_https_from_port = 443
  alb_ingress_https_to_port   = 443
  alb_ingress_cidr_blocks     = ["0.0.0.0/0"]

  ingress_protocol = "tcp"
  egress_protocol  = "-1"

  # ALB health checks
  health_check_path                = "/"
  health_check_interval            = 30
  health_check_timeout             = 5
  health_check_healthy_threshold   = 2
  health_check_unhealthy_threshold = 2
  health_check_matcher             = "200"

  # ALB listeners
  http_listener_port        = 80
  http_listener_protocol    = "HTTP"
  http_redirect_status_code = "HTTP_301"

  https_listener_port     = 443
  https_listener_protocol = "HTTPS"

  target_group_protocol = "HTTP"

  # ECS security group
  ecs_ingress_from_port  = 8081
  ecs_ingress_to_port    = 8081
  ecs_egress_from_port   = 0
  ecs_egress_to_port     = 0
  ecs_egress_cidr_blocks = ["0.0.0.0/0"]

  # ECS container + task sizing
  container_port = 8081
  task_cpu       = "256"
  task_memory    = "512"
}

# --------------------
# Provider (generated)
# --------------------
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  contents  = <<EOF
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "${local.aws_region}"
}
EOF
}