data "aws_ssm_parameter" "rds_endpoint" {
  name = "/prod/rds_endpoint"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_rds_access_policy" {
  statement {
    actions   = ["rds-db:connect", "ssm:GetParameter"]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_vpc_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_logs_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup"
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.create_database_lambda.function_name}:*"
    ]
  }
}
