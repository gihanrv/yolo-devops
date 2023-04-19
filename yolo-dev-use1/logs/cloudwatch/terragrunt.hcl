locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  group_vars       = read_terragrunt_config(find_in_parent_folders("group.hcl"))
  default_tags     = local.environment_vars.locals.default_tags
  #aws_region       = local.environment_vars.locals.aws_region

}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}//modules/aws/cloudwatch"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../network/vpc"]
}

dependency vpc {
  config_path = "../../network/vpc"
}
# profile     = "yolo-nonprod" # changed it your aws profile name (cat .aws/config)
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  common_tags             = merge(local.default_tags, local.group_vars.locals)   
  stack                   = "ec2"
  cloudwatch_log_group_name =  "/var/log/nginx/"
  cloudwatch_log_subscription_name   = "docker-nginx-logs-filter"
  cloudwatch_log_destination_name =  "nginx-logs"
  #aws_region = local.aws_region
  # user_data               = var.user_data
  #instance_iam_role       = var.instance_iam_role

}