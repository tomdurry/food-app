resource "aws_iam_role" "lambda_role" {
  name               = "create_database-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda-rds-access-policy-${var.environment}"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_rds_access_policy.json
}

resource "aws_iam_role_policy" "lambda_vpc_policy" {
  name   = "LambdaVpcPermissions-${var.environment}"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_vpc_policy.json
}

resource "aws_iam_role_policy" "lambda_logs_policy" {
  name   = "lambda-logs-policy-${var.environment}"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_logs_policy.json
}


resource "aws_ecr_repository" "lambda_repository" {
  name = "create_database-function-${var.environment}"
}

resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.lambda_repository.repository_url}
      docker build -t create_database-function-${var.environment} ../../modules/lambda/database-creation/src
      docker tag create_database-function-${var.environment}:latest ${aws_ecr_repository.lambda_repository.repository_url}:latest
      docker push ${aws_ecr_repository.lambda_repository.repository_url}:latest
    EOT
  }

  depends_on = [aws_ecr_repository.lambda_repository]
}

resource "aws_lambda_function" "create_database_lambda" {
  function_name = "create_database-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_repository.repository_url}:latest"
  timeout       = 30
  architectures = ["x86_64"]

  environment {
    variables = {
      DB_USERNAME  = "yukihiro"
      DB_PASSWORD  = "Yuki3769"
      RDS_ENDPOINT = data.aws_ssm_parameter.rds_endpoint.value
    }
  }

  vpc_config {
    security_group_ids = [var.lambda_sg_id]
    subnet_ids         = var.subnet_ids
  }

  depends_on = [null_resource.docker_push]
}
