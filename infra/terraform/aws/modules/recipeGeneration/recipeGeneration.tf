data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "lambda-zip-${var.project}-${var.environment}"
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "mypackage.zip"
  source = "../../lambda/mypackage.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "logs:CreateLogGroup"
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/recipe_generate:*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:AbortMultipartUpload", "s3:ListMultipartUploadParts"]
        Resource = "arn:aws:s3:::lambda-zip/*"
      }
    ]
  })
}

resource "aws_lambda_function" "recipe_generate_function" {
  function_name = "recipe_generate"
  role          = aws_iam_role.lambda_role.arn
  handler       = "recipe_generate.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
  s3_key        = aws_s3_object.lambda_zip.key
  timeout       = 60
  architectures = ["arm64"]

  environment {
    variables = {
      OPENAI_API_KEY = "sk-proj-xMOUvQHg1HcwnP9OZKJUT3BlbkFJqXbDGM2Gdr23UwDlqQK0"
    }
  }
}

resource "aws_apigatewayv2_api" "recipe_generate_api" {
  name          = "recipe-generate-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST"]
    allow_headers = ["Content-Type"]
    max_age       = 3600
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.recipe_generate_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.recipe_generate_function.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "post_route" {
  api_id    = aws_apigatewayv2_api.recipe_generate_api.id
  route_key = "POST /generate-recipe"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.recipe_generate_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "api_gateway_invoke_permission" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.recipe_generate_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.recipe_generate_api.execution_arn}/*/*/generate-recipe"
}

resource "aws_ssm_parameter" "api_url_parameter" {
  name  = "/recipe-generate/api-url"
  type  = "SecureString"
  value = "${aws_apigatewayv2_api.recipe_generate_api.api_endpoint}/prod/generate-recipe"
}

