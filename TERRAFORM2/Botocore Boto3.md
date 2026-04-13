In your anisble playbook, somewhere you are doing something like:

lookup('aws_ssm', 'mysqlrootpassword')

👉 This lookup plugin:

- Calls AWS SSM API
- Uses IAM role attached to EC2
- Internally uses:
    - `boto3`
    - `botocore`# 🧠 WHAT YOU BUILT (CLEAR FLOW)

You said:

> EC2 (MySQL) has IAM Role → access SSM Parameter (`mysqlrootpassword`)

So actual flow is:

Ansible → calls AWS SSM → gets password → configures MySQL

👉 That **AWS call** = requires `boto3`