resource "aws_cloudwatch_log_group" "nginx_logs" {
  count = length(var.cloudwatch_log_group_name)
  name  = element(var.cloudwatch_log_group_name, count.index)
  tags  = merge(tomap({ "Name" = format("%s", var.cloudwatch_log_group_name[count.index]) }), var.common_tags)
}