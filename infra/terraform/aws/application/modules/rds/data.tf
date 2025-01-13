data "aws_ssm_parameter" "db_username" {
  name = "/prod/db_username"
}

data "aws_ssm_parameter" "db_password" {
  name            = "/prod/db_password"
  with_decryption = true
}
