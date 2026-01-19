terraform {
  backend "s3" {
    bucket         = "my-terraform-config-bucket-muna"
    key            = "bootstrap/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}