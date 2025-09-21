variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "vpc_endpoint_sg_id" {
  description = "Security group ID to attach to interface VPC endpoints"
  type        = string
}
variable "flow_logs_role_arn" {
  description = "IAM role ARN that VPC Flow Logs will assume to publish logs to CloudWatch"
  type        = string
}

# variable "account_id" {
#   type        = string
#   description = "AWS Account ID for resource policies"
# }

