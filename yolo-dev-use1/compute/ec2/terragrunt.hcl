locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  group_vars       = read_terragrunt_config(find_in_parent_folders("group.hcl"))
  ec2_ssh_key      = local.environment_vars.locals.ec2_ssh_key
  default_tags     = local.environment_vars.locals.default_tags

}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}//modules/aws/ec2"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# dependencies {
#   paths = ["../../network/vpc"]
# }

dependency vpc {
  config_path = "../../network/vpc"
}
# profile     = "yolo-nonprod" # changed it your aws profile name (cat .aws/config)
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  common_tags             = merge(local.default_tags, local.group_vars.locals)   
  stack                   = "ec2"
  instance_names          = ["server1","server2","server3"]
  ami                     = "ami-007855ac798b5175e"
  instance_type           = "t2.micro"
  key_name                = local.ec2_ssh_key
  subnet_ids              = dependency.vpc.outputs.public_subnets
  vpc_id                  = dependency.vpc.outputs.vpc_id
  # subnet_ids              = var.subnet_ids
  # user_data               = var.user_data
  #instance_iam_role       = var.instance_iam_role
  disable_api_termination = true
  root_ebs_size           = "8"
  root_ebs_vol_type       = "gp3"

  security_group_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "default ssh allow security group"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "default ngix allow security group"
    }
  ]



}