**IRSA** stands for **IAM Roles for Service Accounts**.

It is an AWS feature used with **Amazon Elastic Kubernetes Service** that allows a Kubernetes pod to assume an AWS IAM role without storing AWS access keys.

Instead of this:

```
Pod  ↓AWS Access Key + Secret Key (stored as Secret)
```

You use this:

```
Pod   ↓Kubernetes Service Account   ↓OIDC Token   ↓IAM Role (IRSA)   ↓AWS Services (S3, DynamoDB, SQS, etc.)
```

### Why use IRSA?

Suppose your application needs to upload files to S3.

Without IRSA:

- You store AWS access keys in Kubernetes Secrets.
- Keys must be rotated.
- If the keys are leaked, they can be misused.

With IRSA:

- No access keys are stored.
- AWS issues temporary credentials automatically.
- More secure and easier to manage.

### How it works

1. Create an **IAM Role** with the required permissions (for example, `AmazonS3ReadOnlyAccess`).
2. Enable an **OIDC provider** for your EKS cluster.
3. Create a Kubernetes **ServiceAccount**.
4. Annotate the ServiceAccount with the IAM Role ARN.
5. Configure your pod to use that ServiceAccount.
6. The pod receives temporary AWS credentials automatically.

### Example

ServiceAccount:

```
apiVersion: v1kind: ServiceAccountmetadata:  name: app-sa  annotations:    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/s3-role
```

Pod:

```
spec:  serviceAccountName: app-sa
```

Inside the pod:

```
aws s3 ls
```

The AWS CLI automatically uses the IAM role attached through IRSA. No access keys are needed.

### Common interview question

**Q: Why is IRSA better than attaching an IAM role to the EC2 worker node?**

**Answer:**  
If an IAM role is attached to the worker node, **every pod on that node** can potentially access the same AWS permissions. With IRSA, **each pod (via its ServiceAccount)** gets only the permissions it needs, following the principle of least privilege. This provides stronger security and finer-grained access control.

For Senior DevOps interviews, expect follow-up questions on:

- How OIDC is involved in IRSA.
- The trust relationship in the IAM role.
- How AWS Security Token Service (STS) issues temporary credentials.
- How to troubleshoot an IRSA configuration when a pod gets `AccessDenied` errors.