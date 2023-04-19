locals {
  aws_region       = "us-east-1"  # aws region that you are going to excute terraform
  aws_region_short = "use1"
  aws_account_id   =  "724866671659" #aws account ID
  environment  = "dev"
  ec2_ssh_key  = "yolo" #aws kms  pvt key name that you are using ssh 
  aws_profile  = "default" # aws profile name that you are going to excute the terraform; view avilable aws profile ~/.aws/config
  default_tags = {
    envName    = "development"
    infraOwner = "DevOps"
    managedBy  = "terraform"
    technology = "aws"
  }


}
