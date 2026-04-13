🔍 Debug your setup like production (what can break)

Good — this is exactly how a **systems-minded DevOps engineer** should think.

Let’s treat your setup like **it just failed in production at 2 AM** and you’re on call.

---

# 🔥 0. The Situation

> ❌ “App cannot connect to MongoDB from Bastion”

Your job is NOT to guess.

Your job is to **trace the path layer by layer**.

---

# 🧭 1. Always Debug Like This (Golden Flow)

![https://jojozhuang.github.io/assets/images/cloud/4165/vpc-bastions-1.png](https://jojozhuang.github.io/assets/images/cloud/4165/vpc-bastions-1.png)

![https://miro.medium.com/v2/resize%3Afit%3A1400/1%2Ar563mL_PJHbMTczdlwf2rA.png](https://miro.medium.com/v2/resize%3Afit%3A1400/1%2Ar563mL_PJHbMTczdlwf2rA.png)

![https://www.redhat.com/rhdc/managed-files/sysadmin/2019-09/TCPIP_OSI_0.png](https://www.redhat.com/rhdc/managed-files/sysadmin/2019-09/TCPIP_OSI_0.png)

4

You debug in this order:

1. Process (is MongoDB running?)  
2. OS (is port listening?)  
3. Security Group  
4. Network (route tables)  
5. Subnet (NACL)  
6. DNS / config

👉 Never jump randomly.

---

# 🔍 2. Layer-by-Layer Failure Points

## ✅ Layer 1: MongoDB not running

On MongoDB instance:

ps -ef | grep mongod

or:

systemctl status mongod

### ❌ Failure:

- service not started
- crashed
- wrong config

---

## ✅ Layer 2: Port not listening

ss -lntp | grep 27017

### ❌ Failure:

- MongoDB bound to `127.0.0.1` instead of `0.0.0.0`

👉 This is VERY COMMON

Check config:

/etc/mongod.conf  
bindIp: 127.0.0.1  ❌  
bindIp: 0.0.0.0    ✅

---

## ✅ Layer 3: Security Group mistake (MOST COMMON)

Your rule should be:

MongoDB SG:  
  Inbound:  
    Port 27017  
    Source = Bastion SG ID

### ❌ Common mistakes:

- You allowed:
    
    27017 from 0.0.0.0/0 ❌ (insecure)
    
- Or:
    
    wrong SG ID ❌
    
- Or:
    
    attached wrong SG to instance ❌
    

👉 Debug like this:

aws ec2 describe-instances

Check:

- which SG is attached?
- is it the one you think?

---

## ✅ Layer 4: Route Table issues

Even if SG is correct, traffic still fails if routing is wrong.

### Check:

- Private subnet route table should have:

local → VPC CIDR ✅

👉 For **Bastion → MongoDB**, NAT is NOT needed.

### ❌ Common misunderstanding:

People think NAT is needed for internal communication.

👉 NO.

Same VPC = direct routing via `local`

---

## ✅ Layer 5: NACL (silent killer)

If NACL is too strict:

### ❌ You might block:

- inbound 27017
- ephemeral ports (1024–65535)

👉 Remember:

Security Group = stateful  
NACL = stateless

So NACL must allow:

Inbound:  
  27017  
  ephemeral ports  
  
Outbound:  
  ephemeral ports

---

## ✅ Layer 6: Bastion itself

From Bastion:

telnet <mongodb-private-ip> 27017

or:

nc -zv <ip> 27017

### ❌ If fails:

- problem is NETWORK / SG / Mongo

---

## ✅ Layer 7: DNS / wrong endpoint

### ❌ Classic issue:

You’re trying:

mongo localhost:27017 ❌

Instead of:

mongo <private-ip>:27017 ✅

---

# ⚠️ 3. Real Production Failure Scenarios

## 💥 Scenario 1: “Worked yesterday, broken today”

👉 Likely:

- SG changed
- instance replaced (new SG not attached)
- autoscaling recreated infra

---

## 💥 Scenario 2: “Connection timeout”

👉 Means:

- SG / NACL / routing issue

---

## 💥 Scenario 3: “Connection refused”

👉 Means:

- MongoDB not running OR not listening

---

## 💥 Scenario 4: “Works from inside, not from bastion”

👉 Means:

- SG reference issue

---

# 🧠 4. Your Debug Mindset (IMPORTANT)

When something fails, don’t panic.

Think like this:

Is packet leaving Bastion?  
→ Is it allowed by SG?  
→ Does it reach subnet?  
→ Is port open?  
→ Is process running?

👉 You are tracing **packet journey**

---

# 🔧 5. One Powerful Debug Trick (Use This Always)

On MongoDB instance:

sudo tcpdump -i any port 27017

Now try connecting from Bastion.

### Results:

- ❌ No packets → SG / network issue
- ✅ Packets seen but no response → Mongo issue

👉 This is **real SRE-level debugging**

---

# 🔥 6. Brutal Truth (for your growth)

Most people:

- memorize Terraform
- write configs
- don’t understand failures

You are now learning:

👉 **how systems fail**  
👉 **how to trace them**  
👉 **how to stay calm during outages**

---

# 🚀 Next Level (if you want)

I can simulate a **real outage scenario for you** like:

- “Mongo works but app fails intermittently”
- “Only one AZ failing”
- “NAT misconfigured causing partial outage”

You debug it step-by-step.

---

Just tell me:

👉 “give me outage simulation”

And we’ll train like real production engineers.