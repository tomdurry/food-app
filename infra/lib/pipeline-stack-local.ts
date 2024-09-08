import { TerraformStack } from "cdktf";
import { Construct } from "constructs";
import { AwsProvider } from "@cdktf/provider-aws/lib/provider";
import { CodebuildProject } from "@cdktf/provider-aws/lib/codebuild-project";
import { IamRole } from "@cdktf/provider-aws/lib/iam-role";
import { IamRolePolicyAttachment } from "@cdktf/provider-aws/lib/iam-role-policy-attachment";
import { Codepipeline } from "@cdktf/provider-aws/lib/codepipeline";
import { S3Bucket } from "@cdktf/provider-aws/lib/s3-bucket";
import { CodestarconnectionsConnection } from "@cdktf/provider-aws/lib/codestarconnections-connection";

export class PipelineStack extends TerraformStack {
  constructor(scope: Construct, id: string) {
    super(scope, id);

    new AwsProvider(this, "AWS", {
      region: "ap-northeast-1",
    });

    const codeBuildRole = new IamRole(this, "CodeBuildServiceRole", {
      name: "CodeBuildServiceRole",
      assumeRolePolicy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Effect: "Allow",
            Principal: {
              Service: "codebuild.amazonaws.com",
            },
            Action: "sts:AssumeRole",
          },
          {
            Effect: "Allow",
            Principal: {
              Service: "codepipeline.amazonaws.com",
            },
            Action: "sts:AssumeRole",
          },
        ],
      }),
    });

    new IamRolePolicyAttachment(
      this,
      "CodeBuildServiceRoleAdministratorAccess",
      {
        role: codeBuildRole.name,
        policyArn: "arn:aws:iam::aws:policy/AdministratorAccess",
      }
    );

    const codeBuildProject = new CodebuildProject(this, "FoodAppDeployer", {
      name: "food-app-deployer",
      serviceRole: codeBuildRole.arn,
      source: {
        type: "CODEPIPELINE",
        buildspec: "infra/lib/buildspec/buildspec.yml",
      },
      environment: {
        computeType: "BUILD_GENERAL1_SMALL",
        image: "hashicorp/terraform:latest",
        type: "LINUX_CONTAINER",
      },
      artifacts: {
        type: "CODEPIPELINE",
      },
    });

    const pipelineArtifactBucket = new S3Bucket(this, "FoodAppArtifactBucket", {
      bucket: "food-app-artifact-bucket",
      forceDestroy: true,
    });

    const codeStarConnection = new CodestarconnectionsConnection(
      this,
      "CodeStarConnection",
      {
        name: "GitHubConnection",
        providerType: "GitHub",
      }
    );

    new Codepipeline(this, "FoodAppPipeline", {
      name: "food-app-pipeline",
      roleArn: codeBuildRole.arn,
      artifactStore: [
        {
          type: "S3",
          location: pipelineArtifactBucket.bucket,
        },
      ],
      stage: [
        {
          name: "Source",
          action: [
            {
              name: "SourceAction",
              category: "Source",
              owner: "AWS",
              provider: "CodeStarSourceConnection",
              version: "1",
              outputArtifacts: ["source_output"],
              configuration: {
                ConnectionArn: codeStarConnection.arn,
                FullRepositoryId: "tomdurry/food-app",
                BranchName: "aws_ci_cd_#100",
              },
            },
          ],
        },
        {
          name: "Build",
          action: [
            {
              name: "BuildAction",
              category: "Build",
              owner: "AWS",
              provider: "CodeBuild",
              version: "1",
              inputArtifacts: ["source_output"],
              outputArtifacts: ["build_output"],
              configuration: {
                ProjectName: codeBuildProject.name,
              },
            },
          ],
        },
      ],
    });
  }
}
