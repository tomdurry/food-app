########################################
# VPC
########################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = "${var.project}-vpc-${var.environment}"
  }
}

########################################
# Subnet
########################################
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name                                          = "${var.project}-public-subnet-${count.index + 1}-${var.environment}"
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/cluster/food-app-cluster-prod" = "owned"
  }
}


resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.project}-private-subnet-${count.index + 1}-${var.environment}"
  }
}

########################################
# Internet Gateway
########################################
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-igw-${var.environment}"
  }
}

########################################
# NAT Gateway and Elastic IP
########################################
resource "aws_eip" "nat" {
  count = var.nat_gateway_count
  tags = {
    Name = "${var.project}-nat-eip-${count.index + 1}-${var.environment}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.nat_gateway_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = "${var.project}-nat-gateway-${count.index + 1}-${var.environment}"
  }
}

########################################
# Route Tables
########################################
resource "aws_route_table" "public" {
  count  = var.public_route_table_count
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.internet_route_cidr
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.project}-public-route-table-${count.index + 1}-${var.environment}"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.public_route_table_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table" "private" {
  count  = var.private_route_table_count
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-private-route-table-${count.index + 1}-${var.environment}"
  }
}

resource "aws_route" "private_nat" {
  count                  = var.private_route_table_count
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index % var.nat_gateway_count].id
}

resource "aws_route_table_association" "private" {
  count          = var.private_route_table_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

########################################
# VPC Endpoints
########################################
resource "aws_vpc_endpoint" "api_gateway" {
  vpc_id            = aws_vpc.main.id
  service_name      = var.service_endpoints.api_gateway
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.allow_http.id]
  tags = {
    Name = "${var.project}-api-gateway-endpoint-${var.environment}"
  }
}

resource "aws_vpc_endpoint" "lambda" {
  vpc_id            = aws_vpc.main.id
  service_name      = var.service_endpoints.lambda
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.allow_http.id]
  tags = {
    Name = "${var.project}-lambda-endpoint-${var.environment}"
  }
}

resource "aws_vpc_endpoint" "ecr" {
  vpc_id            = aws_vpc.main.id
  service_name      = var.service_endpoints.ecr
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.allow_http.id]
  tags = {
    Name = "${var.project}-ecr-endpoint-${var.environment}"
  }
}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id            = aws_vpc.main.id
  service_name      = var.service_endpoints.cloudwatch
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.allow_http.id]
  tags = {
    Name = "${var.project}-cloudwatch-endpoint-${var.environment}"
  }
}

resource "aws_vpc_endpoint" "rds" {
  vpc_id            = aws_vpc.main.id
  service_name      = var.service_endpoints.rds
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.allow_http.id]
  tags = {
    Name = "${var.project}-rds-endpoint-${var.environment}"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = var.service_endpoints.s3
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id
  tags = {
    Name = "${var.project}-s3-endpoint-${var.environment}"
  }
}

########################################
# Security Group
########################################
resource "aws_security_group" "allow_http" {
  vpc_id = aws_vpc.main.id
  name   = "${var.project}-vpc-security-group-${var.environment}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = {
    Name = "${var.project}-vpc-security-group-${var.environment}"
  }
}

########################################
# Parameter Store
########################################
resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project}/${var.environment}/vpc-id"
  type  = "String"
  value = aws_vpc.main.id
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}
