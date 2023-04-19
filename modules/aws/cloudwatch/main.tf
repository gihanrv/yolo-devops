resource "aws_cloudwatch_log_group" "nginx_logs" {

  name = var.cloudwatch_log_group_name
  tags = merge(tomap({ "Name" = format("%s",var.cloudwatch_log_group_name ) }), var.common_tags)
}