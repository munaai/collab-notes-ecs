terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_caller_identity" "current" {}

# ECS EXECUTION ROLE (ECS agent uses this to pull images, publish logs, and fetch secrets for injection)
resource "aws_iam_role" "ecs_execution" {
  count = var.create_ecs_execution_role ? 1 : 0
  name  = var.ecs_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWS managed execution policy (ECR auth, logs, etc.)
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  count      = var.create_ecs_execution_role ? 1 : 0
  role       = aws_iam_role.ecs_execution[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Allow ECS to fetch secrets at task startup (THIS FIXES YOUR ERROR)
resource "aws_iam_role_policy" "ecs_execution_secrets" {
  count = var.create_ecs_execution_role ? 1 : 0
  name  = "ecs-execution-secrets-policy"
  role  = aws_iam_role.ecs_execution[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ReadSecretsForECSInjection",
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = var.secrets_manager_arns
      }
    ]
  })
}

# ECS TASK ROLE (Your application uses this ONLY if it needs AWS API access at runtime)
resource "aws_iam_role" "ecs_task" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role" "flow_logs" {
  count = var.create_flow_logs_role ? 1 : 0
  name  = var.flow_logs_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "flow_logs" {
  count = var.create_flow_logs_role ? 1 : 0
  name  = "${var.flow_logs_role_name}-policy"
  role  = aws_iam_role.flow_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = [
          format(
            "arn:aws:logs:%s:%s:log-group:/aws/vpc/flow-logs:*",
            var.region,
            data.aws_caller_identity.current.account_id
          )
        ]
      }
    ]
  })
}