locals {
  env = terraform.workspace
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# --- Security Groups ---
module "security_groups" {
  source = "../security_groups"

  alb_sg_name                 = "${var.alb_sg_name}-${local.env}"
  alb_sg_description          = var.alb_sg_description
  vpc_id                      = module.vpc.vpc_id
  alb_ingress_http_from_port  = var.alb_ingress_http_from_port
  alb_ingress_http_to_port    = var.alb_ingress_http_to_port
  alb_ingress_https_from_port = var.alb_ingress_https_from_port
  alb_ingress_https_to_port   = var.alb_ingress_https_to_port
  ingress_protocol            = var.ingress_protocol
  egress_protocol             = var.egress_protocol
  alb_ingress_cidr_blocks     = var.alb_ingress_cidr_blocks

  ecs_sg_name            = "${var.ecs_sg_name}-${local.env}"
  ecs_sg_description     = var.ecs_sg_description
  ecs_ingress_from_port  = var.ecs_ingress_from_port
  ecs_ingress_to_port    = var.ecs_ingress_to_port
  ecs_egress_from_port   = var.ecs_egress_from_port
  ecs_egress_to_port     = var.ecs_egress_to_port
  ecs_egress_cidr_blocks = var.ecs_egress_cidr_blocks

  rds_sg_name        = var.rds_sg_name
  rds_sg_description = var.rds_sg_description
  rds_port           = var.rds_port
}

# --- IAM Roles ---
module "iam_roles" {
  source = "../iam_roles"

  create_ecs_execution_role = var.create_ecs_execution_role
  ecs_role_name             = "${var.ecs_role_name}-${local.env}"
  ecs_policy_name           = "${var.ecs_policy_name}-${local.env}"
  ecr_repo_name             = "${var.ecr_repo_name}-${local.env}"
  create_flow_logs_role     = var.create_flow_logs_role
  flow_logs_role_name       = "${var.flow_logs_role_name}-${local.env}"
  secrets_manager_arns      = [module.secrets_manager.db_secret_arn]
}

# --- ALB ---
module "alb" {
  source = "../alb"

  alb_name                = "${var.alb_name}-${local.env}"
  alb_internal            = var.alb_internal
  alb_deletion_protection = var.alb_deletion_protection
  alb_security_group_ids  = [module.security_groups.alb_sg_id]
  public_subnet_ids       = module.vpc.public_subnet_ids
  vpc_id                  = module.vpc.vpc_id

  target_group_name     = "${var.target_group_name}-${local.env}"
  target_group_protocol = var.target_group_protocol
  container_port        = var.container_port

  health_check_path                = var.health_check_path
  health_check_interval            = var.health_check_interval
  health_check_timeout             = var.health_check_timeout
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_matcher             = var.health_check_matcher
  https_listener_port              = var.https_listener_port
  https_listener_protocol          = var.https_listener_protocol
  http_listener_port               = var.http_listener_port
  http_listener_protocol           = var.http_listener_protocol
  http_redirect_status_code        = var.http_redirect_status_code

  enable_waf      = var.enable_waf
  waf_name        = "${var.waf_name}-${local.env}"
  waf_scope       = var.waf_scope
  waf_rule_name   = "${var.waf_rule_name}-${local.env}"
  waf_metric_name = "${var.waf_metric_name}-${local.env}"
}

# --- Route53 
data "aws_route53_zone" "this" {
  name         = "munaibrahim.com"
  private_zone = false
}

module "route53" {
  source = "../route53"

  zone_id      = data.aws_route53_zone.this.zone_id
  record_name  = var.record_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

# --- VPC ---
module "vpc" {
  source               = "../vpc"
  region               = var.region
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
  tags = merge(var.tags, {
    Environment = local.env
  })
  flow_logs_role_arn = module.iam_roles.flow_logs_role_arn
}

# --- ECS ---
module "ecs_fargate" {
  source             = "../ecs_fargate"
  cluster_name       = "${var.cluster_name}-${local.env}"
  service_name       = "${var.service_name}-${local.env}"
  desired_count      = local.env == "prod" ? 1 : 1
  container_name     = "${var.container_name}-${local.env}"
  container_port     = var.container_port
  task_family        = "${var.task_family}-${local.env}"
  task_cpu           = var.task_cpu
  task_memory        = var.task_memory
  image_url          = var.image_url
  execution_role_arn = module.iam_roles.execution_role_arn
  task_role_arn      = module.iam_roles.task_role_arn
  target_group_arn   = module.alb.target_group_arn
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_groups.ecs_sg_id]
  environment        = var.environment
  db_secret_arn      = module.secrets_manager.db_secret_arn
}

# --- RDS
module "rds" {
  source = "../rds"

  # Identifiers
  db_identifier = var.db_identifier

  # Engine
  db_engine            = var.db_engine
  db_engine_version    = var.db_engine_version
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage

  # Credentials / DB
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  # Networking
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_security_group_id = module.security_groups.rds_security_group_id

  # Behaviour
  db_publicly_accessible     = var.db_publicly_accessible
  db_backup_retention_period = var.db_backup_retention_period
  db_skip_final_snapshot     = var.db_skip_final_snapshot
  db_deletion_protection     = var.db_deletion_protection

  tags = var.tags
}

module "secrets_manager" {
  source = "../secrets_manager"

  db_secret_name = var.db_secret_name
  environment    = var.environment

  db_username = var.db_username
  db_password = var.db_password
  db_name     = var.db_name

  db_host = module.rds.db_endpoint
  db_port = module.rds.db_port

  tags = var.tags
}