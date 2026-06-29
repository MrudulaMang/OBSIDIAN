# ☁️ AWS Infrastructure with Terraform

> Modular, production-ready AWS infrastructure — VPC, EKS cluster, RDS, ALB, and IAM — built with reusable Terraform modules.

## 🏗️ What Gets Provisioned

```
AWS Account
└── VPC (3 AZs)
    ├── Public Subnets → ALB, NAT Gateways
    ├── Private Subnets → EKS Worker Nodes
    └── Database Subnets → RDS (Multi-AZ)
        ├── EKS Cluster + Node Groups
        ├── RDS PostgreSQL (encrypted)
        ├── ALB + Target Groups
        ├── IAM Roles & Policies
        └── S3 Remote State (with DynamoDB lock)
```

## 📁 Repo Structure

```
terraform-aws-infra/
├── modules/
│   ├── vpc/
│   ├── eks/
│   ├── rds/
│   └── alb/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       └── terraform.tfvars
├── backend.tf
└── README.md
```

## 🔑 Key Snippet — EKS Module

```hcl
module "eks" {
  source          = "../../modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids

  node_groups = {
    general = {
      desired_size   = 2
      min_size       = 1
      max_size       = 5
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
    spot = {
      desired_size   = 2
      min_size       = 0
      max_size       = 10
      instance_types = ["t3.medium", "t3.large"]
      capacity_type  = "SPOT"
    }
  }
}
```

## 🚀 How to Run

```bash
cd environments/dev
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```