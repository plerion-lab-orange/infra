# Plerion BadLab (Auto-deploy)

This repo builds a Lambda **layer** with intentionally vulnerable packages from a **lock file**
and auto-deploys a CloudFormation stack on every push to `main`.

## One-time AWS setup
1. Create an S3 artifact bucket (same region as the stack, e.g., `ap-southeast-2`).
2. Create the GitHub OIDC provider in IAM (`token.actions.githubusercontent.com`).
3. Create role `GitHubActionsBadlabDeployer` trusted by that provider, attach `AdministratorAccess`.

## GitHub Actions → Variables (not secrets)
- `AWS_REGION` = `ap-southeast-2`
- `AWS_ROLE_TO_ASSUME` = `arn:aws:iam::<ACCOUNT_ID>:role/GitHubActionsBadlabDeployer`
- `ARTIFACT_BUCKET` = your artifact bucket name
- `STACK_NAME` = `plerion-badlab`
- `PUBLIC_BUCKET_NAME` = a globally-unique S3 name you’ll keep stable

## Deploy
Push to `main` (or run the workflow manually). The workflow:
1) Builds the vulnerable layer from `layers/vuln-py39/requirements.lock.txt`
2) Uploads it to `s3://$ARTIFACT_BUCKET/layers/vuln-py39-layer.zip`
3) Deploys `plerion-badlab.yaml` with `CAPABILITY_NAMED_IAM`

After deploy, check **CloudFormation → Stacks → plerion-badlab → Outputs** for endpoints and demo creds.

### Clean up
Delete the stack. If the public S3 bucket prevents deletion, empty it first.
