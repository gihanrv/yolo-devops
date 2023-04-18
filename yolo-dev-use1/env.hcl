locals {
  aws_region       = "us-east-1"  # aws region that you are going to excute terraform
  aws_region_short = "use1"
  #aws_account_id   =  "11111111111" #
  environment  = "dev"
  ec2_ssh_key  = "ec2-ssh-key" # if you alredy have a aws kms key you can give the name of the key
  aws_profile  = "default" # aws profile name that you are going to excute the terraform; view avilable aws profile ~/.aws/config
  default_tags = {
    envName    = "development"
    infraOwner = "DevOps"
    managedBy  = "terraform"
    technology = "aws"
  }


}
