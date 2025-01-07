resource "aws_apigatewayv2_api" "recipe_generate_api" {
  name          = var.api_name
  protocol_type = var.protocol_type

  cors_configuration {
    allow_origins = var.cors_allow_origins
    allow_methods = var.cors_allow_methods
    allow_headers = var.cors_allow_headers
    max_age       = var.cors_max_age
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "API Gateway"
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.recipe_generate_api.id
  integration_type       = var.integration_type
  integration_uri        = var.integration_uri
  payload_format_version = var.payload_format_version
}

resource "aws_apigatewayv2_route" "post_route" {
  api_id    = aws_apigatewayv2_api.recipe_generate_api.id
  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.recipe_generate_api.id
  name        = var.stage_name
  auto_deploy = var.auto_deploy

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "API Gateway Stage"
  }
}

resource "aws_lambda_permission" "api_gateway_invoke_permission" {
  statement_id  = var.statement_id
  action        = var.lambda_action
  function_name = var.function_name
  principal     = var.principal
  source_arn    = "${aws_apigatewayv2_api.recipe_generate_api.execution_arn}/*/*/generate-recipe"
}

resource "aws_ssm_parameter" "api_url_parameter" {
  name  = var.ssm_parameter_name
  type  = var.ssm_parameter_type
  value = "${aws_apigatewayv2_api.recipe_generate_api.api_endpoint}/${var.environment}/generate-recipe"

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "SSM Parameter"
  }
}
