output "db_secret_arn" {
  description = "ARN of the DB secret"
  value       = aws_secretsmanager_secret.db.arn
}