These are topics that usually appear when multiple teams and hundreds or thousands of resources are managed with Terraform.

### Policy Enforcement

Policy enforcement means **preventing engineers from creating infrastructure that violates company rules**.

Without policies:

```
resource "aws_s3_bucket" "demo" {  bucket = "my-bucket"}
```

An engineer might accidentally create:

- Public S3 buckets
- Unencrypted EBS volumes
- Large expensive EC2 instances
- Resources without tags

The company wants to stop this **before `terraform apply` succeeds**.

Examples of policies:

**Policy 1: Every resource must have tags**

```
OwnerEnvironmentCostCenter
```

If tags are missing:

```
terraform apply
```

fails.

---

**Policy 2: No public S3 buckets**

Developer creates:

```
public_access = true
```

Policy engine blocks deployment.

---

**Policy 3: Only approved instance types**

Allowed:

```
t3.microt3.smallt3.medium
```

Blocked:

```
m7i.16xlarge
```

This prevents huge cloud bills.

---

Tools used:

- HashiCorp Sentinel
- Open Policy Agent
- HCP Terraform Policy Sets

Think of policy enforcement as:

> Security guard standing between `terraform plan` and `terraform apply`.