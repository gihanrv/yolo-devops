output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.lb[*].arn
}

output "alb_id" {
  description = "Id of the ALB"
  value       = aws_lb.lb[*].id
}