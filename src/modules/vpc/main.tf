// Cria VPC com o bloco padrão dos ips
// Necessario habilitar a resolução de DNS para serviços que necessitem como RDS
resource "aws_vpc" "vpc_pdi" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

// Cria Subnets privadas e publicas
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc_pdi.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc_pdi.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

//Criamos um internet gateway para acesso externo a vpc
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_pdi.id
}

//Criamos uma route table para direcionamento do trafego interno para internet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_pdi.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

// Saidas do Modulo
output "aws_vpc_pdi_id" {
  value = aws_vpc.vpc_pdi.id
}

output "aws_vpc_private_subntes_id" {
  value = aws_subnet.private_subnets[*].id
}

output "aws_vpc_public_subntes_id" {
  value = aws_subnet.public_subnets[*].id
}