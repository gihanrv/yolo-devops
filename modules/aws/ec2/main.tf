resource "aws_security_group" "ec2_sg" {
  count       = var.create_sg_group ? 1 : 0
  name        = local.stack_name
  description = format("%s %s ACL", local.stack_name, var.stack)
  vpc_id      = data.aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.security_group_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.stack_name
  }
}

resource "aws_instance" "instance" {
  count                  = length(var.instance_names)
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = length(var.security_group_ids) != 0 ? var.security_group_ids : [aws_security_group.ec2_sg[0].id]
  subnet_id              = element(var.subnet_ids, count.index)

  user_data = base64encode(templatefile("${path.module}/conf/${local.stack_name}.tpl", { git_repo_url = var.git_repo_url,
    git_repo_name        = var.git_repo_name,
    git_branch           = var.git_branch,
    server_name          = element(var.instance_names, count.index),
    stack                = var.stack,
    cloudwatch_log_group = var.cloudwatch_log_group,
    log_file_path        = var.cloudwatch_log_file_path
  }))

  iam_instance_profile    = aws_iam_instance_profile.ec2_instance_profile.name
  disable_api_termination = var.disable_api_termination
  volume_tags             = merge(tomap({ "Name" = format("%s", var.instance_names[count.index]) }), var.common_tags)
  tags                    = merge(tomap({ "Name" = format("%s", var.instance_names[count.index]) }), var.common_tags)

  root_block_device {
    volume_size           = var.root_ebs_size
    volume_type           = var.root_ebs_vol_type
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }


}