
variable "common_tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}


variable "name" {
  description = "VPC name"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  default     = "pub"
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  default     = "priv"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(any)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(any)
  default     = []
}


variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(any)
  default     = []
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  default     = true
}

variable "enable_nat_gateway" {
  description = "Enable to provision a NAT Gateway per private subnet"
  default     = false
}

variable "single_nat_gateway" {
  description = "Enable to provision a single shared NAT Gateway"
  default     = false
}

variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = list(any)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  default     = true
}

variable "public_subnet_tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}

variable "private_subnet_tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}

variable "vpc_tags" {
  type = map(string)

}

variable "nat_eip_tags" {
  type = map(string)

}


variable "private_route_table_tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}

variable "public_route_table_tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}

variable "igw_tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}

variable "nat_gateway_tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}

}

