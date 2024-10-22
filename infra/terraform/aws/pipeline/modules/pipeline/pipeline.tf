# ステージ1: IAMロールとポリシーの作成
resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildRole"

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

resource "aws_iam_role_policy_attachment" "codebuild_admin_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ステージ2: S3バケットとCodeStar Connectionの作成
resource "aws_s3_bucket" "food_app_artifact_bucket" {
  bucket        = var.artifact_bucket_name
  force_destroy = true
}

resource "aws_codestarconnections_connection" "codestar_connection" {
  name          = var.codestar_connection_name
  provider_type = "GitHub"
}

# ステージ3: CodeBuildプロジェクトの作成 (Terraform, Docker, and Deployment)
resource "aws_codebuild_project" "terraform_deployer" {
  name         = "${var.project_name}-terraform-deployer"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = var.terraform_buildspec_file_path
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = var.codebuild_image
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "ENV"
      value = var.environment
    }
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "docker_deployer" {
  name         = "${var.project_name}-docker-deployer"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = var.docker_buildspec_file_path
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = var.codebuild_image
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "ECR_REPO"
      value = aws_ecr_repository.app.repository_url
    }
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "eks_deployer" {
  name         = "${var.project_name}-eks-deployer"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = var.eks_buildspec_file_path
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = var.codebuild_image
    type         = "LINUX_CONTAINER"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

# ステージ4: CodePipelineの作成
resource "aws_codepipeline" "food_app_pipeline" {
  name     = "${var.project_name}-pipeline"
  role_arn = aws_iam_role.codebuild_role.arn

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
        FullRepositoryId = var.repository_name
        BranchName       = var.branch_name
      }
    }
  }

  stage {
    name = "Terraform"

    action {
      name             = "TerraformAction"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["terraform_output"]

      configuration = {
        ProjectName = aws_codebuild_project.terraform_deployer.name
      }
    }
  }

  stage {
    name = "DockerBuildPush"

    action {
      name             = "DockerAction"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["docker_output"]

      configuration = {
        ProjectName = aws_codebuild_project.docker_deployer.name
      }
    }
  }

  stage {
    name = "Deployment"

    action {
      name            = "DeployAction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["docker_output"]
      configuration = {
        ProjectName = aws_codebuild_project.eks_deployer.name
      }
    }
  }
}
