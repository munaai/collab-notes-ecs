include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//workload"
}

inputs = {
  environment = "dev"
}