resource "aws_vpc" "sky" {
  instance_tenancy                 = "default"
  cidr_block                       = var.cidr_block
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true

  tags = {
    Name = "${var.project}-${var.env}-vpc"
  }

}

data "aws_availability_zones" "available_zones" {}

resource "aws_subnet" "public_subnet1" {
  vpc_id                          = aws_vpc.sky.id
  cidr_block                      = var.public_subnet
  map_public_ip_on_launch         = true
  availability_zone               = data.aws_availability_zones.available_zones.names[0]
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.sky.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.project}-${var.env}-pub-sub-IPV6-expriment"
  }
}




resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.sky.id
  cidr_block              = var.private_subnet
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available_zones.names[1]


  ipv6_cidr_block                 = cidrsubnet(aws_vpc.sky.ipv6_cidr_block, 8, 2)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.project}-${var.env}-prvt-sub-IPV6-expriment"
  }
}


resource "aws_internet_gateway" "sky" {
  vpc_id = aws_vpc.sky.id

  tags = {
    Name = "${var.project}-${var.env}-igw"
  }
}


resource "aws_route_table" "sky" {
  vpc_id = aws_vpc.sky.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sky.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.sky.id
  }

  tags = {
    Name = "${var.project}-${var.env}-public-rt"
  }
}

resource "aws_route_table_association" "sky" {
  route_table_id = aws_route_table.sky.id
  subnet_id      = aws_subnet.public_subnet1.id
}


resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "main-nat-gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.sky.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sky.id
  }

  //For ipv6 you can point directly to the internet gateway or create an egress only gateway but this blocks inbound traffic by default
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.sky.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route_table.id
}
