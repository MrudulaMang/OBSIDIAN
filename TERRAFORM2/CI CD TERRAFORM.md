how do we use terrform in ci/cd, we dont create infra everytime we run the pipeline, why to include in ci/cd

Correct. In mature environments, Terraform is usually not creating infrastructure on every pipeline run.

That misunderstanding comes from thinking:  
“CI/CD = recreate infra every time.”

That is not how Terraform works.

Terraform in CI/CD is mainly about:

- controlled infrastructure changes
- automation
- consistency
- governance
- reviewability
- safe deployments

Think of it like Git for infrastructure.

Typical Flow

Developer changes Terraform code:

```
Change security groupAdd subnetUpdate autoscalingModify IAM policy
```

Then pipeline runs:

```
terraform fmtterraform validateterraform planmanual approvalterraform apply
```

Terraform compares:

```
Current State  vs  Desired State
```

If nothing changed:

```
No changesInfrastructure matches configuration
```

So pipeline execution does NOT mean:

- recreate servers
- rebuild VPC
- destroy infra

Terraform is declarative and state-aware.

Why Use Terraform in CI/CD?

1. Automation

Without CI/CD:

```
Engineer laptop    ↓Manual terraform apply
```

Problems:

- inconsistent environments
- human mistakes
- no audit trail
- dependency on one engineer

With CI/CD:

```
Git Push   ↓Pipeline   ↓Terraform Plan   ↓Approval   ↓Terraform Apply
```

Everything becomes reproducible.

2. Team Collaboration

CI/CD enables:

- pull request reviews
- infrastructure approvals
- shared workflows
- version-controlled infra

Example:

```
Developer creates PRTeam reviews Terraform planApproved changes get applied
```

This is critical in production.

3. Prevent Direct Production Changes

Without CI/CD:

- engineers run Terraform locally
- local credentials access prod
- state inconsistency risk

With CI/CD:

- centralized execution
- controlled credentials
- standardized pipeline

4. Drift Detection

Pipelines can detect:

```
Actual AWS Infra ≠ Terraform Code
```

Example:  
Someone manually changes security group in AWS console.

Terraform plan later shows drift.

5. Safe Change Review

Very important.

Pipeline generates plan:

```
terraform plan
```

Team reviews:

- what changes
- what gets replaced
- what gets destroyed

Prevents accidental outages.

6. Multi-Environment Consistency

Same pipeline deploys:

- dev
- qa
- staging
- prod

Using different:

- variables
- workspaces
- backends

7. Compliance & Auditability

CI/CD gives:

- who changed infra
- when it changed
- approved by whom
- exact plan applied

This matters heavily in enterprises.

Important Reality

Terraform pipelines usually do NOT run `apply` on every commit.

Common pattern:

Pull Request:

```
fmtvalidateplan
```

Merge to main:

```
apply
```

Production:

```
manual approval before apply
```

Another critical distinction:

Application CI/CD ≠ Infrastructure CI/CD

Application pipeline:

```
Build appRun testsDeploy container
```

Terraform pipeline:

```
Manage infrastructure lifecycle
```

Different responsibilities.

Where Terraform Fits

```
GitHub / GitLab / Jenkins            ↓Terraform Pipeline            ↓Cloud Infrastructure            ↓Servers / VPC / IAM / K8s / DB
```

A practical production model:

Infra changes are relatively infrequent.

Examples:

- new VPC
- add subnet
- update nodegroup
- modify IAM role
- scale infrastructure
- create RDS
- add monitoring

Terraform pipeline exists so those changes happen:

- safely
- predictably
- reviewably
- reproducibly

Not continuously recreating infrastructure.