“simulate terraform incident”

Good. This is where things get real.

We’re not doing a toy example.  
We’re simulating a **production-grade Terraform incident** — the kind that wakes people up at 2 AM.

---

# 💣 INCIDENT: “Terraform is about to destroy production DB”

## 🧨 Setup (very realistic scenario)

You have:

- RDS database running in production
- Managed via Terraform
- Everything stable for months

Now someone makes a “small change”:

# BEFORE  
resource "aws_db_instance" "prod" {  
  identifier = "prod-db"  
  instance_class = "db.t3.medium"  
  publicly_accessible = false  
}  
  
# AFTER (seems harmless)  
resource "aws_db_instance" "prod" {  
  identifier = "prod-db"  
  instance_class = "db.t3.large"   # scaling up  
  publicly_accessible = true       # added for testing 😬  
}

---

## ⚠️ You run:

terraform plan

And you see:

-/+ resource "aws_db_instance" "prod" {  
      ~ instance_class = "db.t3.medium" -> "db.t3.large"  
      ~ publicly_accessible = false -> true  
  
    # forces replacement  
}

---

## 🧠 What just happened?

Terraform is telling you:

> “I cannot modify this in-place.  
> I will DESTROY the DB and CREATE a new one.”

---

## 💥 Production impact (if you blindly apply)

- DB deleted ❌
- New empty DB created ❌
- Data gone ❌
- Application down ❌

👉 This is a **real-world outage pattern**

---

# 🔍 Root Cause Analysis (SRE thinking)

### Why did Terraform decide to recreate?

Because:

- Some attributes are **immutable**
- Cloud provider APIs don’t support in-place change
- Terraform follows provider limitations

---

### Hidden problem:

> Terraform doesn’t understand _business criticality_  
> It only understands _desired state_

---

# 🚨 Detection Signals (what a senior notices)

Before applying, a senior ALWAYS scans for:

### 🔴 Red flags in plan:

- `-/+` → destroy + create
- `forces replacement`
- critical resources (DB, LB, VPC)

---

### 🔴 Questions they ask:

- Why replacement?
- Is this safe?
- What is the blast radius?
- Is data preserved?

---

# 🛑 What you SHOULD do (correct handling)

### Option 1: Stop immediately

> Never apply blindly

---

### Option 2: Check documentation

Some changes require:

- snapshot
- migration
- manual intervention

---

### Option 3: Use lifecycle protection

lifecycle {  
  prevent_destroy = true  
}

👉 This would have blocked the disaster

---

### Option 4: Separate risky changes

Don’t bundle:

- scaling
- networking
- exposure changes

---

### Option 5: Take snapshot FIRST

aws rds create-db-snapshot ...

---

# 🧠 Senior Insight (THIS is the real lesson)

> Terraform failures are not syntax errors  
> They are **correct actions applied at the wrong time**

---

# 💬 How you explain this in an interview

👉 Strong answer:

> “I always review Terraform plans for destructive changes.  
> I’ve seen cases where minor config updates forced resource replacement, especially with stateful systems like databases.  
> I treat `forces replacement` as a high-risk signal and validate impact before applying.”

---

# 🔥 This is a killer LinkedIn post too

> “A single Terraform plan line can wipe your production database.”

---

# 🚀 Want to go EVEN deeper?

We can simulate next-level incidents:

1. **State drift causing unexpected deletion**
2. **Two engineers running apply → state corruption**
3. **Remote state lock stuck → pipeline blocked**
4. **Partial apply → broken infrastructure**

---

Just tell me:  
👉 “next incident”

And I’ll level you up further into **real SRE territory**.