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

variable "create_lb" {
  description = "create create_lb? this is used when intial service creation and later this should set to false if the ecs service is not required a alb"
  type        = bool
  default     = true
}
variable "lb_name" {
  description = "LB Name"
  type        = string
  default     = ""
}

variable "lb_internal" {
  description = "LB subnets ids"
  type        = bool
  default     = true
}

variable "lb_subnets" {
  description = "List of security groups to assign to alb"
  type        = list(string)
}

variable "lb_type" {
  description = "http listner arn, default is empty"
  type        = string
  default     = ""
}

variable "lb_security_groups" {
  description = "http listner arn, default is empty"
  type        = list(any)
  default     = []
}

variable "enable_deletion_protection" {
  description = "List of security groups to assign to alb"
  type        = bool
}

variable "common_tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}

# variable "lb_arn" {
#   description = "ALB arn"
#   type        = list(any)
# }

variable "security_group_rules_ingress" {
  description = "List of security group rules for ec2 default security group"
  type = list(object({
    from_port   = number,
    to_port     = number,
    protocol    = string,
    cidr_blocks = list(string),
    description = string
  }))
}

variable "security_group_rules_egress" {
  description = "List of security group egress rules for ec2 default security group"
  type = list(object({
    from_port   = number,
    to_port     = number,
    protocol    = string,
    cidr_blocks = list(string),
    description = string
  }))
}


variable "instance_ids" {
  description = "Ec2 instance id that going to register on ALB"
  type        = list(any)
}

variable "lb_tg_target_type" {
  description = "instance"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "create_tg" {
  description = "create create_lb? this is used when intial service creation and later this should set to false if the ecs service is not required a alb"
  type        = bool
  default     = true
}

variable "lb_tg_deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused."
  type        = number
  default     = "300"
}

variable "lb_tg_name" {
  type = string

}

variable "lb_tg_service_containerport" {
  description = "service_containerport"
  type        = number

}

variable "lb_tg_protocol" {
  type    = string
  default = "HTTP"
}

variable "lb_tg_health_check_enabled" {
  description = "Whether health checks are enabled."
  type        = bool
  default     = true
}

variable "lb_tg_health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target"
  type        = string
}

variable "lb_tg_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy"
  type        = number
}

variable "lb_tg_healthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy"
  type        = number
}

variable "lb_tg_health_check_matcher" {
  description = "Response codes to use when checking for a healthy responses from a target."
  type        = string
  default     = "200"
}

######## listner Rule
variable "lb_list_service_ssl_enabled" {
  description = "Whether health checks are enabled."
  type        = bool
  default     = true
}
variable "lb_list_rule_service_ssl_enabled" {
  description = "Whether health checks are enabled."
  type        = bool
  default     = false
}
variable "lb_list_rule_service_http_enabled" {
  description = "Whether health checks are enabled."
  type        = bool
  default     = true
}


variable "lb_list_create_http_listner" {
  type = string
}

variable "lb_list_ssl_policy" {
  type = string
  default     = ""
}

variable "lb_list_certificate_arn" {
  type = string
  default     = ""
}

variable "lb_list_rule_service_url" {
  type = string
  default     = ""
}

variable "lb_list_rule_http_listner_arn" {
  type = string
  default     = ""
}