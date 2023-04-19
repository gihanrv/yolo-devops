resource "aws_cloudwatch_log_group" "nginx_logs" {

  name = var.cloudwatch_log_group_name

}

resource "aws_cloudwatch_log_destination" "nginx" {

  name = var.cloudwatch_log_destination_name
  role_arn = "arn:aws:iam::724866671659:role/ec2_role"
  target_arn = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:destination:${var.cloudwatch_log_group_name}:${var.cloudwatch_log_destination_name}"

}

resource "aws_cloudwatch_log_subscription_filter" "nginx_filter" {

  name            = var.cloudwatch_log_subscription_name
  log_group_name  = aws_cloudwatch_log_group.nginx_logs.name
  filter_pattern  = ""
  destination_arn = aws_cloudwatch_log_destination.nginx.arn

}