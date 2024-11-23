output "lambda_sg_id" {
  value       = aws_security_group.lambda_sg.id
  description = "The ID of the Lambda security group"
}

output "eks_sg_id" {
  value       = aws_security_group.eks_sg.id
  description = "The ID of the Lambda security group"
}
