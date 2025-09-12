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

  ecs_sg_name             = var.ecs_sg_name
  ecs_sg_description      = var.ecs_sg_description
  ecs_ingress_from_port   = var.ecs_ingress_from_port
  ecs_ingress_to_port     = var.ecs_ingress_to_port
  ecs_egress_from_port    = var.ecs_egress_from_port
  ecs_egress_to_port      = var.ecs_egress_to_port
  ecs_egress_cidr_blocks  = var.ecs_egress_cidr_blocks
}

module "vpc" {
  source              = "./modules/vpc"
  region              = var.region
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs= var.private_subnet_cidrs
  azs                 = var.azs
  tags                = var.tags
  vpc_endpoint_sg_id  = module.security_groups.ecs_sg_id 
}
