# Create the IAM policy that allows publishing to CloudWatch Logs
resource "aws_iam_policy" "logs_publish" {
  name        = "cloudwatch-logs-publish"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
  tags = merge(tomap({ "Name" = format("%s", "dev-cloudwatch-logs-publish-policy") }), var.common_tags)
}

# Create the IAM role that the EC2 instance will assume
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = merge(tomap({ "Name" = format("%s", "dev-ec2-cloudwatch-logs-publish-role") }), var.common_tags)
}

# Attach the CloudWatch Logs policy to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_logs_policy" {
  policy_arn = aws_iam_policy.logs_publish.arn
  role       = aws_iam_role.ec2_role.name
}

# Create the instance profile that includes the IAM role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"

  role = aws_iam_role.ec2_role.name
  tags = merge(tomap({ "Name" = format("%s", "dev-ec2-cloudwatch-logs-allow-profile") }), var.common_tags)
}