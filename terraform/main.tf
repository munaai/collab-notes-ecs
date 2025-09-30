data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
module "security_groups" {
  source = "./modules/security_groups"

  alb_sg_name                 = var.alb_sg_name
  alb_sg_description          = var.alb_sg_description
  vpc_id                      = module.vpc.vpc_id
  alb_ingress_http_from_port  = var.alb_ingress_http_from_port
  alb_ingress_http_to_port    = var.alb_ingress_http_to_port
  alb_ingress_https_from_port = var.alb_ingress_https_from_port
  alb_ingress_https_to_port   = var.alb_ingress_https_to_port
  ingress_protocol            = var.ingress_protocol
  egress_protocol             = var.egress_protocol
  alb_ingress_cidr_blocks     = var.alb_ingress_cidr_blocks

  ecs_sg_name            = var.ecs_sg_name
  ecs_sg_description     = var.ecs_sg_description
  ecs_ingress_from_port  = var.ecs_ingress_from_port
  ecs_ingress_to_port    = var.ecs_ingress_to_port
  ecs_egress_from_port   = var.ecs_egress_from_port
  ecs_egress_to_port     = var.ecs_egress_to_port
  ecs_egress_cidr_blocks = var.ecs_egress_cidr_blocks
}
module "iam_roles" {
  source = "./modules/iam_roles"

  create_ecs_execution_role = var.create_ecs_execution_role
  ecs_role_name             = var.ecs_role_name
  ecs_policy_name           = var.ecs_policy_name
  ecr_repo_name             = var.ecr_repo_name
  create_flow_logs_role     = var.create_flow_logs_role
  flow_logs_role_name       = var.flow_logs_role_name
}

module "alb" {
  source = "./modules/alb"

  alb_name                = var.alb_name
  alb_internal            = var.alb_internal
  alb_deletion_protection = var.alb_deletion_protection
  alb_security_group_ids  = [module.security_groups.alb_sg_id]
  public_subnet_ids       = module.vpc.public_subnet_ids
  vpc_id                  = module.vpc.vpc_id

  target_group_name     = var.target_group_name
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
  waf_name        = var.waf_name
  waf_scope       = var.waf_scope
  waf_rule_name   = var.waf_rule_name
  waf_metric_name = var.waf_metric_name

}



//route53
module "route53" {
  source       = "./modules/route53"
  record_name  = var.record_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}
module "vpc" {
  source               = "./modules/vpc"
  region               = var.region
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
  tags                 = var.tags
  flow_logs_role_arn   = module.iam_roles.flow_logs_role_arn
}

module "ecs" {
  source = "./modules/ecs_fargate"

  cluster_name       = var.cluster_name
  service_name       = var.service_name
  desired_count      = var.desired_count
  container_name     = var.container_name
  container_port     = var.container_port
  task_family        = var.task_family
  task_cpu           = var.task_cpu
  task_memory        = var.task_memory
  image_url          = var.image_url
  execution_role_arn = module.iam_roles.execution_role_arn
  target_group_arn   = module.alb.target_group_arn
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_groups.ecs_sg_id]
}
