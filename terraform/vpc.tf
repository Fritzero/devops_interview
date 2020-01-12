locals {
  cidr = "10.34.0.0/16"

  private_subnets = [
    {
      name = "private_subnet_az_a"
      cidr = "10.34.1.0/24"
      az   = "${data.aws_region.current.name}a"
    },
    {
      name = "private_subnet_az_b"
      cidr = "10.34.2.0/24"
      az   = "${data.aws_region.current.name}b"
    },
  ]

  public_subnets = [
    {
      name = "public_subnet_az_a"
      cidr = "10.34.11.0/24"
      az   = "${data.aws_region.current.name}a"
    },
    {
      name = "public_subnet_az_b"
      cidr = "10.34.12.0/24"
      az   = "${data.aws_region.current.name}b"
    },
  ]
}

resource "aws_vpc" "vpc" {
  cidr_block           = local.cidr
  enable_dns_hostnames = true

  tags = {
    Name = "devops-interview"
  }
}

resource "aws_subnet" "private_subnets" {
  cidr_block        = each.value.cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }

  for_each = { for subnet in local.private_subnets :
    subnet.name => subnet
  }
}

resource "aws_subnet" "public_subnets" {
  cidr_block        = each.value.cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }

  for_each = { for subnet in local.public_subnets :
    subnet.name => subnet
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "devops-interview-IG"
  }
}

# Note that the default route, mapping the VPC's CIDR block to "local",
# is created implicitly and cannot be specified.
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "devops-interview-public-routes"
  }
}


# Note that the default route, mapping the VPC's CIDR block to "local",
# is created implicitly and cannot be specified.
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "devops-interview-private-routes"
  }
}

resource "aws_route_table_association" "private_subnets" {
  for_each = aws_subnet.private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "public_subnets" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}
