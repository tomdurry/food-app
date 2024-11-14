resource "aws_iam_role" "lambda_role" {
  name = "lambda-rds-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-rds-access-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "rds-db:connect",
          "ssm:GetParameter"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_security_group" "lambda_sg" {
  name   = "lambda-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_ecr_repository" "lambda_repository" {
  name = "create_database-function"
}

resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.lambda_repository.repository_url}
      docker build -t create_database-function ./src
      docker tag create_database-function:latest ${aws_ecr_repository.lambda_repository.repository_url}:latest
      docker push ${aws_ecr_repository.lambda_repository.repository_url}:latest
    EOT
  }

  depends_on = [aws_ecr_repository.lambda_repository]
}

resource "aws_lambda_function" "create_database_lambda" {
  function_name = "CreateDatabaseLambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_repository.repository_url}:latest"
  timeout       = 30
  architectures = "arm64"

  environment {
    variables = {
      DB_USERNAME  = "yukihiro"
      DB_PASSWORD  = "Yuki3769"
      RDS_ENDPOINT = data.aws_ssm_parameter.rds_endpoint.value
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.lambda_sg.id]
    subnet_ids         = var.subnet_ids
  }

  depends_on = [null_resource.docker_push]
}
