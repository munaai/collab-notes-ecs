include {
  path = find_in_parent_folders("root.hcl")
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

  # --------------------
  # VPC
  # --------------------
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

  # --------------------
  # Security Groups (names + descriptions only)
  # --------------------
  alb_sg_name        = "alb-sg-dev"
  alb_sg_description = "Allow HTTP and HTTPS access to ALB (dev)"

  ecs_sg_name        = "ecs-sg-dev"
  ecs_sg_description = "Allow ECS tasks to receive traffic from ALB (dev)"

  rds_sg_name        = "rds-sg-dev"
  rds_sg_description = "Allow Postgres access from ECS (dev)"

  # --------------------
  # IAM
  # --------------------
  create_ecs_execution_role = true
  ecs_role_name             = "ecs-task-execution-role-dev"
  ecs_policy_name           = "ecs-task-inline-policy-dev"

  ecr_repo_name             = "collab-notes-app"

  create_flow_logs_role     = true
  flow_logs_role_name       = "vpc-flow-logs-role-dev"

  # --------------------
  # ALB
  # --------------------
  alb_name                = "app-alb-dev"
  alb_internal            = false
  alb_deletion_protection = false

  target_group_name = "app-tg-dev"

  enable_waf = false

  # --------------------
  # Route53
  # --------------------
  record_name = "dev.app.munaibrahim.com"

  # --------------------
  # ECS
  # --------------------
  cluster_name   = "devops-lab-cluster-dev"
  service_name   = "collab-notes-service-dev"
  desired_count  = 1

  container_name = "app"
  task_family    = "memos-task-dev"

  image_url = "985539771340.dkr.ecr.eu-west-2.amazonaws.com/collab-notes-app:dev"

  # --------------------
  # RDS (Postgres – Dev)
  # --------------------
  db_identifier        = "collab-notes-postgres-dev"

  db_engine            = "postgres"
  db_instance_class    = "db.t3.micro"
  db_allocated_storage = 20

  db_name     = "collabnotes_dev"
  db_username = "collabnotes"
  db_password = get_env("DB_PASSWORD")

  db_publicly_accessible     = false
  db_backup_retention_period = 7
  db_skip_final_snapshot     = true
  db_deletion_protection     = false

  # --------------------
  # Secrets manager
  # --------------------

  db_secret_name = "collab-notes-db"
}

 