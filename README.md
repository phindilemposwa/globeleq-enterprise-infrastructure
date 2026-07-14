# globeleq-enterprise-infrastructure

Terraform infrastructure-as-code for Globeleq's AWS data platform, organized by domain.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          AWS Account (eu-west-1)                         │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    VPC (10.x.0.0/16)                             │   │
│  │                                                                   │   │
│  │  ┌─────────────────────────────────────┐                         │   │
│  │  │      Public Subnet (10.x.1.0/24)    │                         │   │
│  │  │                                     │                         │   │
│  │  │  ┌───────────┐  ┌───────────────┐  │                         │   │
│  │  │  │ EC2       │  │ Security      │  │                         │   │
│  │  │  │ (t3.micro)│  │ Groups        │  │                         │   │
│  │  │  └───────────┘  └───────────────┘  │                         │   │
│  │  └─────────────────────────────────────┘                         │   │
│  │           │                                                       │   │
│  │  ┌────────┴────────┐                                             │   │
│  │  │ Internet Gateway │                                             │   │
│  │  └─────────────────┘                                             │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                         S3 Storage                               │   │
│  │                                                                   │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │   │
│  │  │ Bronze Layer │  │ Silver Layer │  │  Gold Layer  │          │   │
│  │  │ (Raw Data)   │  │ (Cleaned)    │  │ (Business)   │          │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘          │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                           IAM                                    │   │
│  │  ┌───────────────────────┐  ┌───────────────────────────┐      │   │
│  │  │ Infrastructure Role   │  │ Infrastructure Policy      │      │   │
│  │  └───────────────────────┘  └───────────────────────────┘      │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

## Repository Structure

```
globeleq-enterprise-infrastructure/
├── .github/
│   └── workflows/
│       ├── dev.yml              # Deploy on push to dev branch
│       ├── qa.yml               # Deploy on push to qa branch
│       └── prod.yml             # Deploy on push to main branch
│
├── environments/
│   ├── dev/                     # Development (10.0.0.0/16)
│   │   ├── backend.tf          # S3 remote state config
│   │   ├── main.tf             # Module declarations
│   │   ├── provider.tf         # AWS provider config
│   │   ├── variables.tf        # Input variable definitions
│   │   ├── terraform.tfvars    # Variable values
│   │   └── outputs.tf          # Exported values
│   │
│   ├── qa/                      # QA/Staging (10.1.0.0/16)
│   │   └── (same structure)
│   │
│   └── prod/                    # Production (10.2.0.0/16)
│       └── (same structure)
│
├── modules/
│   ├── iam/                     # Roles, Policies
│   ├── network/                 # VPC, Subnets, IGW, Route Tables, SGs
│   ├── storage/                 # S3 Buckets (Bronze/Silver/Gold)
│   ├── compute/                 # EC2 Instances, Security Groups
│   ├── analytics/               # Glue, Athena (future)
│   └── orchestration/           # Lambda, Step Functions (future)
│
├── README.md
└── LICENSE
```

## Deployment Process

### Branch Strategy

| Branch | Environment | CIDR         | Auto-Apply |
|--------|-------------|--------------|------------|
| `dev`  | Development | 10.0.0.0/16  | Yes        |
| `qa`   | QA/Staging  | 10.1.0.0/16  | Yes        |
| `main` | Production  | 10.2.0.0/16  | Yes        |

### CI/CD Pipeline (GitHub Actions)

Every push triggers this sequence:

```
terraform fmt -check -recursive
         │
         ▼
   terraform init -upgrade
         │
         ▼
   terraform validate
         │
         ▼
   terraform plan -out=tfplan
         │
         ▼
   terraform apply -auto-approve tfplan
```

### State Management

All environments share a single S3 bucket for state, separated by key:

| Environment | State Key              |
|-------------|------------------------|
| dev         | `dev/terraform.tfstate`  |
| qa          | `qa/terraform.tfstate`   |
| prod        | `prod/terraform.tfstate` |

Bucket: `globeleq-terraform-state-574548986680` (eu-west-1, encrypted, lock file enabled)

## Prerequisites

1. **AWS Account** with programmatic access (Access Key + Secret Key)
2. **GitHub Secrets** configured in the repository:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
3. **IAM Permissions** — The credentials must be able to:
   - Create/manage VPCs, Subnets, Internet Gateways, Route Tables, Security Groups
   - Create/manage S3 buckets
   - Create/manage IAM Roles and Policies
   - Create/manage EC2 instances
   - Create/manage S3 buckets for Terraform state
4. **Terraform** >= 1.7.0 (for local development)
5. **AWS CLI** (for local development)

## How to Deploy Each Environment

### Deploy Dev

```bash
git checkout dev
# Make changes
git add .
git commit -m "your change description"
git push origin dev
```

### Deploy QA

```bash
git checkout qa
git merge dev
git push origin qa
```

### Deploy Production

```bash
git checkout main
git merge qa
git push origin main
```

### Local Development (optional)

```bash
cd environments/dev
terraform init -upgrade
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

## Resource Tagging Strategy

All AWS resources are tagged consistently with:

| Tag Key       | Value                        | Example              |
|---------------|------------------------------|----------------------|
| `Name`        | `{environment}-{resource}`   | `dev-vpc`            |
| `Environment` | `dev`, `qa`, or `prod`       | `dev`                |
| `Project`     | `globeleq`                   | `globeleq`           |
| `ManagedBy`   | `terraform`                  | `terraform`          |

## Resources Created Per Environment

| Resource                     | Naming Pattern                              |
|------------------------------|---------------------------------------------|
| VPC                          | `{env}-vpc`                                 |
| Public Subnet                | `{env}-public-subnet-1`                     |
| Internet Gateway             | `{env}-igw`                                 |
| Route Table                  | `{env}-public-rt`                           |
| Security Group (default)     | `{env}-default-sg`                          |
| Security Group (EC2)         | `{env}-ec2-sg`                              |
| EC2 Instance                 | `{env}-ec2`                                 |
| S3 Bucket (raw)              | `globeleq-{env}-bronze-layer`               |
| S3 Bucket (cleaned)          | `globeleq-{env}-silver-layer`               |
| S3 Bucket (business)         | `globeleq-{env}-gold-layer`                 |
| IAM Role                     | `globeleq-{env}-infrastructure-role`        |
| IAM Policy                   | `globeleq-{env}-infrastructure-policy`      |

## Terraform Outputs

Each environment exports:

| Output             | Description                        |
|--------------------|------------------------------------|
| `iam_role_arn`     | ARN of the infrastructure IAM role |
| `vpc_id`          | ID of the environment VPC          |
| `bronze_bucket_name` | Name of the bronze S3 bucket    |
| `ec2_instance_id` | ID of the EC2 instance             |
| `ec2_public_ip`   | Public IP of the EC2 instance      |

## IAM Permissions (Least Privilege)

The infrastructure policy grants only:

**EC2/VPC** — Create, describe, modify, and delete networking resources (VPCs, subnets, security groups, internet gateways, route tables) and manage tags.

**S3** — Create and configure buckets (versioning, encryption, lifecycle, policies). Limited to bucket-level operations needed for the data lake.

No wildcard `*` actions. No administrative or billing permissions.

## Future Modules

| Module          | Purpose                           | Status   |
|-----------------|-----------------------------------|----------|
| analytics       | Glue Catalog, Crawlers, Athena    | Planned  |
| orchestration   | Lambda, Step Functions, EventBridge | Planned  |
