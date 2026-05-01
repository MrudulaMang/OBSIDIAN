Using an **Application Load Balancer (ALB)**—like the one provided by Amazon Web Services—isn’t just about “distributing traffic.” It’s about **smart traffic routing at the application layer (Layer 7)**.

Let’s break down why it matters.

---

# 🔹 What is ALB (in simple terms)

![https://images.openai.com/static-rsc-4/aQVK-IR2Icszcbk9D1nchxsDSrZ5-9JdbCZAQBMzqqgPNZfrihHSmBtnjxg9SpGGdP03nMVLy0AzWiz8bPD6RFjPbmpcnxmuBX59BWxuFXXaut3OETzHElImrIFZFTA43d4oWkKqRaD9Onrcy3YIprSbVIHJha8tzUzo3aUs30T3Xt9NSxxjbcPL4yFMCYBI?purpose=fullsize](https://images.openai.com/static-rsc-4/D4lc1upFeOzXuUudDoFlcdQxndI_8nVbUvCJmJHU_7xKtFhYm4vx3qiw0TF9v3moIBlEpYCh3c92BAI5mWpQHJ-_CXDWTxvMpWBVzhD1wQtKXgjwSPPcoTa6pqu_iTsyUkgoUuCYqIf0QD-ppYjHQ-yfzGMeWdTGFdCyy3jAZIQ?purpose=inline)

![https://images.openai.com/static-rsc-4/2fhArF_eL1SoPdpcMjYbqNRBQzwltnNLMz7KSBff9e5Mh6Nl6xScmUDx_m9cy957CzWT6-_ho_hBjGMDftZ_4MjnO_TEOtF7Gj_lTYn9Ai24qSe0Yx7MlzXFR8gzgDS_BCyJbNPZ6OutUVQv40dJlyWUggjk3rTwWe0GacM99AyhGm0UO2cjE1D82HLgj46y?purpose=fullsize](https://images.openai.com/static-rsc-4/qoOkSDpFu2qkTOcJ8I0RDmOPBqEj_p1bpY_IU4CYcLYseN-QimobMgvmnoOdfFfgSmOyGfVLjOFwsZ8f6BH7sQH5H4cJJh9VbDMM2T0WyAfsvW-s658BWWSI2LEalMCL1li07dFCrw_TggP8T5-6UJodv7xMagIMUJb4xrRUKGI?purpose=inline)

![https://images.openai.com/static-rsc-4/CJ_QEDakqjkzMyVNVbBV8gIyUrrSnFJmRZ7zPPTAnSopvZgsjbZHiymD3NJAaNt4re8Ciq-lc7W1zwKyAtkA7OgDmTpzxhnI1LHqZwNbAxVlZbusHDM5Irwy488iQsJQcsArJwVJH1aNajA-NXBPm93LHtsHgKS_oQr02vPtYSW6HaUjAUZ4c8BDNFvrd4Yw?purpose=fullsize](https://images.openai.com/static-rsc-4/NfD_0_Ci_2LBg_clCGgJ89N7MddivaviHpd6qat8sSClsFeBNc0i6gLp3z8YQ6QR9dn7TBhao-9G1PlJEx6geHLC599vW18N8QrlJiGt_MsbrVNQvYAMvBTd-EFyLVRTZNs2iqdXSw5MM1V4NUEGTmtSR2EvMMuVjJfqGqT7WJw?purpose=inline)

5

ALB operates at **Layer 7 (HTTP/HTTPS)**, meaning it understands:

- URLs
- Paths
- Headers
- Hostnames

👉 Unlike Network Load Balancer (L4), which just forwards packets.

---

# 🔥 Key Benefits of ALB

## 1. 🎯 Smart Routing (Path & Host-based)

ALB can route traffic based on:

- `/api` → backend service
- `/images` → another service
- `app1.example.com` → service A
- `app2.example.com` → service B

👉 This is HUGE for microservices.

---

## 2. 🌐 Single Entry Point for Multiple Services

Instead of:

- multiple load balancers
- multiple public endpoints

You can use **one ALB** to route to many services.

👉 Cleaner architecture + cost optimization

---

## 3. 🔒 SSL Termination

ALB can handle HTTPS:

- Terminates SSL at the load balancer
- Backend services can run HTTP

👉 Benefits:

- Offloads CPU work from your apps
- Centralized certificate management

---

## 4. ⚖️ Advanced Load Balancing

- Round robin
- Least outstanding requests

👉 More intelligent than simple TCP balancing

---

## 5. 🔁 Health Checks & Auto Recovery

ALB continuously checks:

- Is your app responding?
- If not → stops sending traffic

👉 Keeps your system stable automatically

---

## 6. 🔗 Deep Integration with Kubernetes

In Kubernetes:

- ALB works via **AWS Load Balancer Controller**
- Reads **Ingress resources**
- Automatically creates ALB + routing rules

👉 This is why you saw ALB in your EKS setup

---

## 7. 🧠 Supports Modern Architectures

- Microservices
- Containers
- Serverless (Lambda targets)

👉 Not just for EC2 anymore

---

## 8. 📊 Observability & Debugging

- Access logs
- Metrics in CloudWatch
- Request tracing

👉 Helps in production debugging (this aligns with your interest)

---

# ⚠️ When ALB is NOT the right choice

ALB is great, but not always.

Use something else if:

- You need **ultra-low latency TCP/UDP** → use NLB
- You don’t care about HTTP logic → ALB is overkill

---

# 💥 Real-world example (important for interviews)

Without ALB:

- `/api` → separate service endpoint
- `/web` → separate endpoint

With ALB:

- One domain:
    - `/api` → backend
    - `/web` → frontend

👉 Cleaner, scalable, production-ready design

---

# 🧠 Think like a systems engineer

ALB is not just “load balancing.”

It’s:

> **Traffic control + routing brain at the edge of your system**

---

# 🔚 One-line takeaway

👉 Use ALB when you need **intelligent HTTP routing, central entry point, and microservices-friendly architecture**

---

If you want next:  
I can connect this directly to your earlier confusion:  
👉 “Why Kubernetes created NLB instead of ALB”  
👉 And how **Ingress → ALB → Service → Pods** flow actually works internally

That will solidify your EKS understanding at interview level.