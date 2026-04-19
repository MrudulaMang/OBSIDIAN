## 🔹 Option 1: Sharp, Opinionated (High Engagement)

**Hook-first, slightly contrarian**

---

Stop defaulting to API Gateway.

You're adding complexity you haven’t earned yet.

---

I’ve reviewed dozens of AWS + Kubernetes Terraform codebases.

The most common mistake?

Using API Gateway where a simple ALB listener + target group would do the job—with:

• 1/4 the code  
• 1/2 the operational overhead  
• Far less cognitive load

---

Let’s be clear:

**API Gateway is a product.**  
It’s built for:

- Auth
- Rate limiting
- API keys
- Usage plans
- Request transformation
- Caching

If you need these → use it.

---

**ALB is infrastructure.**

It:

- Routes traffic
- Plays perfectly with AWS Load Balancer Controller
- Works cleanly with Kubernetes Ingress
- Supports WebSockets + gRPC
- Doesn’t introduce extra lifecycle complexity

---

Here’s the trap:

API Gateway _feels_ like the “serious” choice.

It’s not.

Serious engineers choose the **smallest abstraction that solves the problem**.

---

The real question is simple:

**Who is calling your service?**

• Internal service (VPC)? → ALB  
• Frontend in cluster? → ALB  
• External consumers needing auth + rate limiting? → API Gateway

---

Complexity is not a badge of honor.

It’s a liability.

Pick boring when boring works.

Your future self (and your on-call rotation) will thank you.

---

What are you running in prod right now?

ALB? API Gateway? Something else?

👇

---

## 🔹 Option 2: Story-Driven (More Relatable)

---

A pattern I keep seeing in Terraform code reviews:

API Gateway… everywhere.

Even when it’s not needed.

---

One team had:

• API Gateway  
• VPC Link  
• NLB  
• Stage deployments

…just to expose a Kubernetes service.

---

We replaced it with:

→ ALB listener  
→ Target group

That’s it.

---

Result?

• Less code  
• Fewer moving parts  
• Easier debugging  
• Faster deployments

---

Here’s the distinction most teams miss:

**API Gateway = feature-heavy product**  
**ALB = simple infrastructure primitive**

---

Use API Gateway when you actually need:

- API keys
- Rate limiting
- Request transformation
- External developer access

---

Otherwise?

You’re paying a complexity tax for features you’re not using.

---

Good engineering isn’t about choosing the most powerful tool.

It’s about choosing the **right-sized tool**.

---

Before adding API Gateway, ask:

“Do we need its features… or just a way to route traffic?”

---

Most of the time, the answer is simpler than you think.

---

Curious—what made you choose API Gateway (or avoid it)?

👇

---

## 🔹 Option 3: Technical + Authority (For Infra Audience)

---

If you're exposing Kubernetes services on AWS, read this before adding API Gateway.

---

After reviewing dozens of Terraform setups, one anti-pattern stands out:

**API Gateway used as default ingress.**

---

Compare the two approaches:

**ALB (via AWS Load Balancer Controller):**

- Native K8s integration (IngressClass)
- Supports HTTP, WebSockets, gRPC
- No extra deployment lifecycle
- Minimal Terraform (~20–30 lines)

---

**API Gateway (+ VPC Link):**

- Requires NLB
- Adds stage + deployment management
- Introduces VPC Link complexity
- ~2–3x more Terraform
- More failure points

---

API Gateway is powerful—but it’s not free (operationally).

---

Use it when you need:

✓ Auth & authorization layers  
✓ Rate limiting / quotas  
✓ API keys & monetization  
✓ Request/response transformation

---

Skip it when:

→ Traffic is internal  
→ Services live inside the same cluster/VPC  
→ You just need routing

---

Rule of thumb:

**ALB = default**  
**API Gateway = deliberate choice**

---

The best systems aren’t the most sophisticated.

They’re the ones with the least unnecessary complexity.