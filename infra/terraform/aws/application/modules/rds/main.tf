resource "aws_security_group" "lambda_sg" {
  name   = "lambda-create_database-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = var.lambda_sg_from_port
    to_port     = var.lambda_sg_to_port
    protocol    = var.lambda_sg_protocol
    cidr_blocks = var.lambda_sg_cidr_blocks
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "Lambda Security Group"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = var.rds_sg_from_port
    to_port     = var.rds_sg_to_port
    protocol    = var.rds_sg_protocol
    cidr_blocks = var.rds_sg_cidr_blocks
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "RDS Security Group"
    Name        = "rds-sg"
  }
}

resource "aws_security_group_rule" "lambda_to_rds" {
  type                     = var.lambda_to_rds_type
  from_port                = var.lambda_to_rds_from_port
  to_port                  = var.lambda_to_rds_to_port
  protocol                 = var.lambda_to_rds_protocol
  source_security_group_id = aws_security_group.lambda_sg.id
  security_group_id        = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "eks_to_rds" {
  type                     = var.eks_to_rds_rds_type
  from_port                = var.eks_to_rds_from_port
  to_port                  = var.eks_to_rds_to_port
  protocol                 = var.eks_to_rds_protocol
  source_security_group_id = var.eks_cluster_sg_id
  security_group_id        = aws_security_group.rds_sg.id
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = data.aws_ssm_parameter.db_username.value
  password               = data.aws_ssm_parameter.db_password.value
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.id

  multi_az = true

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "PostgreSQL DB Instance"
  }
}

resource "aws_db_subnet_group" "rds_subnet" {
  name        = "rds-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Subnet group for RDS instance"

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "RDS Subnet Group"
  }
}

resource "aws_ssm_parameter" "rds_endpoint" {
  name        = "/${var.environment}/rds_endpoint"
  type        = "String"
  value       = aws_db_instance.postgres.address
  description = "RDS endpoint for PostgreSQL instance in production"

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "RDS Endpoint Parameter"
  }
}
