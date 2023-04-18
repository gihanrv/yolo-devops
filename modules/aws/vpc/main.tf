##VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = merge(tomap({ "Name" = format("%s", var.name) }),
    var.common_tags,
  var.vpc_tags)
}

#Create Public  and Private subnets

resource "aws_subnet" "public" {
  count = min(length(var.public_subnets), length(var.azs))

  vpc_id = aws_vpc.this.id

  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(tomap({ "Name" = format("%s-${var.public_subnet_suffix}-%s",
    var.name,
    var.azs[count.index]) }),
    var.common_tags,
  var.public_subnet_tags)

}

resource "aws_subnet" "private" {
  count = min(length(var.private_subnets), length(var.azs))

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    tomap({ "Name" = format("%s-${var.private_subnet_suffix}-%s",
      var.name,
    var.azs[count.index]) }),
    var.common_tags,
  var.private_subnet_tags)


}


# Internet Gateway
resource "aws_internet_gateway" "this" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(tomap({ "Name" = format("%s", var.name) }),
    var.common_tags,
  var.igw_tags)

}

#Create Publiс and Private Route Tables

resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 2 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(tomap({ "Name" = format("%s-${var.public_subnet_suffix}", var.name) }),
    var.common_tags,
  var.public_route_table_tags)

  timeouts {
    create = "5m"
  }
}

# NAT Gateway Configuration

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  vpc = true

  tags = merge(
    tomap({ "Name" = format("%s-%s",
      var.name,
    element(var.azs, count.index)) }),
    var.common_tags,
  var.nat_eip_tags)
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = aws_eip.nat[count.index].id

  subnet_id = aws_subnet.public[count.index].id

  tags = merge(tomap({ "Name" = format("%s-%s",
    var.name,
    var.azs[count.index]) }),
    var.common_tags,
  var.nat_gateway_tags)

}


resource "aws_route_table" "private" {
  count = local.nat_gateway_count

  vpc_id = aws_vpc.this.id

  tags = merge(
    tomap({ "Name" = format("%s-${var.private_subnet_suffix}-%s",
      var.name,
    element(var.azs, count.index)) }),
    var.common_tags,
  var.private_route_table_tags)

}

resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[count.index].id

  timeouts {
    create = "5m"
  }
 depends_on = [aws_internet_gateway.this, aws_route_table.public]

}


# Route table association

resource "aws_route_table_association" "private" {
  count = min(length(var.private_subnets), length(var.azs))

  subnet_id = aws_subnet.private[count.index].id
  route_table_id = element(aws_route_table.private[*].id,
  (var.single_nat_gateway ? 0 : count.index))

depends_on = [aws_subnet.private, aws_route_table.private]
}


resource "aws_route_table_association" "public" {
  count = min(length(var.public_subnets), length(var.azs))

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id

  depends_on = [aws_subnet.public, aws_route_table.public]
}