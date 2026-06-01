TERRAFORM
│
├── 1. FUNDAMENTALS
│   ├── What is IaC?
│   ├── Declarative vs Imperative
│   ├── Terraform Workflow
│   │   ├── init
│   │   ├── plan
│   │   ├── apply
│   │   └── destroy
│   ├── Providers
│   └── Resources
│
├── 2. TERRAFORM LANGUAGE (HCL)
│   ├── Variables
│   │   ├── types
│   │   ├── default
│   │   └── tfvars
│   ├── Locals
│   ├── Outputs
│   ├── Expressions
│   ├── Functions
│   ├── Conditionals
│   ├── Loops
│   │   ├── count
│   │   └── for_each
│   └── Dynamic Blocks
│
├── 3. STATE MANAGEMENT
│   ├── terraform.tfstate
│   ├── Why state is needed
│   ├── State locking
│   ├── Remote State
│   │   ├── S3
│   │   └── Terraform Cloud
│   ├── DynamoDB Locking
│   ├── State Drift
│   ├── Refresh
│   ├── State Commands
│   │   ├── state list
│   │   ├── state show
│   │   ├── state mv
│   │   └── state rm
│   └── Import Existing Resources
│
├── 4. BACKEND
│   ├── Local Backend
│   ├── S3 Backend
│   ├── Backend Migration
│   ├── init
│   ├── init -reconfigure
│   └── init -migrate-state
│
├── 5. MODULES
│   ├── What is a module?
│   ├── Root Module
│   ├── Child Module
│   ├── Inputs
│   ├── Outputs
│   ├── Module Sources
│   │   ├── Local
│   │   ├── Git
│   │   └── Registry
│   ├── Reusability
│   └── Module Versioning
│
├── 6. DEPENDENCIES
│   ├── Implicit Dependencies
│   ├── Explicit Dependencies
│   │   └── depends_on
│   ├── Resource Graph
│   └── Parallel Resource Creation
│
├── 7. DATA SOURCES
│   ├── Resource vs Data Source
│   ├── Existing VPC
│   ├── Existing AMI
│   └── Existing Security Groups
│
├── 8. PROVISIONERS
│   ├── local-exec
│   ├── remote-exec
│   ├── file
│   └── Why provisioners are discouraged
│
├── 9. WORKSPACES
│   ├── default workspace
│   ├── dev
│   ├── qa
│   └── prod
│
├── 10. TERRAFORM FUNCTIONS
│   ├── lookup
│   ├── merge
│   ├── concat
│   ├── split
│   ├── join
│   ├── format
│   └── element
│
├── 11. TERRAFORM TESTING & QUALITY
│   ├── terraform validate
│   ├── terraform fmt
│   ├── terraform plan
│   ├── TFLint
│   ├── Checkov
│   └── Terratest
│
├── 12. SECURITY
│   ├── Sensitive Variables
│   ├── Secrets Management
│   ├── SSM Parameter Store
│   ├── Secrets Manager
│   ├── State File Security
│   └── Least Privilege IAM
│
├── 13. ADVANCED
│   ├── Lifecycle Rules
│   │   ├── create_before_destroy
│   │   ├── prevent_destroy
│   │   └── ignore_changes
│   ├── Null Resource
│   ├── Target Resources
│   ├── Provider Aliases
│   ├── Multi-Region Deployments
│   └── Multi-Account Deployments
│
└── 14. REAL-WORLD SCENARIOS
    ├── Drift Handling
    ├── Backend Migration
    ├── State Corruption
    ├── Resource Renaming
    ├── Import Existing Infra
    ├── CI/CD Integration
    ├── Terraform + Jenkins
    ├── Terraform + GitHub Actions
    └── Terraform Troubleshooting