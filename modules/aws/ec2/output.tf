output "ec2_availability_zone" {
  description = "List of availability zones of instances"
  value       = aws_instance.instance.*.availability_zone
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.instance.*.id
}

output "ec2_instance_public_ip" {
  description = "EC2 instance ID"
  value       = aws_instance.instance.*.public_ip
}


output "ec2_instance_private_ip" {
  description = "EC2 instance ID"
  value       = aws_instance.instance.*.private_ip
}
