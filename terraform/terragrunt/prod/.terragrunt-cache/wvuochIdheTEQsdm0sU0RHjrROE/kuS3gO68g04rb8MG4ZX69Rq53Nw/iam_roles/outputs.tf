# ECS Execution Role ARN
output "execution_role_arn" {
  description = "ARN of the ECS execution role"
  value       = var.create_ecs_execution_role ? aws_iam_role.ecs_execution[0].arn : null
}

# ECS Execution Role Name
output "execution_role_name" {
  description = "Name of the ECS execution role"
  value       = var.create_ecs_execution_role ? aws_iam_role.ecs_execution[0].name : null
}

# Flow Logs Role ARN
output "flow_logs_role_arn" {
  description = "ARN of the Flow Logs role"
  value       = var.create_flow_logs_role ? aws_iam_role.flow_logs[0].arn : null
}

# Flow Logs Role Name
output "flow_logs_role_name" {
  description = "Name of the Flow Logs role"
  value       = var.create_flow_logs_role ? aws_iam_role.flow_logs[0].name : null
}

output "task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task.arn
}