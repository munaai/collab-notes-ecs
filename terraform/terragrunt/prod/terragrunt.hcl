inputs = {
  environment = "prod"

  tags = {
    Environment = "prod"
    Project     = "collab-notes"
  }

  # Same structure as dev
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

  alb_sg_name        = "alb-sg-prod"
  ecs_sg_name        = "ecs-sg-prod"

  alb_name           = "app-alb-prod"
  target_group_name  = "app-tg-prod"

  cluster_name       = "devops-lab-cluster-prod"
  service_name       = "collab-notes-service-prod"

  alb_deletion_protection = true
  enable_waf              = true
  desired_count           = 2

  # everything else same as dev
}