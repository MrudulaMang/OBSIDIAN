Providing complete expert-level answers for all 100 questions in one response would produce a very large document (tens of thousands of words) and would not be practical to study.

A better approach is to organize them into a Terraform interview handbook.

### Section 1: Questions 1–20 with Answers

**1. Your team wants to create one EC2 instance manually. Why use Terraform at all?**

**Answer:**  
Terraform provides Infrastructure as Code (IaC). Even for a single instance, benefits include:

- Version control
- Repeatability
- Auditing
- Disaster recovery
- Consistency across environments

The value isn't creating one server; it's recreating the same server reliably years later.

---

**2. A developer changed an EC2 instance from the AWS console. How would Terraform detect this?**

**Answer:**  
Terraform compares:

- Current state file
- Actual AWS infrastructure
- Terraform configuration

Running:

```
terraform plan
```

reveals the drift and proposes corrective actions.

---

**3. You run terraform plan and see unexpected changes. What do you do?**

**Answer:**

Never apply immediately.

Investigate:

1. Was infrastructure changed manually?
2. Was provider version upgraded?
3. Was module version upgraded?
4. Was state modified?
5. Has AWS changed defaults?

Only apply after understanding every proposed change.

---

**4. Difference between terraform plan and terraform apply?**

**Answer:**

`terraform plan`

- Dry run
- Shows intended changes
- Makes no modifications

`terraform apply`

- Executes changes
- Creates/modifies/deletes infrastructure

Think:

```
plan = proposalapply = execution
```

---

**5. A resource already exists in AWS but not in Terraform state. How do you manage it?**

**Answer:**

Import it.

Example:

```
terraform import aws_instance.web i-123456789
```

Then update Terraform code to match actual configuration.

---

**6. A junior engineer accidentally deletes the state file. What problems can occur?**

**Answer:**

Terraform loses infrastructure tracking.

Potential consequences:

- Duplicate resources
- Recreation attempts
- Destructive operations

This is why remote state is critical.

---

**7. Why should state files not be stored on developer laptops?**

**Answer:**

Problems:

- No backup
- No locking
- Security risk
- Team inconsistency

Preferred:

```
S3 + DynamoDBTerraform CloudHCP Terraform
```

---

**8. When would you use variables instead of hardcoded values?**

**Answer:**

Whenever values differ across environments.

Example:

```
instance_type = var.instance_type
```

instead of:

```
instance_type = "t3.medium"
```

Allows:

```
dev = t3.microprod = t3.large
```

---

**9. Why is terraform.tfvars useful?**

**Answer:**

Separates configuration from code.

Example:

```
region = "us-east-1"environment = "dev"
```

The code remains reusable.

---

**10. Organization has dev, test, prod. How would you structure Terraform?**

**Answer:**

Common approach:

```
terraform/├── modules/│   ├── vpc│   ├── ec2│   └── rds│├── envs/│   ├── dev│   ├── test│   └── prod
```

Modules contain reusable logic.

Environments contain environment-specific values.

---

**11. What happens if two engineers run Terraform simultaneously?**

**Answer:**

Without locking:

- State corruption
- Race conditions
- Lost updates

With S3 backend + DynamoDB:

Terraform locks state.

Second user receives:

```
Error acquiring state lock
```

---

**12. Why is remote state important?**

**Answer:**

Provides:

- Centralized state
- Team collaboration
- Locking
- Backup
- Disaster recovery

---

**13. Why does Terraform maintain state at all?**

**Answer:**

Terraform must know:

```
What existsWhat changedWhat should be changed
```

Without state Terraform would have no memory.

---

**14. What information is stored inside state?**

**Answer:**

Examples:

- Resource IDs
- ARNs
- Attributes
- Dependencies
- Outputs

Example:

```
EC2 instance IDVPC IDSubnet IDs
```

---

**15. What happens when a resource is deleted from code and applied?**

**Answer:**

Terraform plans destruction.

Example:

```
resource "aws_instance" "web" {}
```

Remove it from code.

Then:

```
terraform apply
```

Result:

```
Destroy aws_instance.web
```

---

**16. Why should secrets not be stored directly in Terraform code?**

**Answer:**

Secrets may appear in:

- Git repositories
- State files
- Logs
- CI/CD output

Use:

- AWS Secrets Manager
- Parameter Store
- Vault

instead.

---

**17. Difference between data sources and resources?**

**Answer:**

Resource:

```
resource "aws_vpc" "main"
```

Creates infrastructure.

Data source:

```
data "aws_vpc" "main"
```

Reads existing infrastructure.

---

**18. When would you use outputs?**

**Answer:**

To expose values.

Example:

```
output "vpc_id" {  value = aws_vpc.main.id}
```

Useful for:

- Other modules
- CI/CD pipelines
- Operators

---

**19. What happens if a resource name changes?**

Example:

```
aws_instance.web
```

becomes:

```
aws_instance.app
```

Terraform sees:

```
Destroy oldCreate new
```

unless state is moved.

Use:

```
terraform state mv
```

for safe renaming.

---

**20. Explain Terraform to a non-technical manager.**

**Answer:**

Terraform is a system that allows infrastructure to be described as code.

Instead of engineers manually creating servers, networks, and databases, Terraform stores the desired infrastructure in files and automatically builds it.

Benefits:

- Faster deployments
- Consistency
- Reduced human error
- Easier auditing
- Faster disaster recovery

---

The next set (21–40) becomes significantly more interesting because it covers state corruption, imports, drift, backend failures, and real-world troubleshooting—the areas where many Terraform engineers struggle during interviews.
----------------------------------------------------------------------
## Terraform Interview Handbook

## Part 2 — Questions 21–40 (State Management)

These questions separate someone who can write Terraform from someone who can recover production when Terraform breaks.

---

### 21. Your state file becomes corrupted. What recovery options exist?

**Answer**

Recovery options:

1. Restore state from backup.
2. Restore previous version from S3 versioning.
3. Use Terraform Cloud state history.
4. Re-import resources.
5. Reconstruct state manually (last resort).

Best practice:

```
Enable S3 versioningEnable DynamoDB lockingTake regular backups
```

Production lesson:

If state is lost but infrastructure exists, importing resources is usually safer than rebuilding infrastructure.

---

### 22. Someone manually deleted an EC2 instance. Terraform still thinks it exists. What happens next?

**Answer**

Terraform state:

```
EC2 exists
```

AWS reality:

```
EC2 deleted
```

Running:

```
terraform plan
```

causes Terraform to discover the resource is missing.

Result:

```
Plan: Create 1 resource
```

Terraform attempts to recreate it.

This is classic state drift.

---

### 23. A resource exists in state but not in AWS. How do you fix it?

**Answer**

First determine why it disappeared.

Options:

**Option A**

Allow Terraform to recreate it.

```
terraform apply
```

**Option B**

If resource was intentionally removed:

```
terraform state rm RESOURCE
```

This removes tracking without touching AWS.

Never blindly manipulate state until root cause is understood.

---

### 24. What is state drift?

**Answer**

Drift occurs when actual infrastructure differs from Terraform configuration/state.

Example:

Terraform:

```
EC2 type = t3.micro
```

AWS Console:

```
Changed to t3.large
```

Terraform no longer matches reality.

Causes:

- Manual changes
- Scripts
- CloudFormation
- Other Terraform projects

---

### 25. How do you identify drift before deployment?

**Answer**

Run:

```
terraform plan
```

or

```
terraform plan -refresh-only
```

Good organizations run drift detection regularly.

Example:

```
Nightly pipelineterraform plan
```

Alert if drift appears.

---

### 26. Your S3 backend is unavailable. Can Terraform work?

**Answer**

Depends.

If remote state cannot be accessed:

```
No state accessNo lockingNo operations
```

Terraform usually refuses to proceed.

Reason:

Operating without current state could destroy infrastructure.

---

### 27. Why is DynamoDB locking used with S3 backend?

**Answer**

S3 stores state.

DynamoDB stores lock.

Example:

Engineer A:

```
terraform apply
```

Lock acquired.

Engineer B:

```
terraform apply
```

Lock denied.

Without locking:

```
State corruptionRace conditionsLost updates
```

---

### 28. What happens if state locking fails?

**Answer**

Terraform refuses operation.

Example:

```
Error acquiring state lock
```

Potential causes:

- Existing apply running
- Abandoned lock
- DynamoDB issues

Investigate first.

Last resort:

```
terraform force-unlock LOCK_ID
```

Use carefully.

---

### 29. Two Terraform projects accidentally manage the same resource. What problems arise?

**Answer**

This is a serious architectural mistake.

Project A:

```
Controls Security Group
```

Project B:

```
Controls same Security Group
```

Results:

```
Terraform warsConstant driftUnexpected changesProduction outages
```

One resource should have exactly one owner.

---

### 30. How would you split a huge monolithic state into smaller states?

**Answer**

Example:

Current:

```
1 state5000 resources
```

Split into:

```
network-statesecurity-statedatabase-stateapplication-state
```

Benefits:

- Faster plans
- Smaller blast radius
- Better ownership
- Easier troubleshooting

---

### 31. What risks exist with a 50 MB state file?

**Answer**

Problems:

- Slow plans
- Slow applies
- Large lock durations
- Difficult debugging
- Higher corruption risk

Large state often indicates poor architecture.

---

### 32. When should state be shared across teams?

**Answer**

Rarely.

Shared only when infrastructure is genuinely shared.

Example:

Platform team owns:

```
VPCTransit GatewayShared DNS
```

Application teams consume outputs.

Ownership remains clear.

---

### 33. When should state NOT be shared across teams?

**Answer**

Almost always.

Bad:

```
One giant state20 teams
```

Result:

```
Lock contentionFear of deploymentsOwnership confusion
```

Prefer isolated states.

---

### 34. How would you migrate local state to S3 backend?

**Answer**

Create backend:

```
terraform { backend "s3" {   bucket = "terraform-state"   key    = "prod.tfstate"   region = "us-east-1" }}
```

Then:

```
terraform init
```

Terraform asks:

```
Copy existing state?
```

Answer:

```
yes
```

State migrates automatically.

---

### 35. How would you migrate from one backend to another?

**Answer**

Update backend configuration.

Run:

```
terraform init -migrate-state
```

Terraform copies state.

Validate:

```
terraform state list
```

before production use.

---

### 36. A teammate manually modifies the state file. What could break?

**Answer**

Everything.

Examples:

- Wrong IDs
- Missing resources
- Dependency corruption
- Unexpected destroys

State is Terraform's source of truth.

Manual editing should be extremely rare.

---

### 37. How do `terraform state rm` and deleting a resource differ?

**Answer**

State remove:

```
terraform state rm aws_instance.web
```

Result:

```
Resource remains in AWSTerraform forgets it
```

Deleting resource:

```
Remove from code
```

then:

```
terraform apply
```

Result:

```
Resource destroyed in AWS
```

Big difference.

---

### 38. When would you use `terraform state mv`?

**Answer**

Used during refactoring.

Example:

Before:

```
aws_instance.web
```

After:

```
module.compute.aws_instance.web
```

Without move:

```
Destroy oldCreate new
```

With:

```
terraform state mv
```

No recreation occurs.

---

### 39. How do you safely rename resources without recreation?

**Answer**

Example:

Old:

```
aws_instance.web
```

New:

```
aws_instance.app
```

Move state:

```
terraform state mv \aws_instance.web \aws_instance.app
```

Terraform understands it is the same resource.

No destroy/create cycle.

---

### 40. Explain state locking to a junior engineer.

**Answer**

Imagine a Google Sheet.

If two people edit the same row simultaneously:

```
ConflictOverwriteCorruption
```

Terraform state behaves similarly.

State lock means:

```
One writer at a time
```

While one engineer runs:

```
terraform apply
```

everyone else waits.

Locking protects infrastructure from concurrent modification.

---

These 21–40 questions are the backbone of senior Terraform troubleshooting interviews. Many engineers know resources and modules; far fewer understand state deeply.

The next section (41–55) moves into **module design, reusable architecture, versioning strategy, enterprise Terraform structure, and platform engineering patterns**—the topics commonly used to evaluate Senior/Lead Terraform engineers.


-------------------------------------------------------------------------

## 41. Why create a module instead of duplicating code?

### Answer

Without modules:

```
vpc-dev.tfvpc-test.tfvpc-stage.tfvpc-prod.tf
```

Every change must be repeated.

With a module:

```
module "vpc" {  source = "./modules/vpc"}
```

Benefits:

- Reusability
- Consistency
- Easier maintenance
- Reduced errors

A module is essentially a reusable infrastructure blueprint.

---

## 42. Your VPC code is repeated 20 times. What would you do?

### Answer

Extract it into a module.

Current situation:

```
20 VPC definitions20 subnet definitions20 route tables
```

Create:

```
modules/vpc
```

Then call it repeatedly:

```
module "dev_vpc" {}module "test_vpc" {}module "prod_vpc" {}
```

Maintain one codebase instead of twenty.

---

## 43. How would you design a reusable VPC module?

### Answer

Inputs:

```
variable "cidr"variable "environment"variable "public_subnets"variable "private_subnets"
```

Outputs:

```
output "vpc_id"output "private_subnet_ids"output "public_subnet_ids"
```

Module should:

- Create VPC
- Create subnets
- Create route tables
- Create IGW/NAT if needed

Avoid environment-specific hardcoding.

---

## 44. What should and should not go into a module?

### Answer

Good candidates:

```
VPCEKSRDSALBSecurity Baselines
```

Bad candidates:

```
One-off resourcesEnvironment-specific hacksTemporary infrastructure
```

Rule:

If multiple teams will use it, module makes sense.

If only one project needs it, maybe not.

---

## 45. A module has 50 input variables. Is that a problem?

### Answer

Usually yes.

Possible causes:

- Poor abstraction
- Trying to satisfy every use case
- Design complexity

Healthy module:

```
5–15 variables
```

Danger zone:

```
40+
```

Interviewers often view huge variable lists as a design smell.

---

## 46. How would you version Terraform modules?

### Answer

Use Git tags.

Example:

```
v1.0.0v1.1.0v2.0.0
```

Usage:

```
module "vpc" { source = "git::https://repo.git//vpc?ref=v1.2.0"}
```

Never point production directly to main branch.

---

## 47. Why pin module versions?

### Answer

Without version pinning:

```
Developer deploys todayWorks fine
```

Tomorrow:

```
Module changedInfrastructure changes unexpectedly
```

Version pinning guarantees repeatability.

Example:

```
?ref=v1.2.3
```

Production should always use pinned versions.

---

## 48. Production suddenly changes after a module update. What happened?

### Answer

Likely causes:

1. Module version changed
2. Provider version changed
3. Default values changed
4. Resource logic changed

First thing to check:

```
terraform providers
```

and

```
module source version
```

Unexpected updates usually come from dependency changes.

---

## 49. How do you safely upgrade modules?

### Answer

Process:

```
Dev↓Test↓Stage↓Prod
```

Steps:

1. Update version
2. Run plan
3. Review changes
4. Apply in lower environments
5. Validate
6. Promote

Never jump directly to production.

---

## 50. How would you structure modules for a multi-team organization?

### Answer

Common structure:

```
modules/├── networking├── security├── eks├── rds├── monitoring
```

Ownership:

```
Platform Team
```

Consumers:

```
Application Teams
```

Application teams use modules.

Platform team maintains modules.

---

## 51. How would you publish internal modules?

### Answer

Options:

### Git repositories

```
git.company.com/modules/vpc
```

### Terraform Registry

Private registry:

```
Terraform CloudHCP Terraform
```

Advantages:

- Versioning
- Discovery
- Governance

Large organizations usually prefer registries.

---

## 52. What risks exist if every team modifies a shared module?

### Answer

Chaos.

Example:

Team A wants:

```
Feature X
```

Team B wants:

```
Feature Y
```

Soon:

```
100 variablesComplex logicUnstable module
```

Better approach:

- Platform team owns module
- Pull requests reviewed centrally

---

## 53. How would you enforce standards through modules?

### Answer

Example:

Company requires:

```
EncryptionLoggingMonitoringTagging
```

Embed them inside modules.

Users cannot accidentally omit them.

Instead of:

```
resource "aws_s3_bucket"
```

Use:

```
module "secure_bucket"
```

Standards become automatic.

---

## 54. How do you pass outputs from one module to another?

### Answer

Module A:

```
output "vpc_id" { value = aws_vpc.main.id}
```

Module B:

```
module "eks" { vpc_id = module.vpc.vpc_id}
```

Flow:

```
Module A Output      ↓Module B Input
```

Common pattern in enterprise deployments.

---

## 55. What makes a Terraform module enterprise-grade?

### Answer

An enterprise-grade module typically includes:

### Versioning

```
Semantic Versioning
```

### Documentation

```
READMEExamplesInputsOutputs
```

### Security

```
Encryption enabledLeast privilegeSecure defaults
```

### Testing

```
terraform validateterraform fmtCI/CD
```

### Observability

```
LoggingMonitoringTags
```

### Upgrade Safety

```
Backward compatibilityMigration guidance
```

A good module creates infrastructure.

A great module creates infrastructure safely for hundreds of engineers.

---

## Senior-Level Follow-Up Questions Often Asked

After these 15 questions, interviewers frequently ask:

1. How would you build a module used by 500 teams?
2. How do you prevent module breaking changes?
3. When should a module be split?
4. How would you deprecate a module?
5. How would you design a Terraform platform for 2000 AWS accounts?
6. How do you enforce tagging globally?
7. How would you implement policy-as-code?
8. How do you keep module upgrades manageable across hundreds of repositories?

These lead directly into architect-level Terraform discussions.

The next section (56–70) is where Terraform meets real AWS architecture: VPCs, NAT Gateways, ALBs, Route53, RDS, EKS, multi-account, multi-region, and disaster recovery scenarios. This is the section most commonly asked in Senior DevOps and Platform Engineer interviews.

-----------------------------------------------------------

# Terraform Interview Handbook

# Part 4 — Questions 56–70 (Real Infrastructure & AWS Architecture)

This section is where Terraform knowledge and AWS architecture knowledge become inseparable.

---

# 56. A company wants a VPC with public and private subnets. How would you design it?

### Answer

Typical production design:

```
VPC│├── Public Subnet AZ-A├── Public Subnet AZ-B│├── Private App Subnet AZ-A├── Private App Subnet AZ-B│├── Private DB Subnet AZ-A└── Private DB Subnet AZ-B
```

Public:

```
ALBBastion (if used)NAT Gateway
```

Private:

```
Application ServersEKS NodesDatabases
```

Terraform should create:

- VPC
- Subnets
- Route tables
- IGW
- NAT Gateway
- Security Groups

Interview trap:

Many candidates place databases in public subnets.

Never do that.

---

# 57. How would Terraform create highly available infrastructure across multiple AZs?

### Answer

Distribute resources.

Example:

```
AZ-1AZ-2AZ-3
```

Terraform:

```
resource "aws_subnet" "private" { count = 3}
```

Deploy:

```
Multiple subnetsMultiple EC2sMulti-AZ RDS
```

If one AZ fails:

```
Application survives
```

HA is an architecture decision, not a Terraform feature.

Terraform simply implements it.

---

# 58. A database should never be publicly accessible. How would you enforce that?

### Answer

Multiple layers.

Terraform:

```
publicly_accessible = false
```

Private subnet only.

Security Group:

```
Allow only application SG
```

No:

```
0.0.0.0/0
```

Even if a developer makes a mistake, security controls should prevent exposure.

---

# 59. EC2 instances need internet access but should not have public IPs. What would you build?

### Answer

Use NAT Gateway.

Architecture:

```
Private EC2    ↓NAT Gateway    ↓Internet Gateway    ↓Internet
```

Benefits:

```
Outbound accessNo inbound exposure
```

Common use cases:

- Package updates
- Docker pulls
- API calls

---

# 60. How would Terraform deploy an ALB with multiple application servers?

### Answer

Resources:

```
ALBTarget GroupListenersEC2 Instances
```

Flow:

```
Users ↓ALB ↓Target Group ↓EC2s
```

Terraform dependencies:

```
ALB ↓Target Group ↓Attachments
```

Health checks are mandatory.

---

# 61. How would you deploy Auto Scaling infrastructure?

### Answer

Terraform creates:

```
Launch TemplateAuto Scaling GroupScaling PoliciesCloudWatch Alarms
```

Example:

```
CPU > 70%
```

Scale out.

```
CPU < 20%
```

Scale in.

Production systems should rarely use fixed EC2 counts.

---

# 62. How would you manage Route53 records with Terraform?

### Answer

Example:

```
resource "aws_route53_record" "app" {}
```

Benefits:

```
Version controlled DNSAuditableRepeatable
```

Avoid:

```
Manual DNS changes
```

DNS drift causes many outages.

---

# 63. Infrastructure spans three AWS accounts. How would Terraform handle authentication?

### Answer

Common pattern:

```
Management Account     ↓AssumeRole     ↓Dev AccountProd AccountShared Services Account
```

Terraform provider:

```
assume_role { role_arn = ...}
```

Benefits:

```
Central controlAccount isolation
```

Large organizations use this heavily.

---

# 64. How would you deploy identical infrastructure in multiple regions?

### Answer

Example:

```
us-east-1us-west-2eu-west-1
```

Use provider aliases.

```
provider "aws" { alias = "east"}provider "aws" { alias = "west"}
```

Deploy modules against each provider.

Avoid duplicating code.

---

# 65. How would you provision EKS using Terraform?

### Answer

Terraform creates:

```
VPCSubnetsIAM RolesEKS ClusterNode GroupsSecurity Groups
```

Terraform's role ends roughly here.

After cluster exists:

```
Kubernetes manages workloads
```

A common mistake is trying to manage everything through Terraform.

---

# 66. What resources should Terraform manage inside Kubernetes?

### Answer

Good candidates:

```
NamespacesIngressStorage ClassesCluster-wide resources
```

Less ideal:

```
Application deployments
```

Reason:

Applications change frequently.

Terraform state becomes noisy.

Usually:

```
Terraform → InfrastructureHelm/ArgoCD → Applications
```

---

# 67. Should Terraform deploy application code?

### Answer

Usually no.

Terraform excels at:

```
Infrastructure lifecycle
```

CI/CD excels at:

```
Application lifecycle
```

Bad pattern:

```
Terraform deploys every application release
```

Good pattern:

```
Terraform creates platformPipeline deploys code
```

---

# 68. How would you manage RDS password rotation?

### Answer

Do NOT hardcode passwords.

Use:

- AWS Secrets Manager
- Vault
- Parameter Store

Terraform creates secret storage.

Applications retrieve credentials dynamically.

Rotation should happen independently of Terraform applies.

---

# 69. How would you manage ACM certificates?

### Answer

Terraform:

```
Request CertificateDNS ValidationRoute53 Records
```

Flow:

```
Certificate Request     ↓Validation Record     ↓Certificate Issued
```

Then attach to:

```
ALBCloudFrontAPI Gateway
```

---

# 70. How would you automate disaster recovery infrastructure?

### Answer

Terraform should be able to rebuild:

```
NetworkingComputeDatabasesSecurityDNS
```

Strategy:

Primary:

```
us-east-1
```

DR:

```
us-west-2
```

Terraform provisions both.

Data replication handled separately.

Important distinction:

Terraform recreates infrastructure.

Terraform does NOT automatically recover lost business data.

---

# Interview Scenario Deep Dives

These are common follow-up questions.

---

## Scenario 1

Terraform wants to replace a production RDS instance.

What do you do?

### Answer

Never apply immediately.

Investigate:

```
terraform plan
```

Check:

```
Parameter changesStorage changesEngine changesIdentifier changes
```

Some attributes force replacement.

Production database replacement can mean outage and data loss.

---

## Scenario 2

Your NAT Gateway costs $3000/month.

How would you reduce costs?

### Answer

Investigate:

```
Number of NAT GatewaysTraffic volumeArchitecture
```

Possible solutions:

```
Gateway EndpointsInterface EndpointsShared NAT design
```

Terraform engineers are expected to understand cost implications.

---

## Scenario 3

Your Terraform deployment takes 45 minutes.

How would you improve it?

### Answer

Investigate:

```
State sizeModule countResource countProvider calls
```

Potential fixes:

```
Split stateReduce dependenciesParallelism tuningSeparate environments
```

---

## Scenario 4

Company has 500 applications.

Would you use one Terraform repository?

### Answer

No.

Likely structure:

```
Platform RepoNetwork RepoSecurity RepoShared Services RepoApplication Repos
```

Monorepos can work but ownership becomes difficult.

---

## Scenario 5

A developer manually changes Route53 in production.

What should happen?

### Answer

Terraform plan should detect drift.

Organization should have:

```
Change controlsTerraform ownershipRestricted permissions
```

Manual production changes should be exceptional.

---

At this point you've moved beyond "Terraform user" territory. Questions 71–80 cover CI/CD pipelines, GitOps, approval workflows, governance, and operating Terraform across hundreds of engineers—the kind of discussions seen in Staff DevOps, Platform Engineering, and SRE interviews.

---------------------------------------------------

# Terraform Interview Handbook

# Part 5 — Questions 71–80 (CI/CD, GitOps, Governance, Enterprise Scale)

At this level, interviewers stop asking "How do you create a VPC?" and start asking:

> "How do you stop 500 engineers from accidentally destroying production?"

---

# 71. How would you integrate Terraform into Jenkins?

### Answer

Typical pipeline:

```
Git Push   ↓Jenkins   ↓terraform fmt   ↓terraform validate   ↓terraform plan   ↓Approval   ↓terraform apply
```

Example Jenkins stages:

```
Stage 1: CheckoutStage 2: ValidateStage 3: PlanStage 4: ApprovalStage 5: Apply
```

Important:

Production applies should not happen automatically after every commit.

---

# 72. How would you integrate Terraform into GitHub Actions?

### Answer

Workflow:

```
Pull Request      ↓Terraform Plan      ↓Review      ↓Merge      ↓Apply
```

Benefits:

```
Version controlAudit trailApprovalsRollback visibility
```

Common workflow:

```
terraform fmtterraform validateterraform plan
```

on PRs.

Apply only after merge.

---

# 73. Why should Terraform not run directly from developer laptops in production?

### Answer

Problems:

```
No audit trailDifferent Terraform versionsDifferent credentialsNo approvalsHuman error
```

Example:

Developer laptop:

```
terraform apply
```

Can destroy production.

Better:

```
Git Commit     ↓Pipeline     ↓Controlled Apply
```

Infrastructure changes should be traceable.

---

# 74. How would you implement approval workflows?

### Answer

Common pattern:

```
Developer    ↓Pull Request    ↓Terraform Plan    ↓Review    ↓Approval    ↓Apply
```

Production often requires:

```
2 ApproversSecurity ReviewChange Window
```

Terraform should not bypass organizational controls.

---

# 75. How would you prevent direct applies to production?

### Answer

Several layers.

### Layer 1

Remove production AWS credentials from engineers.

### Layer 2

Only CI/CD role can apply.

### Layer 3

Branch protection.

Example:

```
main branch protected
```

### Layer 4

Approval requirements.

Best practice:

Humans review.

Pipelines deploy.

---

# 76. What checks should run before Terraform apply?

### Answer

Minimum:

```
terraform fmtterraform validateterraform plan
```

Advanced:

```
CheckovtfsecOPA PoliciesCost AnalysisCompliance Validation
```

Goal:

Catch problems before infrastructure changes.

---

# 77. How would you implement Terraform in a GitOps model?

### Answer

Git becomes source of truth.

Flow:

```
Git ↓Pull Request ↓Plan ↓Review ↓Merge ↓Apply
```

Nobody manually changes infrastructure.

Desired state:

```
Git
```

Actual state:

```
Cloud
```

Terraform continuously reconciles them.

---

# 78. How would multiple teams share Terraform ownership safely?

### Answer

Bad:

```
One stateOne repositoryTwenty teams
```

Good:

```
Platform Team    ↓Shared Modules
```

Application Teams:

```
Own application infrastructure
```

Ownership boundaries are critical.

---

# 79. How would you manage Terraform in an organization with 500 engineers?

### Answer

You need governance.

Typical structure:

```
Platform Team ├── Modules ├── Standards ├── Security └── PipelinesApplication Teams ├── Consume Modules └── Deploy Workloads
```

Do not allow:

```
500 engineers500 custom VPC designs
```

Chaos follows.

---

# 80. What governance controls would you implement?

### Answer

Examples:

### Mandatory Tags

```
OwnerCost CenterEnvironmentApplication
```

### Security Policies

```
No public RDSNo open SSHEncryption required
```

### CI/CD Controls

```
Approval requiredPlan review required
```

### Version Controls

```
Pinned providersPinned modules
```

Governance exists to reduce risk, not create bureaucracy.

---

# Senior Interview Follow-Ups

These are frequently asked after the above questions.

---

## Scenario 1

A developer opens:

```
0.0.0.0/0Port 22
```

How do you stop it?

### Answer

Use policy-as-code.

Examples:

- Open Policy Agent
- Sentinel

Policy:

```
Deny:SSH exposed to internet
```

Pipeline fails before deployment.

---

## Scenario 2

Someone submits Terraform that creates 500 EC2 instances accidentally.

How do you prevent it?

### Answer

Use:

```
Plan ReviewCost EstimationApproval Gates
```

Production applies should never be fully blind.

---

## Scenario 3

Terraform deployment would increase AWS spend by $50,000/month.

How do you catch it?

### Answer

Integrate:

- [Infracost](https://www.infracost.io?utm_source=chatgpt.com)

into PR workflow.

Example:

```
Current Cost: $2,000New Cost: $52,000
```

Reviewer sees impact before merge.

---

## Scenario 4

How would you know who changed infrastructure six months ago?

### Answer

Pipeline logs.

Git history.

PR approvals.

Example:

```
CommitReviewerPlanApplyTimestamp
```

Everything should be traceable.

---

## Scenario 5

Company acquires another company with completely different Terraform standards.

What do you do?

### Answer

Do not rewrite immediately.

Inventory first:

```
RepositoriesModulesProvidersBackendsPolicies
```

Then gradually standardize.

Big-bang migrations often fail.

---

# Architect-Level Thought Process

When reviewing a Terraform design, think through:

### Ownership

```
Who owns it?
```

### State

```
Where is state?
```

### Security

```
Can it expose data?
```

### Cost

```
Can it create financial surprises?
```

### Recovery

```
How do we recover if it breaks?
```

### Scale

```
Will this still work with 100 teams?
```

Most senior interviews revolve around those six questions.

The next section (81–90) is often the hardest in real interviews: production incidents, state corruption, stuck locks, failed applies, provider bugs, module failures, and disaster recovery. These are the questions that distinguish experienced operators from engineers who have only built greenfield environments.

-------------------------------------------------------------------------------

# Terraform Interview Handbook

# Part 6 & Part 7 — Questions 81–100

## Troubleshooting, Outages, Staff-Level & Architect-Level Scenarios

These are the questions that typically determine whether someone is viewed as a Senior Engineer, Staff Engineer, Platform Engineer, or Architect.

---

# 81. Terraform wants to destroy a production database unexpectedly. What do you do?

### Answer

Never run apply.

First:

```
terraform plan
```

Investigate:

```
What changed?Was state modified?Was resource renamed?Was module upgraded?Was provider upgraded?
```

Look for:

```
forces replacement
```

in the plan output.

A good engineer pauses.

A dangerous engineer proceeds.

---

# 82. A resource keeps getting recreated every apply. How do you debug it?

### Answer

Common causes:

```
Provider bugComputed valuesIncorrect lifecycle settingsExternal modificationsDynamic values changing
```

Process:

```
terraform planterraform state show
```

Compare:

```
Terraform stateAWS realityTerraform code
```

One of them differs.

---

# 83. Terraform apply hangs indefinitely. What would you investigate?

### Answer

Check:

```
AWS API throttlingProvider issuesNetwork issuesDependency loopsResource creation delays
```

Enable logging:

```
TF_LOG=DEBUG terraform apply
```

Common example:

```
EKS creationRDS creationNAT Gateway creation
```

These can legitimately take several minutes.

---

# 84. State lock remains after failed deployment. How would you recover?

### Answer

First verify:

```
No active deployment exists
```

Then:

```
terraform force-unlock LOCK_ID
```

Never force unlock blindly.

If another deployment is actually running:

```
State corruption risk
```

---

# 85. Terraform says a resource already exists. How do you troubleshoot?

### Answer

Example:

```
S3 bucket already exists
```

Possible causes:

```
Resource manually createdPrevious failed deploymentExisting unmanaged resource
```

Solution often:

```
terraform import
```

Bring resource under management.

---

# 86. Provider upgrade causes unexpected changes. How do you investigate?

### Answer

Check:

```
required_providers
```

Compare:

```
Old provider versionNew provider version
```

Review release notes carefully.

Provider upgrades frequently introduce:

```
New defaultsChanged behaviorDeprecated fields
```

---

# 87. Terraform apply partially succeeds and then fails. What happens next?

### Answer

Terraform updates state for successful resources.

Example:

```
VPC createdSubnets createdRDS failed
```

State contains:

```
VPCSubnets
```

Next apply continues from current state.

Terraform is not all-or-nothing.

---

# 88. A module upgrade breaks production. How would you recover?

### Answer

Rollback.

Example:

Current:

```
v3.0
```

Known good:

```
v2.4
```

Update:

```
?ref=v2.4
```

Run:

```
terraform plan
```

Review.

Apply carefully.

Always maintain module version history.

---

# 89. Why might Terraform show changes even when nothing changed?

### Answer

Common causes:

```
Computed valuesProvider bugsAPI normalizationTimestamp changesTag orderingExternal modifications
```

This is called:

```
Terraform noise
```

Senior engineers learn to distinguish:

```
Real changevsProvider noise
```

---

# 90. How would you investigate dependency issues in a large Terraform project?

### Answer

Generate graph:

```
terraform graph
```

Investigate:

```
Circular dependenciesIncorrect referencesImplicit dependenciesModule relationships
```

Large projects often fail due to dependency complexity rather than Terraform itself.

---

# 91. Your company has 2,000 AWS accounts. How would you structure Terraform?

### Answer

Never:

```
One stateOne repository2000 accounts
```

Architecture:

```
Organization│├── Shared Services├── Security├── Networking├── Production├── Non-Production
```

Separate:

```
RepositoriesStatesPipelines
```

per ownership boundary.

---

# 92. How would you design Terraform for a multi-cloud environment?

### Answer

Example:

```
AWSAzureGCP
```

Structure:

```
modules/├── aws├── azure├── gcp
```

Avoid pretending clouds are identical.

Many "multi-cloud abstractions" become maintenance nightmares.

Use shared patterns, not forced uniformity.

---

# 93. How would you implement platform engineering using Terraform?

### Answer

Platform team provides:

```
VPC modulesEKS modulesDatabase modulesSecurity modules
```

Application teams consume:

```
Approved building blocks
```

Goal:

```
Self-servicewith guardrails
```

Not:

```
Unlimited freedom
```

---

# 94. How would you enforce security policies before deployment?

### Answer

Use policy-as-code.

Examples:

- [Open Policy Agent (OPA)](https://www.openpolicyagent.org?utm_source=chatgpt.com)
- [HashiCorp Sentinel](https://developer.hashicorp.com/sentinel?utm_source=chatgpt.com)

Policies:

```
No public databasesEncryption mandatoryRestricted CIDRsMandatory tags
```

Violations fail before deployment.

---

# 95. Terraform state contains sensitive information. How would you secure it?

### Answer

State security is often overlooked.

Protect with:

```
Encrypted S3KMSIAM restrictionsVersioningPrivate access
```

Never:

```
Commit state to Git
```

Many breaches begin here.

---

# 96. When should Terraform NOT be used?

### Answer

Poor use cases:

```
Application deploymentFrequent runtime changesTemporary data manipulationDatabase records
```

Good use cases:

```
Infrastructure lifecycle
```

Terraform is not a universal automation tool.

---

# 97. How would you migrate a company from manual infrastructure to Terraform?

### Answer

Do not rebuild everything.

Process:

```
Inventory↓Import Existing Resources↓Validate↓Pilot Team↓Broader Adoption
```

Most failed migrations try to move everything simultaneously.

---

# 98. Your Terraform repository has 100,000 lines of code and 50 teams. How would you organize ownership?

### Answer

Split by domain.

Example:

```
Network TeamSecurity TeamPlatform TeamApplication Teams
```

Each team owns:

```
CodeStatePipelines
```

Ownership should be obvious.

---

# 99. Design a Terraform architecture capable of supporting thousands of deployments per day.

### Answer

Requirements:

```
Small statesModular designParallel pipelinesPolicy enforcementVersioned modulesAutomated testing
```

Architecture:

```
Git↓CI/CD↓Plan↓Policy Check↓Approval↓Apply
```

The bottleneck should never be Terraform itself.

---

# 100. At what scale do Terraform's limitations become visible, and what architectural changes would you make?

### Answer

Terraform starts showing strain when:

```
Huge state filesThousands of resources per stateLong lock durationsMany teams sharing ownership
```

Symptoms:

```
Slow plansSlow appliesFrequent contentionComplex dependencies
```

Solutions:

```
Smaller statesClear ownershipPlatform engineering modelModule standardizationAutomation
```

The answer is usually not:

```
Get a bigger server
```

The answer is:

```
Improve architecture
```

---

# The 10 Questions That Separate Experts From Everyone Else

If an interviewer asks these and you answer them well, you're typically operating at Senior/Lead level:

1. Explain Terraform state internals.
2. How would you recover from complete state loss?
3. Why does Terraform need state?
4. How would you structure Terraform for 1000 AWS accounts?
5. How do you prevent accidental production destruction?
6. How would you migrate manually built infrastructure into Terraform?
7. How would you design reusable enterprise modules?
8. How do you handle drift at scale?
9. How do you secure Terraform state?
10. At what point does Terraform architecture become the problem instead of Terraform itself?

If you can answer those deeply, you're no longer being evaluated on Terraform syntax. You're being evaluated on systems thinking, reliability, governance, recovery, and platform architecture—the areas that align most closely with Staff Platform Engineer, SRE, and Infrastructure Architect roles.
