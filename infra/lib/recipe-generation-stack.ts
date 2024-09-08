import { TerraformStack } from "cdktf";
import { Construct } from "constructs";
import { AwsProvider } from "@cdktf/provider-aws/lib/provider";
import { DataAwsRegion } from "@cdktf/provider-aws/lib/data-aws-region";
import { DataAwsCallerIdentity } from "@cdktf/provider-aws/lib/data-aws-caller-identity";
import { LambdaFunction } from "@cdktf/provider-aws/lib/lambda-function";
import { S3Bucket } from "@cdktf/provider-aws/lib/s3-bucket";
import { S3Object } from "@cdktf/provider-aws/lib/s3-object";
import { IamRole } from "@cdktf/provider-aws/lib/iam-role";
import { IamRolePolicy } from "@cdktf/provider-aws/lib/iam-role-policy";
import { join } from "path";
import { Apigatewayv2Api } from "@cdktf/provider-aws/lib/apigatewayv2-api";
import { Apigatewayv2Integration } from "@cdktf/provider-aws/lib/apigatewayv2-integration";
import { Apigatewayv2Route } from "@cdktf/provider-aws/lib/apigatewayv2-route";
import { Apigatewayv2Stage } from "@cdktf/provider-aws/lib/apigatewayv2-stage";
import { LambdaPermission } from "@cdktf/provider-aws/lib/lambda-permission";
import { SsmParameter } from "@cdktf/provider-aws/lib/ssm-parameter";

export class RecipeGenerationStack extends TerraformStack {
  constructor(scope: Construct, id: string) {
    super(scope, id);

    new AwsProvider(this, "AWS", {
      region: "ap-northeast-1",
    });

    const region = new DataAwsRegion(this, "current-region");

    const callerIdentity = new DataAwsCallerIdentity(
      this,
      "current-caller-identity"
    );

    const lambdaBucket = new S3Bucket(this, "LambdaBucket", {
      bucket: `lambda-zip-${new Date()
        .toISOString()
        .replace(/[:\-T.]/g, "")
        .substring(0, 14)}`,
    });

    const lambdaZip = new S3Object(this, "LambdaZip", {
      bucket: lambdaBucket.bucket,
      key: "mypackage.zip",
      source: join(__dirname, "lambda/mypackage.zip"),
    });

    const role = new IamRole(this, "LambdaRole", {
      name: "lambda-role",
      assumeRolePolicy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Effect: "Allow",
            Principal: {
              Service: "lambda.amazonaws.com",
            },
            Action: "sts:AssumeRole",
          },
        ],
      }),
    });

    new IamRolePolicy(this, "LambdaRolePolicy", {
      role: role.name,
      policy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Effect: "Allow",
            Action: "logs:CreateLogGroup",
            Resource: `arn:aws:logs:${region.name}:${callerIdentity.accountId}:*`,
          },
          {
            Effect: "Allow",
            Action: ["logs:CreateLogStream", "logs:PutLogEvents"],
            Resource: [
              `arn:aws:logs:${region.name}:${callerIdentity.accountId}:log-group:/aws/lambda/recipe_generate:*`,
            ],
          },
          {
            Effect: "Allow",
            Action: [
              "s3:PutObject",
              "s3:AbortMultipartUpload",
              "s3:ListMultipartUploadParts",
            ],
            Resource: "arn:aws:s3:::lambda-zip/*",
          },
        ],
      }),
    });

    const RecipeGenerateFunction = new LambdaFunction(
      this,
      "RecipeGenerateFunction",
      {
        functionName: "recipe_generate",
        runtime: "python3.12",
        handler: "recipe_generate.lambda_handler",
        role: role.arn,
        s3Bucket: lambdaBucket.bucket,
        s3Key: lambdaZip.key,
        timeout: 60,
        architectures: ["arm64"],
        environment: {
          variables: {
            OPENAI_API_KEY:
              "sk-proj-xMOUvQHg1HcwnP9OZKJUT3BlbkFJqXbDGM2Gdr23UwDlqQK0",
          },
        },
      }
    );

    const api = new Apigatewayv2Api(this, "RecipeGenerateApi", {
      name: "recipe-generate-api",
      protocolType: "HTTP",
      corsConfiguration: {
        allowOrigins: ["*"],
        allowMethods: ["POST"],
        allowHeaders: ["Content-Type"],
        exposeHeaders: [],
        maxAge: 3600,
      },
    });

    const lambdaIntegration = new Apigatewayv2Integration(
      this,
      "LambdaIntegration",
      {
        apiId: api.id,
        integrationType: "AWS_PROXY",
        integrationUri: RecipeGenerateFunction.invokeArn,
        payloadFormatVersion: "2.0",
      }
    );

    new Apigatewayv2Route(this, "PostRoute", {
      apiId: api.id,
      routeKey: "POST /generate-recipe",
      target: `integrations/${lambdaIntegration.id}`,
    });

    new Apigatewayv2Stage(this, "ApiStage", {
      apiId: api.id,
      name: "$default",
      autoDeploy: true,
    });

    new LambdaPermission(this, "ApiGatewayInvokePermission", {
      action: "lambda:InvokeFunction",
      functionName: RecipeGenerateFunction.functionName,
      principal: "apigateway.amazonaws.com",
      sourceArn: `${api.executionArn}/*/*/generate-recipe`,
    });

    new SsmParameter(this, "ApiUrlParameter", {
      name: "/recipe-generate/api-url",
      type: "SecureString",
      value: `${api.apiEndpoint}/prod/generate-recipe`,
    });
  }
}
