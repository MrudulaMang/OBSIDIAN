Secret rotation is the practice of periodically replacing credentials — passwords, API keys, tokens, certificates — with new ones, so that any single secret has a limited useful lifetime. If a credential leaks (committed to git, logged accidentally, exposed via a misconfigured IAM policy), rotation caps the blast radius: the leaked value stops working once it's rotated out, instead of being valid forever.

**Why it matters beyond "best practice":**

- Limits the exploitation window for leaked or stolen credentials
- Required for compliance frameworks (PCI-DSS, SOC2, ISO 27001 all mandate rotation intervals)
- Reduces insider-threat risk — an offboarded engineer's old key stops mattering
- Forces you to build credential-update automation, which also makes incident response faster (you can revoke/rotate on demand, not just on schedule)

The hard part of rotation isn't generating a new value — it's doing that _without breaking running services_. That's where most rotation designs live or die.

**The zero-downtime pattern**

Almost every mature secrets system (AWS Secrets Manager, HashiCorp Vault, etc.) solves this the same way: never overwrite a secret in place. Instead, stage a new version, verify it works, then atomically promote it. Old version stays around briefly as a rollback path.

![[{81CFD85D-C9B2-4C33-AFE3-A62D29CFED78}.png]]

This is exactly how AWS Secrets Manager's native rotation works under the hood — it invokes a Lambda with four steps in this order, and each version of the secret carries a staging label: `AWSCURRENT` (live), `AWSPENDING` (being staged), `AWSPREVIOUS` (the one just replaced, kept as a rollback). If `testSecret` fails, `AWSCURRENT` never moves, so your apps never see a broken credential.

**How to actually perform rotation, by secret type**

_Database credentials (RDS, Aurora, DocumentDB, Redshift)_  
Use Secrets Manager's built-in rotation — it ships pre-built Lambda templates for these engines. You just attach the rotation schedule:

bash

```bash
aws secretsmanager rotate-secret \
  --secret-id prod/rds/app-db \
  --rotation-lambda-arn arn:aws:lambda:ap-south-1:111122223333:function:SecretsManagerRDSRotation \
  --rotation-rules AutomaticallyAfterDays=30
```

Under the hood it actually creates a **second IAM/DB user** during rotation and alternates between two users — this is the "alternating users" rotation strategy, used specifically because some databases lock a session while a password change is in flight; alternating avoids any connection drop.

_IAM access keys (the one most people get wrong)_  
Never delete-then-create. Always run two keys in parallel:

bash

```bash
# 1. Create new key while old one is still active
aws iam create-access-key --user-name svc-deploy

# 2. Update the key everywhere it's consumed (CI secrets, app config, Vault, etc.)
# 3. Verify new key works in production for a full traffic cycle
# 4. Deactivate (not delete) the old key
aws iam update-access-key --access-key-id AKIA_OLD --status Inactive --user-name svc-deploy

# 5. After a safe soak period, delete it
aws iam delete-access-key --access-key-id AKIA_OLD --user-name svc-deploy
```

Honestly, for CI/CD specifically the better fix is to **eliminate long-lived IAM keys entirely** — use OIDC federation (GitHub Actions → IAM role via `sts:AssumeRoleWithWebIdentity`) so there's no static key to rotate in the first place. If you're still using PATs/static keys for GitHub Actions, that's the rotation-debt to pay down first.

_Kubernetes / EKS_  
Don't put long-lived secrets directly into K8s `Secret` objects by hand. Use the **External Secrets Operator (ESO)** to pull from AWS Secrets Manager/Vault and sync into a K8s Secret on an interval:

yaml

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: app-db-creds
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secretsmanager
    kind: ClusterSecretStore
  target:
    name: app-db-creds
  data:
    - secretKey: password
      remoteRef:
        key: prod/rds/app-db
```

The catch: updating the K8s Secret doesn't restart pods that already mounted it as an env var. Either mount it as a **volume** (kubelet auto-refreshes the file, app needs to re-read it) or use something like **Reloader** to trigger a rolling restart when the Secret's hash changes.

_HashiCorp Vault_  
Vault's preferred model sidesteps rotation entirely for things like DB creds — it issues **dynamic, short-TTL credentials per lease** instead of rotating one static password. For secrets that must stay static (API keys for a third-party SaaS), Vault still supports scheduled rotation via its KV engine + a rotation script/Lambda you trigger on a cron.

_Terraform_  
Two separate concerns here:

- Don't write secrets into `.tf` files or let them land in state in plaintext — pull them at apply-time via a `data` source (`aws_secretsmanager_secret_version`, Vault provider) rather than a `variable` with a default.
- For HCP Terraform workspace variables marked sensitive, rotating them is a manual "update variable" + re-apply, since Terraform itself has no rotation scheduler — that has to live in Secrets Manager/Vault, with Terraform just reading the current value.

**The generic playbook, regardless of system**

1. Generate the new secret value (don't reuse a recent one)
2. Store it as a new, _inactive/pending_ version — never overwrite the active one in place
3. Propagate it to every consumer (apps, CI, other services) without yet revoking the old value
4. Validate the new value actually works in production, not just in staging
5. Cut over: mark the new version active
6. Keep the old version valid for a short overlap window in case of rollback or stragglers
7. Revoke/delete the old version after the overlap window
8. Log/alert on rotation success and failure — a silently failed rotation is worse than no rotation, because everyone assumes it happened

**A few senior-interview-relevant gotchas worth knowing cold:**

- Rotation failing silently is the most common real-world incident — always alert on rotation Lambda errors, don't just "set and forget"
- TLS certificate rotation needs a _longer_ overlap window than passwords, because of caching/CDNs and clients that pin old certs
- For anything with active sessions (DB connections, long-lived gRPC streams), instant rotation can cause a thundering-herd reconnect — stagger it
- Rotating a secret that's baked into a container image (rather than injected at runtime) requires a rebuild+redeploy, which is a sign the secret shouldn't have been baked in to begin with

Want me to turn this into a structured PDF/notes doc for interview prep, similar to your earlier GitHub Actions and Terraform study sets?

-------------
What usually triggers a secret rotation - schedule, event, or manual?

1:25 PM

Recognized duplicate query and opted for concise restatement

Recognized duplicate query and opted for concise restatement

All three — which one applies depends on the kind of secret and what's driving the rotation:

**Scheduled** — a fixed interval (30/60/90 days) regardless of any event. This is the default for routine hygiene and what most compliance frameworks (PCI-DSS, SOC2) expect documented. It's what `rotate-secret --rotation-rules AutomaticallyAfterDays=30` or Vault's lease TTLs implement.

**Event-driven** — fired by something happening rather than a clock:

- Offboarding (rotate everything that person had access to)
- A secret leaking somewhere it shouldn't (committed to a repo, caught by secret-scanning, found in a log)
- Incident response or a pen-test finding
- A third-party vendor you integrate with gets breached
- Vault's dynamic-secret lease expiring — tied to that credential's own lifecycle, not a calendar

**Manual** — someone invokes rotation on demand: testing the pipeline before trusting it on a schedule, rotating ahead of a planned migration, or a one-off when something feels off but isn't confirmed.

	The key design point: the trigger varies, but the rotation mechanism itself (createSecret → setSecret → testSecret → finishSecret) should stay the same regardless of what kicked it off. Manual and event-driven rotation should just be calling the same automated pipeline on demand, not a separate hand-rolled process — otherwise your emergency-rotation path is untested exactly when you need it most.XX
