# terraform/environments/prod/main.tf
# Production environment — all modules wired together

terraform {
  required_version = ">= 1.6"

  backend "s3" {
    bucket         = "myorg-terraform-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }

  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = var.aws_region

  # Enforce tagging — every resource must have these tags
  default_tags {
    tags = {
      Environment = "prod"
      ManagedBy   = "terraform"
      Repo        = "aws-production-platform"
    }
  }
}

locals {
  cluster_name = "myorg-prod"
  environment  = "prod"
}

# ── VPC ───────────────────────────────────────────────────────────────────────
module "vpc" {
  source = "../../modules/vpc"

  name               = local.cluster_name
  vpc_cidr           = "10.0.0.0/16"
  cluster_name       = local.cluster_name
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  tags = {
    Environment = local.environment
    Team        = "platform"
  }
}

# ── EKS ───────────────────────────────────────────────────────────────────────
module "eks" {
  source = "../../modules/eks"

  cluster_name       = local.cluster_name
  cluster_version    = "1.29"
  environment        = local.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  # Prod: public API endpoint disabled — access only via VPN/bastion
  enable_public_endpoint = false

  tags = {
    Environment = local.environment
    Team        = "platform"
  }
}

# ── RDS PostgreSQL (Multi-AZ) ─────────────────────────────────────────────────
module "rds" {
  source = "../../modules/rds"

  identifier        = "${local.cluster_name}-postgres"
  engine_version    = "15.4"
  instance_class    = "db.r6g.large"
  multi_az          = true
  subnet_ids        = module.vpc.database_subnet_ids
  vpc_id            = module.vpc.vpc_id
  environment       = local.environment

  # Automated backups — 30 day retention in prod
  backup_retention_period  = 30
  backup_window            = "03:00-04:00"
  maintenance_window       = "sun:04:00-sun:05:00"
  deletion_protection      = true
  skip_final_snapshot      = false

  tags = {
    Environment = local.environment
    Team        = "platform"
  }
}

# ── ALB + Nginx Ingress ───────────────────────────────────────────────────────
module "alb" {
  source = "../../modules/alb"

  name             = "${local.cluster_name}-alb"
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  environment      = local.environment
  certificate_arn  = data.aws_acm_certificate.main.arn

  tags = {
    Environment = local.environment
    Team        = "platform"
  }
}

data "aws_acm_certificate" "main" {
  domain   = "*.myorg.com"
  statuses = ["ISSUED"]
}
