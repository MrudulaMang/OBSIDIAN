When applying changes to aws_route53_record.jenkins_agent, provider │ "provider["registry.terraform.io/hashicorp/aws"]" produced an unexpected new value: Root object was │ present, but now absent. │ │ This is a bug in the provider, which should be reported in the provider's own issue tracker.

  sol:--------terraform refresh && terraform apply -autoapprove
  ---------------
This error is not your Terraform code failing first—it is the AWS provider returning inconsistent state.

The key line is:

`provider produced an unexpected new value: Root object was present, but now absent`

That means during `apply`, Terraform created or updated `aws_route53_record.jenkins_agent`, then asked the AWS provider to read it back. The provider expected the object to exist, but the refresh returned “not found” (or null), so Terraform treats it as a provider inconsistency.

This is often caused by one of these:

1. Eventual consistency in AWS Route53  
    AWS accepted the change, but immediate read-after-write failed because DNS propagation/record visibility lagged.
2. Record already exists / overwritten externally  
    Another process (manual change, pipeline, another Terraform state) changed or deleted it.
3. Wrong zone_id  
    Terraform writes to one hosted zone but reads from another expectation.
4. `allow_overwrite` behavior issues
5. AWS provider bug  
    Especially common with certain provider versions.

What to check:

Example resource:

```
resource "aws_route53_record" "jenkins_agent" {  zone_id = var.zone_id  name    = "jenkins-agent.example.com"  type    = "A"  ttl     = 300  records = ["1.2.3.4"]  allow_overwrite = true}
```

Actions:

1. Check provider version

```
terraform {  required_providers {    aws = {      source  = "hashicorp/aws"      version = "~> 5.0"    }  }}
```

Do not leave provider versions loose. Pin them.

Then run:

```
terraform init -upgrade
```

Sometimes upgrading fixes it; sometimes downgrading does.

2. Verify Route53 manually

Go to Amazon Web Services console → Route53 → Hosted Zones

Check:

- correct hosted zone
- record really exists
- same name/type
- no duplicate conflicting record

3. Refresh state

```
terraform refresh
```

or

```
terraform apply -refresh-only
```

4. Import existing record if already present

```
terraform import aws_route53_record.jenkins_agent ZONEID_recordname_type
```

Example:

```
terraform import aws_route53_record.jenkins_agent Z123456789ABC_example.com_A
```

5. Retry apply

Sometimes Route53 consistency delay causes temporary failure.

```
terraform apply
```

6. If using `count` / `for_each`, verify indexing carefully

Sometimes the object is created then index changes cause disappearance.

Hard truth: many engineers waste hours “fixing Terraform” when the actual problem is state drift or wrong hosted zone. Start there first.

Show me your `aws_route53_record.jenkins_agent` block and I’ll tell you where the real fault likely is.


  