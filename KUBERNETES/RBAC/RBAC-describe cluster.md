## What is `eks:DescribeCluster` (EKS Cluster Describe Role)?

In AWS, **`eks:DescribeCluster`** is an IAM permission (not a role by itself) that allows an entity (user/role/service) to **retrieve details about an Amazon EKS cluster**.

👉 It is part of **AWS IAM (Identity and Access Management)** and used with **Amazon EKS (Elastic Kubernetes Service)**.

---

## 🔹 What does `DescribeCluster` actually do?

When you call:

aws eks describe-cluster --name <cluster-name>

It returns:

- API server endpoint
- Cluster certificate authority data
- Kubernetes version
- VPC configuration
- Cluster status (ACTIVE, CREATING, etc.)

---

## 🔹 Why is it important?

This permission is **critical for Kubernetes access setup**, especially:

### 1. kubectl authentication

When you run:

kubectl get pods

Behind the scenes:

- AWS CLI calls `DescribeCluster`
- Fetches endpoint + certificate
- Uses IAM auth to connect

👉 Without `eks:DescribeCluster`, **kubectl cannot connect to the cluster**

---

### 2. Used in `aws eks update-kubeconfig`

aws eks update-kubeconfig --name my-cluster

This command:

- Calls `DescribeCluster`
- Writes kubeconfig file

---

## 🔹 Example IAM Policy

{  
  "Effect": "Allow",  
  "Action": "eks:DescribeCluster",  
  "Resource": "*"  
}

👉 In production, you should scope this to specific cluster ARN.

---

## 🔹 Real-world usage

Typical roles that need this permission:

- **Developers** accessing cluster via kubectl
- **CI/CD pipelines** (GitHub Actions, Jenkins)
- **Automation tools** (Terraform, ArgoCD bootstrap)

---

## 🔹 Best Practices (Senior-level insight)

### ✅ Principle of least privilege

Instead of:

"Resource": "*"

Use:

"Resource": "arn:aws:eks:<region>:<account-id>:cluster/<cluster-name>"

---

### ✅ Combine with IAM Auth + RBAC

`eks:DescribeCluster` only gives **cluster metadata**, not Kubernetes access.

You ALSO need:

- IAM role mapped in `aws-auth` ConfigMap
- Kubernetes RBAC permissions

---

## 🔹 Common Mistakes (Interview GOLD)

❌ Thinking this gives full cluster access  
→ It only returns metadata

❌ Forgetting this permission in CI/CD  
→ Pipelines fail with:

AccessDeniedException: eks:DescribeCluster

❌ Confusing IAM vs Kubernetes RBAC  
→ IAM lets you reach cluster  
→ RBAC decides what you can do

---

## 🔹 Failure Scenario

Imagine:

- You created EKS cluster
- Gave developer IAM role
- But forgot `eks:DescribeCluster`

👉 Result:

kubectl get pods → fails

Even before RBAC kicks in!

---

## 🔹 Advanced Insight (What interviewers love)

When kubectl authenticates to EKS:

1. Calls `DescribeCluster`
2. Gets endpoint + CA cert
3. Uses AWS IAM Authenticator
4. Maps IAM → Kubernetes user via `aws-auth`

👉 So this permission is part of the **authentication chain**

---

## 🔹 Quick Interview Answer

If asked:

> What is `eks:DescribeCluster`?

👉 Answer:

> It’s an IAM permission in AWS EKS that allows retrieving cluster metadata like endpoint and certificate. It’s required for tools like kubectl and `aws eks update-kubeconfig` to connect to the cluster, but it does not grant Kubernetes-level access, which is controlled separately via RBAC.

---

## 🔹 Your turn (mock interview)

1. Why does `kubectl` fail without `eks:DescribeCluster` even if RBAC is correct?
2. What permissions are needed for full EKS access (IAM + Kubernetes)?
3. How would you debug an `AccessDeniedException` for EKS?

Answer these, and I’ll refine you to **senior-level clarity** 🚀