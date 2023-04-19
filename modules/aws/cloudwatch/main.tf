resource "aws_cloudwatch_log_group" "nginx_logs" {
  name = "/var/log/nginx/access.log"
}

resource "aws_cloudwatch_log_subscription_filter" "nginx_filter" {
  name            = "nginx-access-logs"
  log_group_name  = aws_cloudwatch_log_group.nginx_logs.name
  filter_pattern  = ""
  destination_arn = aws_cloudwatch_log_destination.nginx.arn
}

resource "aws_cloudwatch_log_destination" "nginx" {
  name = "nginx-logs"

  role_arn = aws_iam_role.ec2.arn

  target_arn = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:destination:${aws_cloudwatch_log_group.nginx_logs.name}:${aws_cloudwatch_log_destination.nginx.name}"
}
