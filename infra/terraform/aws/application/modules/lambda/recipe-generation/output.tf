output "lambda_invoke_arn" {
  description = "The ARN to invoke the Lambda function"
  value       = aws_lambda_function.recipe_generate_function.invoke_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.recipe_generate_function.function_name
}
