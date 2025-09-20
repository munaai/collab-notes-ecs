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

variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
}
# variable "account_id" {
#   description = "AWS account ID"
#   type        = string
# }

// ALB

variable "alb_name" {
  type = string
}
variable "alb_internal" {
  type    = bool
  default = false
}
# variable "alb_deletion_protection" {
#   type = bool
# }

variable "target_group_name" {
  type = string
}
variable "target_group_protocol" {
  type    = string
  default = "HTTP"
}

variable "health_check_path" {
  type    = string
  default = "/"
}
variable "health_check_interval" {
  type    = number
  default = 30
}
variable "health_check_timeout" {
  type    = number
  default = 5
}
variable "health_check_healthy_threshold" {
  type    = number
  default = 2
}
variable "health_check_unhealthy_threshold" {
  type    = number
  default = 2
}
variable "health_check_matcher" {
  type    = string
  default = "200"
}

# variable "ssl_policy" {
#   type    = string
#   default = "ELBSecurityPolicy-2016-08"
# }
variable "https_listener_port" {
  type    = number
  default = 443
}

variable "https_listener_protocol" {
  type    = string
  default = "HTTPS"
}

variable "http_listener_port" {
  type        = number
  description = "Port for HTTP listener"
}

variable "http_listener_protocol" {
  type        = string
  description = "Protocol for HTTP listener"
}

variable "http_redirect_status_code" {
  type        = string
  description = "Redirect status code (e.g., HTTP_301)"
}

variable "enable_waf" {
  description = "Whether to enable WAF for the ALB"
  type        = bool
}

variable "waf_name" {
  description = "Name of the WAF Web ACL"
  type        = string
  default     = "alb-waf"
}

variable "waf_scope" {
  description = "WAF scope: REGIONAL for ALB"
  type        = string
  default     = "REGIONAL"
}

variable "waf_rule_name" {
  description = "Name of the WAF rule"
  type        = string
  default     = "AWS-AWSManagedRulesCommonRuleSet"
}

variable "waf_metric_name" {
  description = "WAF metric name"
  type        = string
  default     = "albWAF"
}
variable "container_port" {
  description = "Port that your container listens on"
  type        = number
  default     = 8081
}

// route53
variable "hosted_zone_id" {
  type        = string
  description = "Route 53 Hosted Zone ID"
}

variable "record_name" {
  type        = string
  description = "Domain name to point to ALB (e.g. app.munaibrahim.com)"
}

// ecs_fargate
variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "desired_count" {
  description = "Number of desired ECS tasks"
  type        = number
}

# variable "cluster_insight_name" {
#   description = "name of the cluster setting name"
#   type        = string
# }

# variable "cluster_insight_value" {
#   description = "name of the cluster setting value"
#   type        = string
# }

variable "container_name" {
  description = "name of the container"
  type        = string
}

variable "task_family" {
  description = "family name"
  type        = string
}
variable "task_cpu" {
  description = "cpu"
  type        = string
}

variable "task_memory" {
  description = "memory"
  type        = string
}

variable "image_url" {
  description = "link of the image in ecr"
  type        = string
}



