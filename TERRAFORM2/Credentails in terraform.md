

![[ChatGPT Image May 26, 2026, 09_29_14 AM.png]]

How to Store Sensitive Data in Terraform?

How do you manage credentials in terraform?

We need to be careful while handling credentials. Best practices are setting the environment variables before we plan and apply the infra. Once it is applied we can unset. We can store the credentials in Jenkins Credentials if we are following CICD. In Jenkins, use the "withCredentials" block to inject credentials for the Terraform pipeline.

```
export AWS_ACCESS_KEY_ID="your_access_key"export AWS_SECRET_ACCESS_KEY="your_secret_key"terraform applyunset AWS_ACCESS_KEY_IDunset AWS_SECRET_ACCESS_KEY
```

If we are running terraform through any EC2 instance, we can assign an IAM Role to it.

----------------------------

Do:

- Use IAM Roles whenever possible
- Use temporary credentials instead of permanent access keys
- Store secrets in CI/CD secret managers
- Use environment variables for local runs
- Encrypt Terraform remote state
- Restrict access to state files
- Use least-privilege IAM permissions
- Rotate credentials regularly
- Use `.gitignore` for secrets and tfvars files
- Use secret managers like Vault or AWS Secrets Manager for sensitive values
- Mark sensitive variables as `sensitive = true`
- Use remote backends like S3 + DynamoDB locking

Example:

```
export AWS_ACCESS_KEY_ID="..."export AWS_SECRET_ACCESS_KEY="..."terraform apply
```

Better on AWS:

```
EC2/EKS/Jenkins/GitHub Actions        ↓Attach IAM Role        ↓Terraform uses temporary credentials automatically
```

Secure backend example:

```
terraform {  backend "s3" {    bucket         = "terraform-state-prod"    key            = "prod/vpc.tfstate"    region         = "us-east-1"    encrypt        = true    dynamodb_table = "terraform-locks"  }}
```

Don’t:

- Hardcode credentials in `.tf` files
- Commit secrets to GitHub
- Share root AWS credentials
- Store plaintext passwords in tfvars files
- Expose secrets in Terraform outputs
- Use overly permissive IAM policies like `AdministratorAccess`
- Keep long-lived unused access keys
- Store local state files in shared systems
- Print secrets in CI/CD logs

Avoid this:

```
provider "aws" {  access_key = "AKIA..."  secret_key = "secret123"}
```

Also remember:

```
variable "db_password" {  sensitive = true}
```

This hides output visibility only.  
It does not encrypt the value in state files.
                    TERRAFORM CREDENTIAL MANAGEMENT

                                   ┌─────────────────────┐
                                   │   MAIN OBJECTIVE    │
                                   │ Protect Credentials │
                                   │ & Reduce Exposure   │
                                   └─────────┬───────────┘
                                             │
         ┌───────────────────────────────────┼───────────────────────────────────┐
         │                                   │                                   │
         ▼                                   ▼                                   ▼

┌───────────────────┐           ┌────────────────────┐           ┌────────────────────┐
│  HOW TO PROVIDE   │           │   WHERE SECRETS    │           │   STATE SECURITY   │
│   CREDENTIALS     │           │    SHOULD LIVE     │           │   (VERY IMPORTANT) │
└─────────┬─────────┘           └──────────┬─────────┘           └──────────┬─────────┘
          │                                │                                │
          │                                │                                │
   ┌──────┼──────┐                 ┌───────┼────────┐               ┌───────┼────────┐
   │      │      │                 │       │        │               │       │        │
   ▼      ▼      ▼                 ▼       ▼        ▼               ▼       ▼        ▼

IAM   ENV VARIABLES   CI/CD      Jenkins  Vault   Secrets         Encrypt  Restrict  Locking
Roles                   Secrets                      Manager        State    Access    Enabled

│          │               │
│          │               │
▼          ▼               ▼

BEST      COMMON         PIPELINE
OPTION    OPTION         AUTOMATION


──────────────────────────────────────────────────────────────────────────────

1. IAM ROLE APPROACH (Preferred on AWS)

Terraform
    ↓
AWS SDK
    ↓
IAM Role
    ↓
Temporary Credentials

Used in:
- EC2
- EKS
- ECS
- GitHub Actions
- Jenkins agents


──────────────────────────────────────────────────────────────────────────────

2. ENVIRONMENT VARIABLES

export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."

terraform apply

Advantages:
- Easy
- No secrets in code
- Works in CI/CD


──────────────────────────────────────────────────────────────────────────────

3. SECRET STORAGE OPTIONS

┌─────────────────────┐
│ Jenkins Credentials │
├─────────────────────┤
│ GitHub Secrets      │
├─────────────────────┤
│ GitLab Variables    │
├─────────────────────┤
│ AWS Secrets Manager │
├─────────────────────┤
│ HashiCorp Vault     │
└─────────────────────┘


──────────────────────────────────────────────────────────────────────────────

4. TERRAFORM STATE RISK

Secrets may leak into:

terraform.tfstate
        │
        ├── passwords
        ├── DB credentials
        ├── API keys
        └── generated secrets


Secure backend:

S3 Backend
   │
   ├── Encryption enabled
   ├── KMS protected
   └── DynamoDB locking


──────────────────────────────────────────────────────────────────────────────

5. DO

✓ Use IAM roles
✓ Use temporary credentials
✓ Encrypt remote state
✓ Restrict state access
✓ Rotate credentials
✓ Use secret managers
✓ Use least privilege
✓ Ignore secret files in Git


──────────────────────────────────────────────────────────────────────────────

6. DON'T

✗ Hardcode secrets in .tf files
✗ Push credentials to GitHub
✗ Use root credentials
✗ Store plaintext passwords in repo
✗ Expose secrets in outputs
✗ Give excessive IAM permissions
✗ Share local tfstate files


──────────────────────────────────────────────────────────────────────────────

                    TERRAFORM CREDENTIAL MANAGEMENT

                                   ┌─────────────────────┐
                                   │   MAIN OBJECTIVE    │
                                   │ Protect Credentials │
                                   │ & Reduce Exposure   │
                                   └─────────┬───────────┘
                                             │
         ┌───────────────────────────────────┼───────────────────────────────────┐
         │                                   │                                   │
         ▼                                   ▼                                   ▼

┌───────────────────┐           ┌────────────────────┐           ┌────────────────────┐
│  HOW TO PROVIDE   │           │   WHERE SECRETS    │           │   STATE SECURITY   │
│   CREDENTIALS     │           │    SHOULD LIVE     │           │   (VERY IMPORTANT) │
└─────────┬─────────┘           └──────────┬─────────┘           └──────────┬─────────┘
          │                                │                                │
          │                                │                                │
   ┌──────┼──────┐                 ┌───────┼────────┐               ┌───────┼────────┐
   │      │      │                 │       │        │               │       │        │
   ▼      ▼      ▼                 ▼       ▼        ▼               ▼       ▼        ▼

IAM   ENV VARIABLES   CI/CD      Jenkins  Vault   Secrets         Encrypt  Restrict  Locking
Roles                   Secrets                      Manager        State    Access    Enabled

│          │               │
│          │               │
▼          ▼               ▼

BEST      COMMON         PIPELINE
OPTION    OPTION         AUTOMATION


──────────────────────────────────────────────────────────────────────────────

1. IAM ROLE APPROACH (Preferred on AWS)

Terraform
    ↓
AWS SDK
    ↓
IAM Role
    ↓
Temporary Credentials

Used in:
- EC2
- EKS
- ECS
- GitHub Actions
- Jenkins agents


──────────────────────────────────────────────────────────────────────────────

2. ENVIRONMENT VARIABLES

export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."

terraform apply

Advantages:
- Easy
- No secrets in code
- Works in CI/CD


──────────────────────────────────────────────────────────────────────────────

3. SECRET STORAGE OPTIONS

┌─────────────────────┐
│ Jenkins Credentials │
├─────────────────────┤
│ GitHub Secrets      │
├─────────────────────┤
│ GitLab Variables    │
├─────────────────────┤
│ AWS Secrets Manager │
├─────────────────────┤
│ HashiCorp Vault     │
└─────────────────────┘


──────────────────────────────────────────────────────────────────────────────

4. TERRAFORM STATE RISK

Secrets may leak into:

terraform.tfstate
        │
        ├── passwords
        ├── DB credentials
        ├── API keys
        └── generated secrets


Secure backend:

S3 Backend
   │
   ├── Encryption enabled
   ├── KMS protected
   └── DynamoDB locking


──────────────────────────────────────────────────────────────────────────────

5. DO

✓ Use IAM roles
✓ Use temporary credentials
✓ Encrypt remote state
✓ Restrict state access
✓ Rotate credentials
✓ Use secret managers
✓ Use least privilege
✓ Ignore secret files in Git


──────────────────────────────────────────────────────────────────────────────

6. DON'T

✗ Hardcode secrets in .tf files
✗ Push credentials to GitHub
✗ Use root credentials
✗ Store plaintext passwords in repo
✗ Expose secrets in outputs
✗ Give excessive IAM permissions
✗ Share local tfstate files


──────────────────────────────────────────────────────────────────────────────
	