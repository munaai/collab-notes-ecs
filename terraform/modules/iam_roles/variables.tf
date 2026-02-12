variable "create_ecs_execution_role" {
  description = "Whether to create an ECS execution role"
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
  description = "Name of the ECR repository"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "create_flow_logs_role" {
  description = "Whether to create a VPC Flow Logs role"
  type        = bool
  default     = true
}

variable "flow_logs_role_name" {
  description = "Name of the VPC Flow Logs role"
  type        = string
  default     = "vpc-flow-logs-role"
}
variable "secrets_manager_arns" {
  type        = list(string)
  description = "ARNs of Secrets Manager secrets ECS tasks can read"
}