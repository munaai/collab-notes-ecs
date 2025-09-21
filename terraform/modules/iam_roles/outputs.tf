output "ecs_execution_role_arn" {
  value = length(aws_iam_role.ecs_execution) > 0 ? aws_iam_role.ecs_execution[0].arn : null
}

output "flow_logs_role_arn" {
  value = length(aws_iam_role.flow_logs) > 0 ? aws_iam_role.flow_logs[0].arn : null
}
