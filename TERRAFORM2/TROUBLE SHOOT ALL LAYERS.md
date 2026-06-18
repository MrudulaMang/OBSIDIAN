Yes! Terraform has its own "layers" to debug — not network layers, but **execution layers** where things break.

|Layer|What it tests|Command|
|---|---|---|
|**L1 — Syntax**|HCL valid?|`terraform validate`|
|**L2 — Format**|Code formatted correctly?|`terraform fmt -check`|
|**L3 — State**|What does Terraform think exists?|`terraform show`|
|**L4 — Drift**|Real infra vs state diff?|`terraform plan`|
|**L5 — Provider Auth**|Can Terraform reach the cloud?|`terraform providers` + check env vars|
|**L6 — Dependencies**|Resource order correct?|`terraform graph|
|**L7 — Remote State**|Backend reachable & locked?|`terraform state list`|
|**L8 — Variable Resolution**|Right values being used?|`terraform console` → type var name|
|**L9 — Apply Errors**|What failed during apply?|`TF_LOG=DEBUG terraform apply`|
|**L10 — Targeted Debug**|Isolate one resource|`terraform plan -target=<resource>`|

**Debugging order:**

```
1. validate + fmt      → catch syntax/formatting early
2. terraform plan      → see what will change before touching infra
3. state list/show     → is state out of sync?
4. terraform console   → inspect variables & expressions interactively
5. TF_LOG=DEBUG        → full verbose output when all else fails
```

**Power commands:**

bash

```bash
# Check a specific expression interactively
terraform console
> var.region
> local.tags

# Unlock stuck state
terraform force-unlock <lock-id>

# Remove a broken resource from state without destroying it
terraform state rm <resource>
```

**Key thing Terraform-specific:** most issues are either **state drift**, **provider auth**, or **variable not resolving as expected** — the console command is underused for that.

Want this as a LinkedIn post too, or combine all three (Docker + K8s + Terraform) into one mega cheatsheet post?