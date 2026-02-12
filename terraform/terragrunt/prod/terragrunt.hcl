include {
  path = find_in_parent_folders("root.hcl")
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

  # --------------------
  # VPC
  # --------------------
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

  # --------------------
  # Security Groups
  # --------------------
  alb_sg_name        = "alb-sg-prod"
  alb_sg_description = "Allow HTTP and HTTPS access to ALB (prod)"

  ecs_sg_name        = "ecs-sg-prod"
  ecs_sg_description = "Allow ECS tasks to receive traffic from ALB (prod)"

  rds_sg_name        = "rds-sg-prod"
  rds_sg_description = "Allow Postgres access from ECS (prod)"

  # --------------------
  # IAM
  # --------------------
  create_ecs_execution_role = true
  ecs_role_name             = "ecs-task-execution-role-prod"
  ecs_policy_name           = "ecs-task-inline-policy-prod"
  ecr_repo_name             = "collab-notes-app"
  create_flow_logs_role     = true
  flow_logs_role_name       = "vpc-flow-logs-role-prod"

  # --------------------
  # ALB
  # --------------------
  alb_name                = "app-alb-prod"
  alb_internal            = false
  alb_deletion_protection = false

  target_group_name = "app-tg-prod"

  enable_waf = true

  # --------------------
  # Route53
  # --------------------
  record_name = "app.munaibrahim.com"

  # --------------------
  # ECS
  # --------------------
  cluster_name   = "devops-lab-cluster-prod"
  service_name   = "collab-notes-service-prod"
  desired_count  = 2

  container_name = "app"
  task_family    = "memos-task-prod"

  image_url = "985539771340.dkr.ecr.eu-west-2.amazonaws.com/collab-notes-app:prod"

  # --------------------
  # RDS (Postgres – Prod)
  # --------------------
  db_identifier        = "collab-notes-postgres-prod"

  db_engine            = "postgres"
  db_engine_version    = "15.4"
  db_instance_class    = "db.t3.micro"   # upgrade later for real prod
  db_allocated_storage = 20

  db_name     = "collabnotes_prod"
  db_username = "collabnotes"
  db_password = get_env("DB_PASSWORD")

  db_publicly_accessible     = false
  db_backup_retention_period = 14
  db_skip_final_snapshot     = false   # IMPORTANT for prod
  db_deletion_protection     = true    # IMPORTANT for prod

  # --------------------
  # Secrets Manager
  # --------------------
  db_secret_name = "collab-notes-db"
}