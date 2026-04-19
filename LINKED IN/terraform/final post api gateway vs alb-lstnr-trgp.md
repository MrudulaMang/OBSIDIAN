Stop defaulting to API Gateway.

You might be overengineering your ingress.

---

A pattern I keep seeing in Terraform reviews:

API Gateway… everywhere.

Even when it’s not needed.

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

Here’s the distinction that matters:

API Gateway = managed API layer  
ALB = traffic routing primitive

---

ALB (via AWS Load Balancer Controller):

• Native K8s integration (IngressClass)  
• Supports HTTP, WebSockets, gRPC (HTTP/2)  
• No extra deployment lifecycle  
• Minimal Terraform (~20–30 lines)

---

API Gateway (+ VPC Link):

• Requires NLB  
• Adds stage + deployment management  
• Introduces VPC Link complexity  
• 2–3x more Terraform  
• More operational surface area

---

Use API Gateway when you actually need:

• API keys  
• Rate limiting / throttling  
• Request/response transformation  
• External developer access

---

Otherwise?

You’re paying a complexity tax for features you’re not using.

---

The best engineers don’t use the most powerful tools.

They use the right-sized ones.

---

Before adding API Gateway, ask:

Do we need API-level capabilities…  
or just a way to route traffic?

---

Most of the time, the simpler option wins.

I default to ALB for Kubernetes ingress,

and reach for API Gateway when I need API-level concerns like auth, throttling, or lifecycle management.

---

Curious—what made you choose API Gateway (or avoid it)?  
👇