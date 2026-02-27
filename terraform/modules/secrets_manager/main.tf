resource "aws_secretsmanager_secret" "db" {
  name = "${var.db_secret_name}-${var.environment}"
  tags = var.tags
}
resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

 secret_string = jsonencode({
  driver = "postgres"
  dsn    = "postgres://${var.db_username}:${var.db_password}@${var.db_host}:${var.db_port}/${var.db_name}?sslmode=require"
})
}