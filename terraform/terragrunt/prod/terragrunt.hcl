include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//workload"
}

inputs = {
  environment = "prod"

  tags = {
    Environment = "prod"
    Project     = "collab-notes"
  }

  alb_deletion_protection = true
  enable_waf              = true

  desired_count = 2
}