# Plerion BadLab (Auto-deploy)

Insecure-by-design lab that auto-deploys a CloudFormation stack on each push to `main`.

## What it provisions (intentionally bad)
- Public VPC resources and wide-open security groups
- RDS PostgreSQL exposed publicly with both good and bad SGs
- Public S3 website bucket with permissive bucket policy
- SQS queue with an allow-all resource policy
- Lambda with older runtime, admin role, env/code “secrets,” and public Function URL
- API Gateway with public and custom-authorized routes
- IAM anti-patterns (admin roles, wide policies, users with access keys)
- Publicly readable Secrets Manager secret

See `plerion-badlab.yaml` for the exact resources.

## CI/CD
- Workflow: `.github/workflows/deploy-badlab.yml`
- Triggers: push to `main` or manual run
- AWS auth: uses static credentials from GitHub Secrets
- Region: `ap-southeast-2`
- Stack name: `pd-infra`

## Deploy
Push to `main` or run the workflow manually. It deploys `plerion-badlab.yaml` with required IAM capabilities.

## Using the demo
- CloudFormation outputs include:
  - Public S3 bucket name
  - Lambda Function URL
  - API endpoints: `/public` and `/secure`
  - IAM access keys for demo users and a break-glass user
  - Escalation admin role ARN
- API Gateway quick check:
  - Public: GET `.../prod/public`
  - Secure: GET `.../prod/secure` with header `Authorization: allow` to succeed (anything else is denied)

Note: This environment is intentionally insecure. Do not reuse in production.
