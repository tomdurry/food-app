resource "aws_iam_role" "lambda_role" {
  name               = var.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  tags = {
    Project     = var.project
    Environment = var.environment
    Role        = "Lambda Role"
  }
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_ecr_repository" "lambda_repository" {
  name = "recipe-generate-function-${var.environment}"

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "ECR Repository"
  }
}

resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.lambda_repository.repository_url}
      docker buildx build --platform linux/arm64,linux/amd64 -t recipe-generate-function-${var.environment} ../../modules/lambda/recipe-generation/src
      docker tag recipe-generate-function-${var.environment}:latest ${aws_ecr_repository.lambda_repository.repository_url}:latest
      docker push ${aws_ecr_repository.lambda_repository.repository_url}:latest
    EOT
  }
  triggers = {
    build_time = timestamp()
  }
  depends_on = [aws_ecr_repository.lambda_repository]
}


resource "aws_lambda_function" "recipe_generate_function" {
  function_name = "recipe-generate-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_repository.repository_url}:latest"
  timeout       = var.lambda_timeout
  architectures = var.lambda_architectures
  environment {
    variables = {
      OPENAI_API_KEY = data.aws_ssm_parameter.openai_api_key.value
    }
  }
  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "Lambda Function"
  }

  depends_on = [null_resource.docker_push]
}
