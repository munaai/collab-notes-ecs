remote_state {
  backend = "s3"

  config = {
    bucket         = "my-terraform-config-bucket-muna"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"

    key = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
EOF
}