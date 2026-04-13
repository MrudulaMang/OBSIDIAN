Terraform datasources
# Terraform · LinkedIn Posts · Weekly Schedule

WEEK 1remote_state vs data sources

Terraform remote_state vs data sources — I see these confused constantly. They're not the same thing. Here's when to use which 👇 ─────────────────────────📦 TERRAFORM_REMOTE_STATE→ Reads outputs from another Terraform state file directly→ Creates tight coupling between your stacks→ Team B's infra breaks if Team A renames an output→ Best when YOU own both sides of the dependency ─────────────────────────🔍 DATA SOURCES→ Fetch existing infra by querying the cloud provider's API→ Loosely coupled — no state dependency at all→ Works across teams, accounts, even cloud providers→ Best when you DON'T own what you're referencing ───────────────────────── Rule of thumb I follow in production: If the networking team owns the VPC → data source. If my own module created it last step → remote_state. Loose coupling scales. Tight coupling creates 2am incidents. The moment your platform grows beyond one team, data sources become the saner default. What's your team's convention here? Curious how others draw the line 👇 #Terraform #DevOps #PlatformEngineering #InfrastructureAsCode #CloudEngineering

COPY POST

WEEK 2terraform_data

Terraform 1.4 quietly shipped one of the most useful resources nobody talks about — terraform_data. No cloud provider. No API call. Just pure Terraform logic. ─────────────────────────⚙️ WHAT IS terraform_data? It's a provider-agnostic resource that lives entirely in your state. Think of it as a container for computed values or a trigger mechanism — without spinning up any real infrastructure. ─────────────────────────🚀 3 WAYS I USE IT IN PRODUCTION✅ Trigger replacements — use replace_triggered_by when a non-resource value changes (config hash, rendered template, etc.)✅ Store computed values in state — persist locals you want tracked across plan/apply cycles✅ Clean module boundaries — pass structured data between modules without forcing fake resources ───────────────────────── Before terraform_data, people used null_resource for this. null_resource still works but it requires the null provider and carries baggage. terraform_data is built-in, cleaner, and purpose-built for exactly this pattern. If you're still reaching for null_resource in 2024 — worth revisiting. Have you migrated to terraform_data yet? Or still on null_resource? Drop your take 👇 #Terraform #DevOps #PlatformEngineering #IaC #CloudInfrastructure

COPY POST

WEEK 3remote_exec vs user_data

remote-exec vs user_data — picking the wrong one has caused more broken prod VMs than I'd like to admit. They both run scripts on instances. They are NOT interchangeable. ─────────────────────────📡 REMOTE-EXEC (provisioner)→ Runs AFTER the resource is created, over SSH/WinRM→ Terraform waits for it — blocks your apply→ Failure = resource marked tainted→ Requires network access from wherever Terraform runs→ Stateful: you control exactly when it fires ─────────────────────────☁️ USER_DATA→ Runs on first boot via cloud-init — Terraform doesn't wait→ No SSH needed, works in private subnets→ Failures are silent unless you ship logs somewhere→ Immutable pattern — change it → replace the instance ───────────────────────── In production, user_data wins almost every time. Why? remote-exec requires Terraform to reach your instance — which means open ports, bastion hosts, or VPN access during every apply. That's friction you don't want in a CI/CD pipeline. user_data + a proper cloud-init setup is more reliable, more secure, and scales to auto-scaling groups out of the box. Save remote-exec for local dev or very specific bootstrapping edge cases. Which are you running in prod? And have you been burned by remote-exec in a pipeline before? 😅 Tell me below 👇 #Terraform #DevOps #PlatformEngineering #InfrastructureAsCode #CloudEngineering

COPY POST

A single Terraform apply.

And suddenly, production VMs stopped behaving as expected.

Not bad code.  
Not traffic.

Just this:  
**remote_exec vs user_data**

They both “run scripts”…  
But treating them the same is where things go wrong.

---

### 🔧 remote_exec

Runs _after_ provisioning

**Feels powerful because:**  
- You see everything in real-time  
- Easy to debug (SSH)  
- Can use Terraform outputs

**But in reality:**  
- Needs SSH/WinRM (pipeline nightmare)  
- Breaks idempotency (reruns = surprises)  
- Slows down `terraform apply`  
- Couples infra with runtime behavior

👉 Works… until scale exposes the cracks.

---

### ☁️ user_data

Runs _at first boot_ (cloud-init)

**Why teams prefer it:**  
✔ No SSH (works in private subnets)  
✔ Auto Scaling friendly  
✔ Fast Terraform apply  
✔ Native to instance lifecycle

**But don’t ignore this:**  
✖ Logs buried in `/var/log/cloud-init`  
✖ Runs only once  
✖ Debugging = pain  
✖ Failures are silent unless monitored

👉 Safer than remote_exec… but still runtime config.

---

### 🧠 The shift most teams miss

🏗️ Immutable infra / ASG → **user_data**  
🔬 Debugging / quick fixes → **remote_exec**  
🚀 Production scale → **Avoid runtime config**

→ Use **Packer + Golden AMI**

Because the real win is this:

**Instance boots → already ready → no scripts → no surprises**

---

### ⚠️ Hard question

Are you using remote_exec because it’s the _right design_…  
or because it’s the _fastest way to make it work today?_

---

The best provisioning?

**The one that happens before Terraform even runs.** 🏆

---

Have you ever had a Terraform apply hang because of remote_exec? 😅

#Terraform #DevOps #PlatformEngineering #CloudEngineering #SRE