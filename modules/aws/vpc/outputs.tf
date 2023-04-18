output "vpc_id" {
  description = "The ID of the VPC"
  value       = element(concat(aws_vpc.this[*].id, tolist([""])), 0)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = element(concat(aws_vpc.this[*].cidr_block, tolist([""])), 0)
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = element(concat(aws_vpc.this[*].default_security_group_id, tolist([""])), 0)
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = element(concat(aws_vpc.this[*].default_network_acl_id, tolist([""])), 0)
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = element(concat(aws_vpc.this[*].default_route_table_id, tolist([""])), 0)
}

output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = element(concat(aws_vpc.this[*].instance_tenancy, tolist([""])), 0)
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = element(concat(aws_vpc.this[*].enable_dns_support, tolist([""])), 0)
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = element(concat(aws_vpc.this[*].enable_dns_hostnames, tolist([""])), 0)
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = element(concat(aws_vpc.this[*].main_route_table_id, tolist([""])), 0)
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = concat(aws_subnet.private[*].id)
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = concat(aws_subnet.private[*].cidr_block)
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = concat(aws_subnet.public[*].id)
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = concat(aws_subnet.public[*].cidr_block)
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = concat(aws_route_table.public[*].id)
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = concat(aws_route_table.private[*].id)
}

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = concat(aws_eip.nat[*].id)
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = concat(aws_eip.nat[*].public_ip)
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = concat(aws_nat_gateway.this[*].id)
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = element(concat(aws_internet_gateway.this[*].id, tolist([""])), 0)
}
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.azs
}