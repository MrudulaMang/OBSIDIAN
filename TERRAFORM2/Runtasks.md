The announcement is actually quite simple.

Before this feature, Terraform Run Tasks could only be attached at:

1. Organization level (applies everywhere)
2. Workspace level (applies to one workspace)

Now HashiCorp has added a third level:

3. Project level (applies to all workspaces inside a project)

Why this matters:

Imagine you have 500 Terraform workspaces.

```
Organization├── Project: Production│   ├── prod-app1│   ├── prod-app2│   └── prod-app3│├── Project: Dev│   ├── dev-app1│   └── dev-app2
```

You may want strict security checks only for Production.

Previously:

- Add run task to each production workspace manually.
- Every new workspace required manual configuration.

Now:

- Attach run task once to the Production project.
- Any workspace added to that project automatically inherits the run task.

What are Run Tasks?

Run Tasks are hooks that Terraform executes during a Terraform run to integrate with external tools. They allow other systems to inspect or approve infrastructure changes before Terraform continues.

Typical flow:

```
terraform plan      ↓Run Task executes      ↓Security tool checks plan      ↓PASS → continueFAIL → stop run
```

Common examples:

- Security scanning
    - Check for public S3 buckets
    - Check for open security groups
- Compliance validation
    - Ensure resources have mandatory tags
    - Ensure encryption is enabled
- Cost analysis
    - Estimate monthly cloud cost
    - Block expensive changes
- Operational checks
    - Change management approvals
    - Internal policy validation

Examples of tools often integrated with Run Tasks:

- Sentinel
- OPA
- Wiz
- Prisma Cloud
- Infracost
- Custom internal APIs

For a DevOps engineer, think of Run Tasks as:

> "Automatic quality gates for infrastructure deployments."

Just as CI/CD pipelines have:

```
Build → Test → Security Scan → Deploy
```

Terraform can have:

```
Plan → Run Task → Policy Check → Apply
```

The real value of this new feature is not the run task itself. Run Tasks already existed. The value is **governance at scale**. Platform teams can now enforce controls at the Project level instead of managing hundreds of workspaces individually, reducing configuration drift and operational overhead.

From an interview perspective, if someone asks why Project-level Run Tasks were added, the answer is:

> Organizations needed a governance layer between Organization-wide policies (too broad) and Workspace-specific policies (too granular). Project-level Run Tasks provide inherited security, compliance, and operational controls for groups of related workspaces.