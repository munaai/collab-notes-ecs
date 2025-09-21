output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution.arn
}

output "flow_logs_role_arn" {
  value = aws_iam_role.flow_logs.arn
}