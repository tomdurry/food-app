variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets"
  type        = list(string)
}

variable "eks_cluster_sg_id" {
  description = "The Security Group ID of the EKS cluster."
  type        = string
}

variable "lambda_sg_from_port" {
  description = "The starting port for the Lambda security group."
  type        = number
}

variable "lambda_sg_to_port" {
  description = "The ending port for the Lambda security group."
  type        = number
}

variable "lambda_sg_protocol" {
  description = "The protocol for the Lambda security group."
  type        = string
}

variable "lambda_sg_cidr_blocks" {
  description = "The CIDR blocks allowed for the Lambda security group."
  type        = list(string)
}

variable "rds_sg_from_port" {
  description = "The starting port for the RDS security group."
  type        = number
}

variable "rds_sg_to_port" {
  description = "The ending port for the RDS security group."
  type        = number
}

variable "rds_sg_protocol" {
  description = "The protocol for the RDS security group."
  type        = string
}

variable "rds_sg_cidr_blocks" {
  description = "The CIDR blocks allowed for the RDS security group."
  type        = list(string)
}

variable "allocated_storage" {
  description = "The amount of storage allocated to the RDS instance in GB."
  type        = number
}

variable "engine" {
  description = "The database engine to use."
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine."
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance."
  type        = string
}

variable "parameter_group_name" {
  description = "The parameter group name for the RDS instance."
  type        = string
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot on instance deletion."
  type        = bool
}

variable "publicly_accessible" {
  description = "Whether the RDS instance should be publicly accessible."
  type        = bool
}

variable "lambda_to_rds_type" {
  description = "Type of the connection between Lambda and RDS."
  type        = string
}

variable "lambda_to_rds_from_port" {
  description = "The starting port for the Lambda to RDS connection."
  type        = number
}

variable "lambda_to_rds_to_port" {
  description = "The ending port for the Lambda to RDS connection."
  type        = number
}

variable "lambda_to_rds_protocol" {
  description = "Protocol used for Lambda to RDS connection."
  type        = string
}

variable "eks_to_rds_rds_type" {
  description = "Type of the connection between EKS and RDS."
  type        = string
}

variable "eks_to_rds_from_port" {
  description = "The starting port for the EKS to RDS connection."
  type        = number
}

variable "eks_to_rds_to_port" {
  description = "The ending port for the EKS to RDS connection."
  type        = number
}

variable "eks_to_rds_protocol" {
  description = "Protocol used for EKS to RDS connection."
  type        = string
}

