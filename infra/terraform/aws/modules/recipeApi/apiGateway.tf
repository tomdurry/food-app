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
