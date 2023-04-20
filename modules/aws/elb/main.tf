resource "aws_security_group" "elb_sg" {
  name        = local.stack_name
  description = format("%s %s ACL", local.stack_name, var.stack)
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_rules_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }
  dynamic "egress" {
    for_each = var.security_group_rules_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = {
    Name = local.stack_name
  }
}

resource "aws_lb_target_group" "tg-service" {
  count                = var.create_tg ? 1 : 0
  name                 = var.lb_tg_name
  port                 = var.lb_tg_service_containerport
  protocol             = var.lb_tg_protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.lb_tg_deregistration_delay
  target_type          = var.lb_tg_target_type
  health_check {
    enabled             = var.lb_tg_health_check_enabled
    interval            = var.lb_tg_health_check_interval
    healthy_threshold   = var.lb_tg_healthy_threshold
    unhealthy_threshold = var.lb_tg_unhealthy_threshold
    matcher             = var.lb_tg_health_check_matcher
  }
  tags = merge(tomap({ "Name" = format("%s", var.lb_tg_name) }), var.common_tags)
}


resource "aws_lb" "lb" {
  count                      = var.create_lb ? 1 : 0
  name                       = var.lb_name
  internal                   = var.lb_internal
  load_balancer_type         = var.lb_type
  security_groups            = [aws_security_group.elb_sg.id] #var.lb_security_groups
  subnets                    = var.lb_subnets
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = merge(tomap({ "Name" = format("%s", var.lb_name) }), var.common_tags)

}

###aws_lb_listener

resource "aws_lb_listener" "lb-listner-http" {
  count             = var.lb_list_create_http_listner ? 1 : 0
  load_balancer_arn = aws_lb.lb[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg-service[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "lb-listner-https" {
  count             = var.lb_list_service_ssl_enabled ? 1 : 0
  load_balancer_arn = aws_lb.lb[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.lb_list_ssl_policy
  certificate_arn   = var.lb_list_certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.tg-service[0].arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "ec2_attachments" {
  count            = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.tg-service[0].arn
  target_id        = element(var.instance_ids, count.index)
  port             = 80 # Change this to your desired port number
}
