resource "aws_security_group" "lambda_sg" {
  name   = "lambda-create_database-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_security_group_rule" "lambda_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda_sg.id
  security_group_id        = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "eks_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = var.eks_cluster_sg_id
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t4g.micro"
  username               = "yukihiro"
  password               = "Yuki3769"
  parameter_group_name   = "default.postgres16"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.id
}

resource "aws_db_subnet_group" "rds_subnet" {
  name        = "rds-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Subnet group for RDS instance"
}

resource "aws_ssm_parameter" "rds_endpoint" {
  name        = "/${var.environment}/rds_endpoint"
  type        = "String"
  value       = aws_db_instance.postgres.address
  description = "RDS endpoint for PostgreSQL instance in production"
}
