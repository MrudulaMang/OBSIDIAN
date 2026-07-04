**STS** stands for **AWS Security Token Service**.

It is the AWS service that issues **temporary security credentials** (Access Key ID, Secret Access Key, and Session Token).

Think of it this way:

- IAM User → Permanent credentials
- STS → Temporary credentials

Temporary credentials are more secure because they expire automatically.

### How STS works with IRSA

When a pod starts in EKS:

```
Pod   ↓Service Account   ↓OIDC Token   ↓AWS STS   ↓AssumeRoleWithWebIdentity   ↓Temporary Credentials   ↓S3 / DynamoDB / SQS
```

The pod never stores permanent AWS keys.

Instead:

1. Kubernetes gives the pod a signed OIDC token.
2. The pod sends that token to AWS STS.
3. STS verifies the token.
4. STS checks whether the IAM role trusts your EKS OIDC provider.
5. If everything matches, STS returns temporary credentials.
6. The AWS SDK uses those credentials automatically.

### Example

Suppose your application needs to upload files to S3.

Without STS:

```
Pod   ↓AWS Access KeyAWS Secret Key
```

Problems:

- Keys can be leaked.
- Manual rotation is required.
- Long-lived credentials increase risk.

With STS:

```
Pod   ↓STS   ↓Temporary Credentials (valid for a limited time)   ↓S3
```

After the credentials expire, new temporary credentials are obtained automatically.

### Common STS APIs

- **AssumeRole** – Assume another IAM role (commonly used across AWS accounts).
- **AssumeRoleWithWebIdentity** – Used by **IRSA** with EKS.
- **GetCallerIdentity** – Returns the identity of the current AWS principal. This is a common troubleshooting command.

Example:

```
aws sts get-caller-identity
```

Output:

```
{  "UserId": "AROA...",  "Account": "123456789012",  "Arn": "arn:aws:sts::123456789012:assumed-role/s3-role/session-name"}
```

### Interview question

**Q: Does IRSA directly give credentials to the pod?**

**Answer:** No. IRSA provides the pod with an OIDC web identity token. The pod uses that token to call **AWS STS** (`AssumeRoleWithWebIdentity`), and **STS** returns temporary AWS credentials. Those credentials are then used by the AWS SDK or CLI to access AWS services. This distinction is important and often comes up in EKS interviews.