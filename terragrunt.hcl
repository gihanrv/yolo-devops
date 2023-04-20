# Settings in this terraform.hcl are inherited by all environments
# found downstream. You can overwrite them on the environment level.

locals {
  # Automatically load environment variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  group_vars       = read_terragrunt_config(find_in_parent_folders("group.hcl"))

  # Extract the variables we need for easy access
  aws_region       = local.environment_vars.locals.aws_region
  aws_account_id   = local.environment_vars.locals.aws_account_id
  aws_region_short = local.environment_vars.locals.aws_region_short
  environment      = local.environment_vars.locals.environment
  aws_profile      = local.environment_vars.locals.aws_profile
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "tf-devops-${local.aws_region_short}-${local.environment}"
    key            = "tfstate/${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    profile        = local.aws_profile
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
  profile      = "${local.aws_profile}"
  region       = "${local.aws_region}"
  max_retries  = "30"
}

      EOF
}


# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.environment_vars.locals,
  local.group_vars.locals,
)
