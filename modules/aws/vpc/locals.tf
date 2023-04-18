locals {
  max_subnet_length = length(var.private_subnets)

  nat_gateway_count = var.single_nat_gateway ? 1 : min(length(var.azs), local.max_subnet_length)


}