resource "aws_iam_user" "AdministratorUser" {
  name = var.administrator_user_name
}

resource "aws_iam_role" "AdministratorRole" {
  name               = var.administrator_role_name
  assume_role_policy = data.aws_iam_policy_document.administrator_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "admin_role_policy_attachment" {
  role       = aws_iam_role.AdministratorRole.name
  policy_arn = var.administrator_policy_arn
}

resource "aws_iam_policy" "administrator_assume_role_policy" {
  name        = var.administrator_assume_role_policy_name
  description = "Policy to allow assuming the AdministratorRole"
  policy      = data.aws_iam_policy_document.administrator_assume_role_policy_document.json
}

resource "aws_iam_user_policy_attachment" "administrator_assume_role_policy_attachment" {
  user       = aws_iam_user.AdministratorUser.name
  policy_arn = aws_iam_policy.administrator_assume_role_policy.arn
}

resource "aws_iam_user" "WatcherUser" {
  name = var.watcher_user_name
}

resource "aws_iam_role" "WatcherRole" {
  name               = var.watcher_role_name
  assume_role_policy = data.aws_iam_policy_document.watcher_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "watcher_role_policy_attachment" {
  role       = aws_iam_role.WatcherRole.name
  policy_arn = var.watcher_policy_arn
}

resource "aws_iam_policy" "watcher_assume_role_policy" {
  name        = var.watcher_assume_role_policy_name
  description = "Policy to allow assuming the WatcherRole"
  policy      = data.aws_iam_policy_document.watcher_assume_role_policy_document.json
}

resource "aws_iam_user_policy_attachment" "watcher_assume_role_policy_attachment" {
  user       = aws_iam_user.WatcherUser.name
  policy_arn = aws_iam_policy.watcher_assume_role_policy.arn
}

resource "aws_iam_policy" "mfa_policy" {
  name        = var.mfa_policy_name
  description = "Policy to allow MFA setup"
  policy      = data.aws_iam_policy_document.mfa_policy.json
}

resource "aws_iam_user_policy_attachment" "administrator_mfa_policy_attachment" {
  user       = aws_iam_user.AdministratorUser.name
  policy_arn = aws_iam_policy.mfa_policy.arn
}

resource "aws_iam_user_policy_attachment" "watcher_mfa_policy_attachment" {
  user       = aws_iam_user.WatcherUser.name
  policy_arn = aws_iam_policy.mfa_policy.arn
}
