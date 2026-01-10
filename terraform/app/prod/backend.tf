terraform {
  backend "s3" {
    bucket         = "my-terraform-config-bucket-muna"
    key            = "app/prod/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
