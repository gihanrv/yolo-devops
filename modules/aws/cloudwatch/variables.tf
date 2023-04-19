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

variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "aws_account_id" {
  description = "aws account ID"
  type        = string
}

variable "common_tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}

variable "cloudwatch_log_group_name" {
  description = "cloudwatch log greoup name"
  type        = string
  default     = null
}