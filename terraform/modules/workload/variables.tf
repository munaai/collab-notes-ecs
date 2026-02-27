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


variable "create_ecs_execution_role" {
  description = "Whether to create the ECS execution role"
  type        = bool
  default     = true
}

variable "ecs_role_name" {
  description = "Name of the ECS execution role"
  type        = string
  default     = "ecs-task-execution-role"
}

variable "ecs_policy_name" {
  description = "Name of the inline ECS policy"
  type        = string
  default     = "ecs-task-inline-policy"
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository (required if pulling private images)"
  type        = string
  default     = ""
}

variable "create_flow_logs_role" {
  description = "Whether to create the VPC Flow Logs role"
  type        = bool
  default     = true
}

variable "flow_logs_role_name" {
  description = "Name of the VPC Flow Logs IAM role"
  type        = string
  default     = "vpc-flow-logs-role"
}

// ALB

variable "alb_name" {
  type = string
}
variable "alb_internal" {
  type    = bool
  default = false
}
variable "alb_deletion_protection" {
  type    = bool
  default = false
}

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


# ---- RDS
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

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_publicly_accessible" {
  type        = bool
  description = "Whether the RDS instance is publicly accessible"
  default     = false
}

variable "db_backup_retention_period" {
  type        = number
  description = "Number of days to retain backups"
  default     = 7
}

variable "db_skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot on destroy"
  default     = true
}

variable "db_deletion_protection" {
  type        = bool
  description = "Enable deletion protection for RDS"
  default     = false
}

variable "db_identifier" {
  type        = string
  description = "RDS instance identifier"
}

variable "db_engine" {
  type        = string
  description = "Database engine (e.g. postgres)"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class (e.g. db.t3.micro)"
}

variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage in GB"
}

variable "environment" {
  type = string
}

variable "db_secret_name" {
  description = "Base name for the DB secret"
  type        = string
  default     = "collab-notes-db"
}

variable "region" {
  description = "AWS region (e.g. eu-west-2)"
  type        = string
}