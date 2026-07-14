# Globeleq Enterprise Infrastructure

Terraform infrastructure-as-code for Globeleq's AWS data platform, organized by domain.

## Project Structure

```
globeleq-enterprise-infrastructure/
├── .github/workflows/       # CI/CD pipelines (dev, qa, prod)
├── environments/
│   ├── dev/                 # Development environment
│   ├── qa/                  # QA/staging environment
│   └── prod/                # Production environment
├── modules/
│   ├── iam/                 # Roles, Policies, Instance Profiles
│   ├── network/             # VPC, Subnets, IGW, Route Tables, Security Groups
│   ├── storage/             # S3 Buckets (Bronze/Silver/Gold), Lifecycle, Encryption
│   ├── compute/             # EC2, Launch Templates, Auto Scaling
│   ├── analytics/           # Glue Catalog, Crawlers, Athena
│   └── orchestration/       # Lambda, Step Functions, EventBridge
├── README.md
└── LICENSE
```
#
## Module Build Order (Free Tier Safe)

1. **IAM** ✅ — Roles and policies
2. **Network** — VPC, subnets, internet gateway
3. **Storage** — S3 bronze/silver/gold buckets
4. **Compute** — EC2 (t2.micro free tier)
5. **Analytics** — Glue Catalog, Athena
6. **Orchestration** — Lambda, Step Functions

## Environments

| Environment | Branch    | Region     | Auto-Apply |
|-------------|-----------|------------|------------|
| dev         | develop   | eu-west-1  | Yes        |
| qa          | qa        | eu-west-1  | No (plan only) |
| prod        | main      | eu-west-1  | No (plan only) |

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.7.0
- AWS CLI configured with appropriate credentials
- S3 bucket and DynamoDB table for remote state (see `backend.tf`)

## Usage

```bash
cd environments/dev
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply
```

## CI/CD

GitHub Actions workflows run on push to the corresponding branch:
- `develop` → fmt, init, validate, plan, **apply** (dev only)
- `qa` → fmt, init, validate, plan
- `main` → fmt, init, validate, plan

QA and Prod require manual approval before applying.
