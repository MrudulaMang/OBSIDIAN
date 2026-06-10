templatefile

`templatefile()` is one of the most useful Terraform functions when you want to generate a file dynamically.

Basic syntax:

```
templatefile(path, vars)
```

- `path` → template file location
- `vars` → map of variables passed into the template

---

Your example:

```
resource "aws_iam_policy" "mysql" {  policy = templatefile("mysql-iam-policy.json", {    environment = var.environment  })}
```

Terraform reads:

```
mysql-iam-policy.json
```

and replaces:

```
${environment}
```

with:

```
dev
```

or

```
prod
```

depending on the variable value.

---

Example template file:

`mysql-iam-policy.json`

```
{  "Version": "2012-10-17",  "Statement": [    {      "Effect": "Allow",      "Action": [        "ssm:GetParameter"      ],      "Resource": [        "arn:aws:ssm:us-east-1:*:parameter/roboshop/${environment}/mysql_root_password"      ]    }  ]}
```

Suppose:

```
environment = "dev"
```

Terraform generates:

```
{  "Version": "2012-10-17",  "Statement": [    {      "Effect": "Allow",      "Action": [        "ssm:GetParameter"      ],      "Resource": [        "arn:aws:ssm:us-east-1:*:parameter/roboshop/dev/mysql_root_password"      ]    }  ]}
```

and sends that JSON to AWS.

---

Why not use:

```
policy = file("mysql-iam-policy.json")
```

?

Because `file()` simply reads the file as-is.

No variable substitution.

Example:

```
{  "Resource": "arn:aws:ssm:::parameter/roboshop/${environment}/mysql_root_password"}
```

AWS would literally receive:

```
${environment}
```

which is invalid.

---

Think of it like:

```
file()   ↓Read onlytemplatefile()   ↓Read   ↓Replace variables   ↓Return generated content
```

---

Common DevOps use cases:

### IAM Policies

```
policy = templatefile(...)
```

### User Data Scripts

Template:

```
#!/bin/bashecho "${environment}" > /tmp/env
```

Terraform:

```
user_data = templatefile("userdata.sh", {  environment = var.environment})
```

---

### Ansible Inventories

Template:

```
[mongodb]${mongodb_ip}
```

Terraform:

```
templatefile("inventory.tpl", {  mongodb_ip = aws_instance.mongodb.private_ip})
```

---

In Roboshop, the reason your trainer used:

```
templatefile("mysql-iam-policy.json", {  environment = var.environment})
```

instead of:

```
file("mysql-iam-policy.json")
```

is because the IAM policy ARN must change per environment:

```
/roboshop/dev/mysql_root_password/roboshop/prod/mysql_root_password/roboshop/qa/mysql_root_password
```

and `templatefile()` lets a single policy template work for all environments.