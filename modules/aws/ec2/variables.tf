locals {
  stack_name      = "${var.stack}-${var.environment}"
}

variable "stack" {
  description = "Stack name. will be used as name for all resources created by this role. it will also be used in tags"
  type        = string
}

variable "environment" {
  description = "Environment name. will be append to name on all resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC id "
  type        = string
}

variable "security_group_rules" {
  description = "List of security group rules for ec2 default security group"
  type = list(object({
    from_port   = number,
    to_port     = number,
    protocol    = string,
    cidr_blocks = list(string),
    description = string
  }))
}

variable "ami" {
  description = "AMI id - Specify either RHEL or CentOS"
  type        = string
}

variable "instance_type" {
  description = "InstanceType"
  type        = string
  default     = "t2.micro"
}

variable "instance_names" {
  description = "AWS Host name of the instances"
  type        = list(any)
}

variable "user_data" {
  description = "Provisioning script"
  type        = string
  default     = null
}

variable "git_repo_url" {
  description = "Ansible git repo url"
  type        = string
  default     = "https://github.com/gihanrv/yolo-devops.git"
}

variable "git_repo_name" {
  description = "Ansible git repo name"
  type        = string
  default     = "yolo-devops"
}


variable "git_branch" {
  description = "git branch of asible repo"
  type        = string
  default     = "master"
}

variable "key_name" {
  description = "pem key name to access instance"
  type        = string
}

variable "subnet_ids" {
  description = "A map for subnets"
  type        = list(any)
}

variable "cloudwatch_log_group" {
  description = "cloud watch log group name that you wish to send logs"
  type        = string
  default     = "/var/log/nginx/"
}

variable "cloudwatch_log_file_path" {
  description = "cloud watch log path that you wish to collects logs"
  type        = string
  default     = "/var/log/nginx/access.log"
}

variable "root_ebs_size" {
  description = "Size for root drive"
  type        = number
}

variable "root_ebs_vol_type" {
  description = "volume type for root drive"
  type        = string
}

variable "disable_api_termination" {
  description = "enables EC2 Instance Termination Protection"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}