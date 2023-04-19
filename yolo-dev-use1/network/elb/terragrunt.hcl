locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  group_vars       = read_terragrunt_config(find_in_parent_folders("group.hcl"))
  default_tags     = local.environment_vars.locals.default_tags

}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}//modules/aws/elb"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency vpc {
  config_path = "../vpc"
}

dependency ec2 {
  config_path = "../../compute/ec2"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  #ALB Vars
  stack                      = "alb"  
  create_lb                  = true
  lb_name                    = "yolo-alb-dev"
  lb_internal                = false
  lb_type                    = "application"
  lb_subnets                 = dependency.vpc.outputs.public_subnets
  enable_deletion_protection = false
  common_tags                = merge(local.default_tags, local.group_vars.locals) 

  # Target Group Vars
  create_tg                   = true
  # lb_arn                      = ""
  vpc_id                      = dependency.vpc.outputs.vpc_id
  lb_tg_name                  = "yolo-tg-dev"
  lb_tg_protocol              = "HTTP"
  lb_type                     = "application"
  lb_tg_deregistration_delay  = 300
  lb_tg_target_type           = "instance"
  lb_tg_service_containerport = 80
  common_tags                 = merge(local.default_tags, local.group_vars.locals)
  lb_tg_health_check_enabled  = true
  lb_tg_health_check_interval = 10
  lb_tg_healthy_threshold     = 3
  lb_tg_unhealthy_threshold   = 2
  lb_tg_health_check_matcher  = "200-400"

  #ALB SSL variables
  lb_list_service_ssl_enabled      = false
  lb_list_rule_service_ssl_enabled = false
  lb_list_ssl_policy               = ""
  lb_list_certificate_arn          = ""

  #lb_arn                            = "${dependency.lb.outputs.alb_arn}"
  lb_list_create_http_listner       = true
  lb_list_rule_service_http_enabled = false
  lb_list_rule_service_url          = ""
  lb_list_rule_http_listner_arn     = ""
  
  #Register Target
  instance_ids                  =  dependency.ec2.outputs.ec2_instance_id

  security_group_rules_ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "default ngix allow security group"
    }
  ]

  security_group_rules_egress = [
    {
      
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "default outbound rule"
    
    }
  ]
}
