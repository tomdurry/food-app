data "aws_ssm_parameter" "rds_endpoint" {
  name = "/prod/rds_endpoint"
}
