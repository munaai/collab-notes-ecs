variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "desired_count" {
  description = "Number of desired ECS tasks"
  type        = number
}

variable "task_role_arn" {
  description = "IAM role that the task itself assumes for permissions (e.g., access to S3, DynamoDB)"
  type        = string
}
variable "container_name" {
  description = "name of the container"
  type        = string
}

variable "container_port" {
  description = "container port"
  type        = number
}
variable "task_family" {
  description = "family name"
  type        = string
}
variable "task_cpu" {
  description = "cpu"
  type        = string
}

variable "task_memory" {
  description = "memory"
  type        = string
}

variable "image_url" {
  description = "link of the image in ecr"
  type        = string
}

variable "execution_role_arn" {
  description = "iam role imported"
  type        = string
}

variable "target_group_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret containing DB credentials"
  type        = string
}
variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
}

