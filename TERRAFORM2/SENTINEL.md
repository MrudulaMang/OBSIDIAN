Interview answer:

> Sentinel is HashiCorp's policy-as-code framework used in Terraform Cloud and Terraform Enterprise. It evaluates Terraform plans against organizational security, compliance, operational, and cost policies before infrastructure changes are applied.

Notice the term **Policy as Code**.

Just like Terraform is:

```
Infrastructure as Code
```

Sentinel is:

```
Policy as Code
```

That phrase alone will score points in a Terraform interview.

**Sentinel** is HashiCorp's policy engine used with Terraform Cloud and Terraform Enterprise.

Think of it as:

```
Terraform = Creates infrastructureSentinel = Checks if infrastructure follows company rules
```

Example:

Engineer writes:

```
resource "aws_s3_bucket" "test" {  bucket = "my-bucket"}
```

Company policy:

```
All S3 buckets must be encrypted
```

Sentinel evaluates the Terraform plan before apply.

Result:

```
❌ Policy Check FailedS3 bucket encryption missing
```

Apply is blocked.

---

Common Sentinel policies:

### Security

```
No public S3 bucketsAll EBS volumes encryptedNo 0.0.0.0/0 on database ports
```

### Operational

```
Every resource must have tags:- Owner- Environment- Project
```

### Cost

```
Dev can only use t3.smallNo GPU instances without approval
```

### Compliance

```
Only deploy to approved AWS regions
```

---

Flow:

```
Git Push    ↓Terraform Plan    ↓Sentinel Policies    ↓Pass?    ↓Terraform Apply
```

If any policy fails:

```
❌ Apply Blocked
```