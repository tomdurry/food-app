
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnets" {
  description = "List of IDs for public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of IDs for private subnets"
  value       = aws_subnet.private[*].id
}
