resource "aws_iam_role" "codebuild_service_role" {
  name = "CodeBuildServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_service_role_admin" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_codebuild_project" "food_app_deployer" {
  name         = "food-app-deployer"
  service_role = aws_iam_role.codebuild_service_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "infra/terraform/aws/buildspec/buildspec.yml"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "hashicorp/terraform:latest"
    type         = "LINUX_CONTAINER"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

resource "aws_s3_bucket" "food_app_artifact_bucket" {
  bucket        = "food-app-artifact-bucket"
  force_destroy = true
}

resource "aws_codestarconnections_connection" "codestar_connection" {
  name          = "GitHubConnection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "food_app_pipeline" {
  name     = "food-app-pipeline"
  role_arn = aws_iam_role.codebuild_service_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.food_app_artifact_bucket.bucket
  }

  stage {
    name = "Source"

    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.codestar_connection.arn
        FullRepositoryId = "tomdurry/food-app"
        BranchName       = "buildspec-test"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "BuildAction"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.food_app_deployer.name
      }
    }
  }
}
