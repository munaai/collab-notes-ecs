variable "db_identifier" {
  type        = string
  description = "RDS instance identifier"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for RDS"
}

variable "db_engine" {
  type        = string
  description = "Database engine"
  default     = "postgres"
}

variable "db_engine_version" {
  type        = string
  description = "Database engine version"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance size"
}

variable "db_allocated_storage" {
  type        = number
  description = "Storage in GB"
}

variable "db_name" {
  type        = string
  description = "Initial database name"
}

variable "db_username" {
  type        = string
  description = "Master username"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Master password"
}

variable "db_security_group_id" {
  type        = string
  description = "Security group ID for RDS"
}

variable "db_publicly_accessible" {
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  type    = number
  default = 7
}

variable "db_skip_final_snapshot" {
  type    = bool
  default = true
}

variable "db_deletion_protection" {
  type    = bool
  default = false
}

variable "tags" {
  type = map(string)
}