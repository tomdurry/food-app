resource "aws_iam_user" "AdministratorUser" {
  name = "Administrator"
}

resource "aws_iam_role" "AdministratorRole" {
  name = "AdministratorRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.AdministratorUser.arn
        }
      }
    ]
  })
}

resource "aws_iam_policy" "adminAssumeRolePolicy" {
  name = "AdminAssumeRolePolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Resource = aws_iam_role.AdministratorRole.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "adminUserAssumeRolePolicyAttachment" {
  name       = "AdminUserAssumeRolePolicyAttachment"
  users      = [aws_iam_user.AdministratorUser.name]
  policy_arn = aws_iam_policy.adminAssumeRolePolicy.arn
}

resource "aws_iam_policy_attachment" "adminRolePolicyAttachment" {
  name       = "AdminRolePolicyAttachment"
  roles      = [aws_iam_role.AdministratorRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "mfaRequiredPolicy" {
  name = "MFARequiredPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "RequireMFA"
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "mfaRequiredPolicyAttachment" {
  name       = "MFARequiredPolicyAttachment"
  users      = [aws_iam_user.AdministratorUser.name]
  policy_arn = aws_iam_policy.mfaRequiredPolicy.arn
}

resource "aws_iam_user" "watcher" {
  name = "watcher"
}

resource "aws_iam_role" "WatcherRole" {
  name = "WatcherRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.watcher.arn
        }
      }
    ]
  })
}

resource "aws_iam_policy" "watchAssumeRolePolicy" {
  name = "WatchAssumeRolePolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Resource = aws_iam_role.WatcherRole.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "watchUserAssumeRolePolicyAttachment" {
  name       = "WatchUserAssumeRolePolicyAttachment"
  users      = [aws_iam_user.watcher.name]
  policy_arn = aws_iam_policy.watchAssumeRolePolicy.arn
}

resource "aws_iam_policy_attachment" "watchRolePolicyAttachment" {
  name       = "WatchRolePolicyAttachment"
  roles      = [aws_iam_role.WatcherRole.name]
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
