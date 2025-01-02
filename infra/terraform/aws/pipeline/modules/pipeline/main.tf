resource "aws_iam_role" "codebuild_role" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild_admin_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = var.admin_policy_arn
}

resource "aws_codebuild_project" "food_app_deployer" {
  name         = "${var.project}-terraform-deployer"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = var.source_type
    buildspec = var.buildspec_file_path
  }

  environment {
    compute_type    = var.compute_type
    image           = var.codebuild_image
    type            = var.environment_type
    privileged_mode = true

    environment_variable {
      name  = var.environment_variable_name
      value = var.environment
    }
    environment_variable {
      name  = "DOCKER_HUB_USERNAME"
      value = "tomdurry"
    }
    environment_variable {
      name  = "DOCKER_HUB_PASSWORD"
      value = "neCQYjwQJJcft9KcBC.e"
    }
  }

  artifacts {
    type = var.artifact_type
  }
}

resource "aws_codebuild_project" "docker_build_project" {
  name         = "${var.project}-docker-build"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "infra/terraform/aws/pipeline/buildspec/buildspec-docker.yml"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = var.environment_variable_name
      value = var.environment
    }
    environment_variable {
      name  = "REPOSITORY_URI"
      value = "039725305879.dkr.ecr.ap-northeast-1.amazonaws.com/${var.project}-ecr-repository-${var.environment}"
    }
    environment_variable {
      name  = "DOCKER_HUB_USERNAME"
      value = "tomdurry"
    }
    environment_variable {
      name  = "DOCKER_HUB_PASSWORD"
      value = "neCQYjwQJJcft9KcBC.e"
    }

  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "eks_deploy_project" {
  name         = "${var.project}-eks-deployer"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "infra/terraform/aws/pipeline/buildspec/buildspec-eks-deploy.yml"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "CLUSTER_NAME"
      value = "${var.project}-cluster-${var.environment}"
    }

    environment_variable {
      name  = "KUBECONFIG_FILE"
      value = "/root/.kube/config"
    }

    privileged_mode = true
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "frontend_deploy_project" {
  name         = "${var.project}-frontend-deployer"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "infra/terraform/aws/pipeline/buildspec/buildspec-frontend-deploy.yml"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"
  }

  artifacts {
    type = "CODEPIPELINE"
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

  stage {
    name = "DockerBuild"

    action {
      name             = "DockerBuildAction"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["DockerBuildArtifact"]

      configuration = {
        ProjectName = aws_codebuild_project.docker_build_project.name
      }
    }
  }

  stage {
    name = "EKSDeploy"

    action {
      name             = "DeployToEKS"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["DockerBuildArtifact"]
      output_artifacts = ["EKSDeployArtifact"]

      configuration = {
        ProjectName = aws_codebuild_project.eks_deploy_project.name
      }
    }
  }

  stage {
    name = "FrontendDeploy"

    action {
      name            = "FrontendDeployAction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["EKSDeployArtifact"]

      configuration = {
        ProjectName = aws_codebuild_project.frontend_deploy_project.name
      }
    }
  }

}
