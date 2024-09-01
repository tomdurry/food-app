import { TerraformStack } from "cdktf";
import { Construct } from "constructs";
import { AwsProvider } from "@cdktf/provider-aws/lib/provider";
import { IamUser } from "@cdktf/provider-aws/lib/iam-user";
import { IamRole } from "@cdktf/provider-aws/lib/iam-role";
import { IamPolicyAttachment } from "@cdktf/provider-aws/lib/iam-policy-attachment";

export class AccountStack extends TerraformStack {
  constructor(scope: Construct, id: string) {
    super(scope, id);

    new AwsProvider(this, "AWS", {
      region: "ap-northeast-1",
    });

    const user = new IamUser(this, "AdministratorUser", {
      name: "AdministratorUser",
    });

    const role = new IamRole(this, "AdministratorRole", {
      name: "AdministratorRole",
      assumeRolePolicy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Action: "sts:AssumeRole",
            Effect: "Allow",
            Principal: {
              Service: "ec2.amazonaws.com",
            },
          },
        ],
      }),
    });

    new IamPolicyAttachment(this, "userPolicyAttachment", {
      name: "userPolicyAttachment",
      users: [user.name],
      policyArn: "arn:aws:iam::aws:policy/AdministratorAccess",
    });

    new IamPolicyAttachment(this, "rolePolicyAttachment", {
      name: "rolePolicyAttachment",
      roles: [role.name],
      policyArn: "arn:aws:iam::aws:policy/AdministratorAccess",
    });
  }
}
