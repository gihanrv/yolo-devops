locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  group_vars       = read_terragrunt_config(find_in_parent_folders("group.hcl"))
  default_tags     = local.environment_vars.locals.default_tags

}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}//modules/aws/vpc"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}


# profile     = "yolo-nonprod" # changed it your aws profile name (cat .aws/config)
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  common_tags        = merge(local.default_tags, local.group_vars.locals)
  name               = "yolo-dev"
  cidr               = "10.161.0.0/24"
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets    = ["10.161.0.0/27", "10.161.0.32/27", "10.161.0.64/27"]
  public_subnets     = ["10.161.0.96/27", "10.161.0.128/27", "10.161.0.160/27"]
  enable_nat_gateway = true
  single_nat_gateway = true
  stack              = "vpc"

  public_subnet_tags = {
    Tier    = "security"
    Privacy = "public"
  }

  private_subnet_tags = {
    Tier    = "application"
    Privacy = "private"
  }

  vpc_tags = {
    Descriptyion = "Only use for development"
  }

  nat_eip_tags = {
    Name        = "yolo-dev-ng-ip"
    Description = "dev vpc nat elastic ip"
  }
  igw_tags = {
    Name        = "yolo-dev-ig-ip"
    Description = "yolo-dev vpc internet gateway"
  }

  private_route_table_tags = {
    Name        = "yolo-dev-pvt-rt"
    Description = "yolo-dev vpc private route table"
  }

  public_route_table_tags = {
    Name        = "yolo-dev-pub-rt"
    Description = "yolo-dev vpc public route table"
  }

  nat_gateway_tags = {
    Name        = "yolo-dev-ng"
    Description = "yolo-dev vpc nat-gatway"
  }



}