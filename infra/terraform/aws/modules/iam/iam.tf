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
resource "aws_iam_role_policy_attachment" "admin_role_policy_attachment" {
  role       = aws_iam_role.AdministratorRole.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "administrator_assume_role_policy" {
  name        = "AdministratorAssumeRolePolicy"
  description = "Policy to allow assuming the AdministratorRole"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.AdministratorRole.arn
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "administrator_assume_role_policy_attachment" {
  user       = aws_iam_user.AdministratorUser.name
  policy_arn = aws_iam_policy.administrator_assume_role_policy.arn
}

resource "aws_iam_user" "WatcherUser" {
  name = "Watcher"
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
          AWS = aws_iam_user.WatcherUser.arn
        }
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "watch_role_policy_attachment" {
  role       = aws_iam_role.WatcherRole.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_policy" "watcher_assume_role_policy" {
  name        = "WatcherAssumeRolePolicy"
  description = "Policy to allow assuming the WatcherRole"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.WatcherRole.arn
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "watcher_assume_role_policy_attachment" {
  user       = aws_iam_user.WatcherUser.name
  policy_arn = aws_iam_policy.watcher_assume_role_policy.arn
}

resource "aws_iam_policy" "mfa_policy" {
  name        = "MFASetupPolicy"
  description = "Policy to allow MFA setup"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:DeactivateMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:ListMFADevices",
          "iam:ResyncMFADevice",
          "iam:ListUsers"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sts:GetSessionToken"
        ]
        Resource = "*"
        Condition = {
          "Bool" = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "administrator_mfa_policy_attachment" {
  user       = aws_iam_user.AdministratorUser.name
  policy_arn = aws_iam_policy.mfa_policy.arn
}

resource "aws_iam_user_policy_attachment" "watcher_mfa_policy_attachment" {
  user       = aws_iam_user.WatcherUser.name
  policy_arn = aws_iam_policy.mfa_policy.arn
}
