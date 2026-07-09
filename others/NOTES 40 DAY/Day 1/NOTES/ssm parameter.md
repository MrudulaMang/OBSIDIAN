**Why mature DevOps teams split Terraform into multiple stacks instead of one giant Terraform project.**

That concept ties directly into **state management, blast radius, and production reliability**.
# 1️⃣ Network Stack


Creates core infrastructure.

network-stack creates:  
VPC  
Subnets  
Internet Gateway  
Route tables

Example:

module "vpc" {  
  source = "../modules/vpc"  
  
  project     = var.project  
  environment = var.environment  
}

After creating VPC, it **stores IDs in SSM**.

resource "aws_ssm_parameter" "vpc_id" {  
  name  = "/${var.project}/${var.environment}/vpc_id"  
  type  = "String"  
  value = module.vpc.vpc_id  
}

---

# 2️⃣ Security Stack

Security team deploys this separately.

Instead of reading **Terraform state**, it reads from **SSM**.

data "aws_ssm_parameter" "vpc_id" {  
  name = "/${var.project}/${var.environment}/vpc_id"  
}

Then:

module "alb_sg" {  
  source = "../modules/security-group"  
  
  vpc_id = data.aws_ssm_parameter.vpc_id.value  
}

---

# 3️⃣ Application Stack

Application stack reads both **network + security information**.

Example:

data "aws_ssm_parameter" "private_subnet_1" {  
  name = "/${var.project}/${var.environment}/private_subnet_1"  
}  
  
data "aws_ssm_parameter" "alb_sg" {  
  name = "/${var.project}/${var.environment}/alb_sg"  
}

Then used in:

module "ec2" {  
  source = "../modules/ec2"  
  
  subnet_id         = data.aws_ssm_parameter.private_subnet_1.value  
  security_group_id = data.aws_ssm_parameter.alb_sg.value  
}

---

# Complete Flow

Network stack  
   │  
   │ creates VPC  
   │  
   ▼  
SSM Parameter Store  
/project/dev/vpc_id  
/project/dev/private_subnet_1  
/project/dev/private_subnet_2  
   │  
   │  
   ▼  
Security stack reads VPC ID  
   │  
   ▼  
creates security groups  
   │  
   ▼  
stores SG ID in SSM  
  
Application stack reads  
VPC / subnet / SG IDs

------------------------------------------------------------
**==In large Terraform projects, you may have many parameters stored in SSM like this:==**

/project/dev/vpc_id  
/project/dev/private_subnet_1  
/project/dev/private_subnet_2  
/project/dev/alb_sg  
/project/dev/db_endpoint  
/project/dev/cache_endpoint

If you fetch them normally, you would need **many data blocks**.

Example (messy):

data "aws_ssm_parameter" "vpc_id" {  
  name = "/project/dev/vpc_id"  
}  
data "aws_ssm_parameter" "private_subnet_1" {  
  name = "/project/dev/private_subnet_1"  
}  
  data "aws_ssm_parameter" "private_subnet_2" {  
  name = "/project/dev/private_subnet_2"  
}
In big infrastructure this can become **30–50 blocks**, which becomes hard to maintain.

If a system has **100 parameters**, Terraform makes **100 API calls**.

That slows down:
- `terraform plan`
    
- `terraform apply`
    
- CI/CD pipelines

---

# Cleaner Production Trick (Used by senior Terraform engineers)

Use **`aws_ssm_parameters_by_path`** to fetch everything at once.

Example:

data "aws_ssm_parameters_by_path" "infra" {  
  path = "/${var.project}/${var.environment}/"  
}

Now Terraform fetches **all parameters under that path**.

---

# What Terraform receives

Example SSM:

/project/dev/vpc_id  
/project/dev/private_subnet_1  
/project/dev/private_subnet_2

Terraform internally gets:

names  = [...]  
values = [...]

---

# Convert it into a map (very useful)

locals {  
  ssm_map = zipmap(  
    data.aws_ssm_parameters_by_path.infra.names,  
    data.aws_ssm_parameters_by_path.infra.values  
  )  
}

Now you can access values like this:
	local.ssm_map["/project/dev/vpc_id"]
	or
	local.ssm_map["/project/dev/private_subnet_1"]

---

# Final usage example

module "ec2" {  
  source = "../modules/ec2"  
   vpc_id    = local.ssm_map["/project/dev/vpc_id"]  
  subnet_id = local.ssm_map["/project/dev/private_subnet_1"]  
}

# example2==**

data "aws_ssm_parameters_by_path" "network" {
  path = "/${var.project}/${var.environment}/network/"
}

locals {
  params = zipmap(
    data.aws_ssm_parameters_by_path.network.names,
    data.aws_ssm_parameters_by_path.network.values
  )
}

module "ec2" {
  source = "../modules/ec2"

  vpc_id = local.params["/project/${var.environment}/network/vpc_id"]
}
---
# Why this is powerful

Instead of:
20+ data blocks
you use:
1 data block
This becomes **much easier to maintain in large infrastructure**.

---
# Real DevOps architecture

Network stack  
   │  
   ▼  
Writes infrastructure IDs to SSM  
  
/project/dev/*  
   │  
   ▼  
Application stack  
   │  
   ▼  
Fetches entire path