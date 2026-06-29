# 🎯 8. Interview Answer (use this)

If asked:

> “How do you manage AMIs in production?”

👉 You say:
We follow a golden AMI approach.

We bake AMIs using Packer, test them in lower environments,
then promote the same AMI across dev, staging, and production.

We store approved AMI IDs in SSM Parameter Store and Terraform consumes them,
ensuring consistency and controlled rollouts instead of using dynamic AMI lookups.

# 🔥 1. The Real Problem You’re Solving

This is NOT about “getting an AMI ID”.

It’s about:

“How do I safely roll out machine images across environments without breaking production?”

---

# 🧠 2. The Production AMI Lifecycle (Golden Flow)

![https://www.tecracer.com/blog/img/2023/11/golden-ami-pipeline-with-packer-architecture.png](https://www.tecracer.com/blog/img/2023/11/golden-ami-pipeline-with-packer-architecture.png)

![https://d2908q01vomqb2.cloudfront.net/761f22b2c1593d0bb87e0b606f990ba4974706de/2018/05/16/GAP-process.png](https://d2908q01vomqb2.cloudfront.net/761f22b2c1593d0bb87e0b606f990ba4974706de/2018/05/16/GAP-process.png)

![https://miro.medium.com/1%2AYGIMRqRcFZ_nWGUUs3Dr1Q.jpeg](https://miro.medium.com/1%2AYGIMRqRcFZ_nWGUUs3Dr1Q.jpeg)

4

### Flow:

1. Build AMI (Packer)  
2. Test AMI  
3. Approve AMI  
4. Store in SSM  
5. Deploy via Terraform

---

# 🔧 3. Step-by-Step Breakdown

## 🔹 Step 1: Build AMI (Image Baking)

Use **HashiCorp Packer**

👉 You create a custom AMI with:

- OS
- MongoDB / app dependencies
- configs
- security patches

Result: ami-12345 (your custom image)

---

## 🔹 Step 2: Test the AMI

Before using it anywhere:

- Launch temp EC2
- Run:
    - service checks
    - port checks
    - health tests

👉 If this step is skipped → production outages

---

## 🔹 Step 3: Promote (THIS is key mindset)

You don’t directly push to prod.

dev → staging → prod

Same AMI moves forward.

👉 This gives:

- consistency
- confidence

---

## 🔹 Step 4: Store in SSM Parameter Store

/dev/ami-id       = ami-123  
/staging/ami-id   = ami-123  
/prod/ami-id      = ami-123

👉 Now Terraform doesn’t “discover” AMI  
👉 It **reads approved AMI**

---

## 🔹 Step 5: Terraform consumes it

data "aws_ssm_parameter" "ami" {  
  name = "/prod/ami-id"  
}  
  
resource "aws_instance" "app" {  
  ami = data.aws_ssm_parameter.ami.value  
}

👉 Infra is now:

- predictable
- reproducible

---

# 💥 4. What Goes Wrong Without This (Real Story)

If you use:

most_recent = true

### 🚨 Scenario:

- AWS releases new AMI overnight
- Your autoscaling launches new instances
- New AMI has:
    - changed package
    - broken dependency

👉 Result:

Half your servers behave differently

👉 This is called:  
**configuration drift at infrastructure level**

---

# 🧠 5. This is called “Golden AMI Strategy”

👉 Key ideas:

- Immutable infrastructure (no manual changes)
- Same image everywhere
- Controlled rollout

---

# 🔥 6. Advanced Upgrade Strategy (what top engineers do)

Instead of replacing everything:

## 🔹 Rolling Update

- Deploy new AMI to few instances
- Monitor
- Gradually replace all

---

## 🔹 Blue-Green Deployment

- Old infra = BLUE
- New AMI infra = GREEN

Switch traffic when ready

---

# 🧠 7. Where this fits in your DevOps journey

This directly connects to:

- Terraform ✅
- AWS SSM ✅
- EC2 lifecycle ✅
- Auto Scaling (next step) 🔜
- CI/CD pipelines 🔜

---

# 🎯 8. Interview Answer (use this)

If asked:

> “How do you manage AMIs in production?”

👉 You say:

We follow a golden AMI approach.  
  
We bake AMIs using Packer, test them in lower environments,  
then promote the same AMI across dev, staging, and production.  
  
We store approved AMI IDs in SSM Parameter Store and Terraform consumes them,  
ensuring consistency and controlled rollouts instead of using dynamic AMI lookups.

---

# 🔥 9. What I want you to realize

You’re no longer asking:

> “How do I get AMI?”

You’re now thinking:

👉 “How do I control change in distributed systems?”

That’s **SRE / Platform mindset**

---

# 🚀 Next step (important)

We can now connect this to your current infra:

👉 Add:

- Auto Scaling Group
- Launch Template using SSM AMI
- Rolling deployment

OR

👉 Simulate:

- “Bad AMI broke production — how do you rollback?”

---

Just tell me:

👉 **“connect this to my current setup”**  
or  
👉 **“simulate AMI failure scenario”**