resource "aws_vpc" "checkout_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Projeto = "PDI Paulo",
    Camada  = "Network"
  }
}

resource "aws_subnet" "checkout_public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.checkout_vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    Name    = "Public Subnet ${count.index + 1}"
    Project = "PDI Paulo"
  }
}

resource "aws_subnet" "checkout_private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.checkout_vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    Name    = "Private Subnet ${count.index + 1}"
    Project = "PDI Paulo"
  }
}

resource "aws_internet_gateway" "checkout_internet_gateway" {
  vpc_id = aws_vpc.checkout_vpc.id

  tags = {
    Name    = "Checkout Gateway"
    Project = "PDI Paulo"
  }
}