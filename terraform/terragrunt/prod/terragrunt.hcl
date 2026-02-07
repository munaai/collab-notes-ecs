include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//workload"
}

inputs = {
  environment = "prod"

  tags = {
    Environment = "prod"
    Project     = "collab-notes"
  }

  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

  alb_sg_name        = "alb-sg-prod"
  alb_sg_description = "Allow HTTP and HTTPS access to ALB (prod)"

  ecs_sg_name        = "ecs-sg-prod"
  ecs_sg_description = "Allow ECS tasks to receive traffic from ALB (prod)"

  create_ecs_execution_role = true
  ecs_role_name             = "ecs-task-execution-role-prod"
  ecs_policy_name           = "ecs-task-inline-policy-prod"
  ecr_repo_name             = "collab-notes-app"
  create_flow_logs_role     = true
  flow_logs_role_name       = "vpc-flow-logs-role-prod"

  alb_name                = "app-alb-prod"
  alb_internal            = false
  alb_deletion_protection = true
  target_group_name       = "app-tg-prod"

  enable_waf = true

  record_name = "app.munaibrahim.com"

  cluster_name   = "devops-lab-cluster-prod"
  service_name   = "collab-notes-service-prod"
  desired_count  = 2
  container_name = "app"
  task_family    = "memos-task"

  image_url = "985539771340.dkr.ecr.eu-west-2.amazonaws.com/collab-notes-app"
}