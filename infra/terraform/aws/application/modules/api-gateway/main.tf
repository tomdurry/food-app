resource "aws_api_gateway_rest_api" "recipe_generate_api" {
  name        = var.api_name
  description = "Recipe Generate API using REST API Gateway"

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "API Gateway"
  }
}

resource "aws_api_gateway_resource" "recipe_generate_resource" {
  rest_api_id = aws_api_gateway_rest_api.recipe_generate_api.id
  parent_id   = aws_api_gateway_rest_api.recipe_generate_api.root_resource_id
  path_part   = "generate-recipe"
}

resource "aws_api_gateway_method" "recipe_generate_method" {
  rest_api_id   = aws_api_gateway_rest_api.recipe_generate_api.id
  resource_id   = aws_api_gateway_resource.recipe_generate_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.recipe_generate_api.id
  resource_id             = aws_api_gateway_resource.recipe_generate_resource.id
  http_method             = aws_api_gateway_method.recipe_generate_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.integration_uri
  timeout_milliseconds    = 60000
}

resource "aws_api_gateway_integration_response" "cors_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.recipe_generate_api.id
  resource_id = aws_api_gateway_resource.recipe_generate_resource.id
  http_method = aws_api_gateway_method.recipe_generate_method.http_method
  status_code = "200"

  response_parameters = {
    "integration.response.header.Access-Control-Allow-Origin"  = "'*'"
    "integration.response.header.Access-Control-Allow-Methods" = "'POST, OPTIONS'"
    "integration.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }

  depends_on = [aws_api_gateway_integration.lambda_integration]
}


resource "aws_api_gateway_deployment" "recipe_generate_deployment" {
  rest_api_id = aws_api_gateway_rest_api.recipe_generate_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.recipe_generate_api))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.recipe_generate_method,
    aws_api_gateway_integration.lambda_integration
  ]
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.recipe_generate_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.recipe_generate_api.id
  stage_name    = var.stage_name
}

resource "aws_lambda_permission" "api_gateway_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.recipe_generate_api.execution_arn}/*/*"
}

resource "aws_ssm_parameter" "api_url_parameter" {
  name  = var.ssm_parameter_name
  type  = var.ssm_parameter_type
  value = "https://${aws_api_gateway_rest_api.recipe_generate_api.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${aws_api_gateway_stage.api_stage.stage_name}/generate-recipe"

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "SSM Parameter"
  }
}
