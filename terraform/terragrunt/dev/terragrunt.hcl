include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//workload"
}

inputs = {
  environment = "dev"

  tags = {
    Environment = "dev"
    Project     = "collab-notes"
  }

  # VPC
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

  # Security groups (names only)
  alb_sg_name        = "alb-sg"
  alb_sg_description = "Allow HTTP and HTTPS access to ALB"

  ecs_sg_name        = "ecs-sg"
  ecs_sg_description = "Allow ECS tasks to receive traffic from ALB"

  # IAM
  create_ecs_execution_role = true
  ecs_role_name             = "ecs-task-execution-role"
  ecs_policy_name           = "ecs-task-inline-policy"
  ecr_repo_name             = "collab-notes-app"
  create_flow_logs_role     = true
  flow_logs_role_name       = "vpc-flow-logs-role"

  # ALB
  alb_name                = "app-alb"
  alb_internal            = false
  alb_deletion_protection = false
  target_group_name       = "app-tg"

  enable_waf = false

  # DNS
  record_name = "app.munaibrahim.com"

  # ECS
  cluster_name   = "devops-lab-cluster"
  service_name   = "collab-notes-service"
  desired_count  = 1
  container_name = "app"
  task_family    = "memos-task"

  image_url = "985539771340.dkr.ecr.eu-west-2.amazonaws.com/collab-notes-app"
}