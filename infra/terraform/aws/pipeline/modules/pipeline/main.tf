resource "aws_iam_role" "codebuild_role" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild_admin_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = var.admin_policy_arn
}

resource "aws_codebuild_project" "food_app_deployer" {
  name         = var.codebuild_project_name
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = var.source_type
    buildspec = var.buildspec_file_path
  }

  environment {
    compute_type = var.compute_type
    image        = var.codebuild_image
    type         = var.environment_type

    environment_variable {
      name  = var.environment_variable_name
      value = var.environment
    }
  }

  artifacts {
    type = var.artifact_type
  }
}

resource "aws_s3_bucket" "food_app_artifact_bucket" {
  bucket        = var.artifact_bucket_name
  force_destroy = var.force_destroy
}

resource "aws_codestarconnections_connection" "codestar_connection" {
  name          = var.codestar_connection_name
  provider_type = var.provider_type
}

resource "aws_codepipeline" "food_app_pipeline" {
  name     = "${var.project}-${var.pipeline_suffix}"
  role_arn = aws_iam_role.codebuild_role.arn

  artifact_store {
    type     = var.artifact_store_type
    location = aws_s3_bucket.food_app_artifact_bucket.bucket
  }

  stage {
    name = var.source_stage_name

    action {
      name             = var.source_action_name
      category         = var.source_category
      owner            = var.source_owner
      provider         = var.source_provider
      version          = var.source_version
      output_artifacts = var.source_output_artifacts

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.codestar_connection.arn
        FullRepositoryId = var.repository_name
        BranchName       = var.branch_name
      }
    }
  }

  stage {
    name = var.build_stage_name

    action {
      name             = var.build_action_name
      category         = var.build_category
      owner            = var.build_owner
      provider         = var.build_provider
      version          = var.build_version
      input_artifacts  = var.build_input_artifacts
      output_artifacts = var.build_output_artifacts

      configuration = {
        ProjectName = aws_codebuild_project.food_app_deployer.name
      }
    }
  }
}
