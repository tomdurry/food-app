import { TerraformStack } from "cdktf";
import { Construct } from "constructs";
import { AwsProvider } from "@cdktf/provider-aws/lib/provider";
import { IamUser } from "@cdktf/provider-aws/lib/iam-user";
import { IamRole } from "@cdktf/provider-aws/lib/iam-role";
import { IamPolicy } from "@cdktf/provider-aws/lib/iam-policy";
import { IamPolicyAttachment } from "@cdktf/provider-aws/lib/iam-policy-attachment";

export class AccountStack extends TerraformStack {
  constructor(scope: Construct, id: string) {
    super(scope, id);

    new AwsProvider(this, "AWS", {
      region: "ap-northeast-1",
    });

    const adminUser = new IamUser(this, "AdministratorUser", {
      name: "Administrator",
    });

    const adminRole = new IamRole(this, "AdministratorRole", {
      name: "AdministratorRole",
      assumeRolePolicy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Action: "sts:AssumeRole",
            Effect: "Allow",
            Principal: {
              AWS: adminUser.arn,
            },
          },
        ],
      }),
    });

    const adminAssumeRolePolicy = new IamPolicy(this, "adminAssumeRolePolicy", {
      name: "AdminAssumeRolePolicy",
      policy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Action: "sts:AssumeRole",
            Effect: "Allow",
            Resource: adminRole.arn,
          },
        ],
      }),
    });

    new IamPolicyAttachment(this, "adminUserAssumeRolePolicyAttachment", {
      name: "AdminUserAssumeRolePolicyAttachment",
      users: [adminUser.name],
      policyArn: adminAssumeRolePolicy.arn,
    });

    new IamPolicyAttachment(this, "adminRolePolicyAttachment", {
      name: "AdminRolePolicyAttachment",
      roles: [adminRole.name],
      policyArn: "arn:aws:iam::aws:policy/AdministratorAccess",
    });

    const mfaRequiredPolicy = new IamPolicy(this, "mfaRequiredPolicy", {
      name: "MFARequiredPolicy",
      policy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Sid: "RequireMFA",
            Effect: "Deny",
            Action: "*",
            Resource: "*",
            Condition: {
              BoolIfExists: {
                "aws:MultiFactorAuthPresent": "false",
              },
            },
          },
        ],
      }),
    });

    new IamPolicyAttachment(this, "mfaRequiredPolicyAttachment", {
      name: "MFARequiredPolicyAttachment",
      users: [adminUser.name],
      policyArn: mfaRequiredPolicy.arn,
    });

    const watcher = new IamUser(this, "watcher", {
      name: "watcher",
    });

    const watcherRole = new IamRole(this, "WatcherRole", {
      name: "WatcherRole",
      assumeRolePolicy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Action: "sts:AssumeRole",
            Effect: "Allow",
            Principal: {
              AWS: watcher.arn,
            },
          },
        ],
      }),
    });

    const watchAssumeRolePolicy = new IamPolicy(this, "watchAssumeRolePolicy", {
      name: "WatchAssumeRolePolicy",
      policy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Action: "sts:AssumeRole",
            Effect: "Allow",
            Resource: watcherRole.arn,
          },
        ],
      }),
    });

    new IamPolicyAttachment(this, "watchUserAssumeRolePolicyAttachment", {
      name: "WatchUserAssumeRolePolicyAttachment",
      users: [watcher.name],
      policyArn: watchAssumeRolePolicy.arn,
    });

    new IamPolicyAttachment(this, "watchRolePolicyAttachment", {
      name: "WatchRolePolicyAttachment",
      roles: [watcherRole.name],
      policyArn: "arn:aws:iam::aws:policy/ReadOnlyAccess",
    });
  }
}
