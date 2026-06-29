# GitHub Actions — Senior DevOps Interview Notes

This is your master reference. Every topic follows the same pattern so you can talk for 2-3 minutes without rambling:

**Problem → How GitHub Actions solves it → Real example → Benefit → Tradeoff → Troubleshooting**

Technical terms are kept exactly as they are (so you recognize them in an interview), but every explanation around them is written in plain language.

---

## PART 1 — CORE CONCEPTS (from your notes, rewritten simply)

### 1. Workflow Architecture

**Simple idea:** GitHub Actions has 4 layers, like a company org chart.

```
Workflow (the whole project)
   └── Job (a department, e.g. "Build", "Test")
         └── Step (a task inside that department)
               └── Action (a ready-made tool used inside a step)
```

- **Workflow**: A YAML file inside `.github/workflows/`. It's triggered by an event (push, PR, schedule, manual click).
- **Job**: A group of steps. Jobs run in **parallel by default**. If Job B needs Job A to finish first, you write `needs: build`.
- **Step**: One single task — e.g. `run: npm install`.
- **Action**: A reusable, packaged piece of code someone already wrote (e.g. `actions/checkout@v4`) that you plug into a step instead of writing the logic yourself.

**Interview one-liner:** _"A Step is the unit of execution. An Action is the reusable component a step can call."_

**Senior answer:** In our Roboshop project, the workflow had separate jobs for checkout, SonarQube scan, Docker build, ECR push, and EKS deploy. Splitting into jobs made failures easy to isolate — if the Docker build job failed, I knew immediately it wasn't a test or scan issue.

---

### 2. Event Triggers

These decide **when** a workflow runs.

|Trigger|When it fires|Why you'd use it|
|---|---|---|
|`push`|Code pushed to a branch|Run CI on every change|
|`pull_request`|PR opened/updated|Catch bugs **before** merge, not after|
|`workflow_dispatch`|Manually clicked in GitHub UI|Run deployments on demand|
|`schedule` (cron)|Runs on a timer|Nightly builds, cleanup jobs, scheduled scans|
|`workflow_call`|Called by another workflow|Building reusable workflows (see below)|

**Senior answer for "why pull_request?":** Running checks on `push` alone means a bug already entered the main branch before you find out. Running on `pull_request` catches the issue at review time, so the main branch stays deployable at all times.

---

### 3. Matrix Strategy

**Problem:** You need to test the same code against multiple versions (Node 18, Node 20) or multiple operating systems, without copy-pasting the same job five times.

**Solution:**

yaml

```yaml
strategy:
  matrix:
    node-version: [18, 20]
```

GitHub automatically creates one job per combination and runs them **in parallel**.

**Senior answer:** Matrix builds give you wide test coverage without duplicating workflow code. If we support Node 18 and 20, or need to test on both Ubuntu and Windows, matrix strategy generates all combinations automatically and reports failures per combination — so I instantly know "it breaks only on Node 18 + Windows" instead of guessing.

---

### 4. Reusable Workflows

**Problem:** 100 repositories all need the exact same CI/CD steps. If each repo maintains its own copy, fixing a bug means updating 100 files.

**Solution:** One central workflow file is written once with `on: workflow_call`. Every other repo "calls" it:

yaml

```yaml
uses: org/repo/.github/workflows/build.yml@main
```

**Senior answer:** This is a governance and maintenance play. Instead of 100 different Docker build pipelines, we maintain **one** reusable workflow. When a security fix is needed, we update it in a single place and every consuming repository inherits the fix automatically the next run. This is exactly how you'd answer the "security fix across hundreds of repos" scenario question (see Part 3).

---

### 5. Composite Actions

**Problem:** You keep repeating the same _sequence of steps_ (checkout → install deps → run tests) across many workflows.

**Solution:** Package those steps into one reusable unit:

yaml

```yaml
runs:
  using: composite
```

**Key distinction (asked very often):**

||Reusable Workflow|Composite Action|
|---|---|---|
|Contains|Multiple **jobs**|Multiple **steps**|
|Scope|Entire pipeline/process|A small repeatable task|

**One-liner:** _"Composite Actions reuse steps. Reusable Workflows reuse jobs and pipelines."_

---

### 6. Self-Hosted Runners

**Problem:** GitHub-hosted runners are temporary VMs GitHub spins up and destroys for you — great for general use, but they **cannot reach your private network** (private EKS clusters, internal APIs, on-prem databases).

**Solution:** You run the GitHub Actions "runner" agent on your own machine — EC2, VM, Kubernetes pod, or bare metal — inside your VPC.

**Benefits:**

- Access to private/internal resources
- Pre-installed tools (Terraform, kubectl, Docker, AWS CLI) → faster builds
- Cost control at scale (vs. paying per-minute for GitHub-hosted)

**Tradeoff (always mention this — it shows seniority):** You now own patching, scaling, monitoring, and security of that machine. GitHub-hosted runners are destroyed after every job; self-hosted runners are **not** — so leftover files, cached credentials, or malware can persist between jobs unless you design for it.

**Labels** decide which runner picks up a job:

yaml

```yaml
runs-on: [self-hosted, dev]
```

**Troubleshooting "runner offline":**

1. `sudo systemctl status actions.runner.*` — is the service even running?
2. Network connectivity to GitHub
3. Registration token expiry
4. Firewall rules blocking outbound HTTPS

---

### 7. Secrets Management

**Rule:** Never hardcode credentials. Use GitHub Secrets:

yaml

```yaml
env:
  PASSWORD: ${{ secrets.DB_PASSWORD }}
```

**Levels:** Repository Secrets → Environment Secrets → Organization Secrets (broadest to narrowest scope, depending on need).

**Senior nuance:** In mature setups, GitHub Secrets hold only what's needed to _bootstrap_ — the real secrets (DB passwords, API keys) live in AWS Secrets Manager, Parameter Store, or Vault, fetched at runtime. This gives centralized rotation, auditing, and access control that GitHub Secrets alone don't provide.

**Security fact interviewers love testing:** A workflow triggered from a **forked** pull request does **not** get access to repository secrets. This stops an attacker from forking your repo, editing the workflow, and trying to exfiltrate secrets via a fake PR.

**GitHub also auto-masks secret values in logs** — but masking isn't bulletproof (see incident-response scenario in Part 3).

---

### 8. OIDC Authentication with AWS (a senior favorite — expect deep follow-ups)

**Problem with the old way:** Store `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` as GitHub Secrets. These are **long-lived** — if leaked, they work until someone manually revokes them. Rotation is a constant operational burden.

**OIDC way:**

```
GitHub Workflow runs
   ↓ requests a signed OIDC token
GitHub (acts as Identity Provider)
   ↓ sends token to AWS
AWS IAM checks the trust policy
   ↓ if it matches, issues short-lived credentials
AWS STS Temporary Credentials
   ↓
Workflow uses them to access AWS, then they expire
```

No AWS keys are ever stored in GitHub. Credentials are generated fresh per run and expire automatically.

**Senior-level answer (memorize the shape, not the words):**

> "Traditionally we stored static AWS keys as secrets — long-lived, needs rotation, risky if leaked. With OIDC, GitHub becomes a trusted identity provider. At runtime it requests a signed token, AWS validates that token against a configured IAM trust relationship, and issues temporary STS credentials scoped to a specific role. This removes static credentials entirely and follows the principle of least privilege, since each workflow can be scoped to exactly the permissions it needs."

**Tradeoff to mention:** Initial setup is more complex — you must configure the IAM OIDC identity provider and trust policy correctly (`sub` claim matching repo/branch), or you risk being either too restrictive (pipeline breaks) or too permissive (any repo can assume the role).

---

### 9. Cache Optimization

**Problem:** Every workflow run re-downloads npm/Maven/Gradle/pip dependencies from scratch — wasting 5-15 minutes per run.

**Solution:**

yaml

```yaml
uses: actions/cache@v4
```

Caches dependency folders using a **cache key** (usually a hash of the lockfile, e.g. `package-lock.json`). If the lockfile hasn't changed, the cache is reused.

**Senior answer:** Caching is purely a _speed_ optimization, not a correctness mechanism. I look first at dependency caching since it's the highest ROI for least effort, then at parallelizing independent jobs (lint, unit test, security scan can all run side-by-side), then at Docker layer ordering — frequently-changing files (like source code) should be copied **last** in the Dockerfile so earlier layers (OS packages, dependencies) stay cached.

**Troubleshooting "cache not working":**

- Cache key doesn't match (lockfile hash changed, or key was built wrong)
- Wrong cache path specified
- Cache expired (GitHub evicts caches not used in 7 days, or hits the 10GB repo limit)

---

### 10. Artifacts

**Problem:** Each job runs in an isolated environment. Files created in one job (a `.zip`, a test report) disappear once that job ends — they aren't automatically visible to the next job.

**Solution:**

yaml

```yaml
uses: actions/upload-artifact@v4   # save it
uses: actions/download-artifact@v4 # retrieve it in another job
```

**Cache vs Artifact — the question they will absolutely ask:**

||Cache|Artifact|
|---|---|---|
|Purpose|Speed (reuse dependencies)|Preserve outputs (deliverables)|
|Lifespan|Persists across many runs|Tied to a specific run (downloadable after)|
|Example|`node_modules`, `.m2` repo|`build.jar`, test reports, coverage reports|

**Senior answer:** "If my goal is reducing execution time, I use cache. If my goal is preserving or sharing generated files — between jobs, or for later audit/debugging — I use artifacts." Artifacts also give **traceability**: you can prove exactly which binary was built, tested, and later deployed.

---

### 11. Environment Approvals

**Problem:** Production deployments are the highest-risk action in your pipeline. You don't want a single push to auto-deploy to customers.

**Solution:** GitHub Environments (configured under **Settings → Environments**) let you attach:

- Required reviewers (manual approval gate)
- Wait timers
- Branch restrictions (only `main` can deploy to prod)

**Typical flow:**

```
Dev   → auto-deploy
QA    → auto-deploy
Prod  → requires manual approval from a named reviewer
```

**Senior answer:** This creates a human governance checkpoint before high-risk changes reach customers, and — important for regulated industries — it produces an **auditable record** of who approved what deployment and when, which compliance teams need.

---

### 12. Concurrency Control

**Problem:** Multiple developers push within minutes of each other → multiple deployment workflows could try to deploy to production **at the same time**, causing race conditions or a rollback fighting a fresh deploy.

**Solution:**

yaml

```yaml
concurrency:
  group: production
  cancel-in-progress: true
```

This groups workflows by name so only **one** runs against that group at a time. `cancel-in-progress: true` means a newer push cancels the older, still-running deployment.

**Senior answer:** "If five commits land on main within ten minutes, I don't want five sequential production deployments — I want only the latest code to actually reach production. Concurrency groups guarantee that, and combined with environment approvals, give predictable, conflict-free releases."

---

### 13. Commit Status Updates & Branch Protection

GitHub automatically posts ✅/❌ status checks back onto a PR based on workflow results. **Branch protection rules** can then say "this PR cannot be merged until the CI check passes" — turning your pipeline into an enforced gate, not just an informational signal.

**Senior nuance:** Branch protection should also require **up-to-date branches before merge** and, ideally, signed commits / required reviews — otherwise someone can merge a PR whose CI passed against stale code that no longer reflects main.

---

### 14. Roboshop CI/CD Story (your real-world example to narrate)

```
Developer pushes code
   ↓
GitHub Action triggered
   ↓
Checkout code
   ↓
Run unit tests
   ↓
SonarQube scan (code quality/security)
   ↓
Build Docker image
   ↓
Push image to ECR
   ↓
Update Kubernetes manifest (new image tag)
   ↓
Deploy to EKS
   ↓
Verify deployment (health checks)
```

Use this as your "tell me about a pipeline you've built" answer — narrate it stage by stage and mention **why** each stage exists (e.g. SonarQube exists to catch quality/security issues _before_ a bad image gets built and shipped).

---

### 15. Troubleshooting Quick-Reference

|Symptom|Check|
|---|---|
|Workflow stuck "Pending"|Runner available? Labels match? GitHub outage?|
|Runner offline|`systemctl status runner`, network, firewall, token expiry|
|"Secret not found"|Correct scope (repo/environment/org)? Permissions granted to that environment?|
|Artifact missing|Did `upload-artifact` step actually run and succeed?|
|Deployment failed|`kubectl get pods`, `kubectl describe pod`, `kubectl logs`|
|Pipeline suddenly slow|Cache hit/miss, parallelization, unnecessary scans, large Docker builds|

---

## PART 2 — TOPICS MISSING FROM YOUR ORIGINAL NOTES (senior interviews ask these often)

These are gaps I noticed. At senior level, interviewers specifically probe **security**, **permissions**, and **platform design** — areas your original notes touched lightly. Add these to your prep.

### 16. GITHUB_TOKEN Permissions (Least Privilege)

**What it is:** Every workflow run automatically gets a temporary token called `GITHUB_TOKEN`, scoped to that repository. By default it can have broad permissions (read/write to contents, issues, PRs).

**Why it matters for seniors:** A workflow that doesn't need to write anything should not be given write access. If a malicious dependency or compromised action runs inside your workflow, an overly-permissive `GITHUB_TOKEN` is a bigger blast radius.

**Best practice:**

yaml

```yaml
permissions:
  contents: read
  pull-requests: write   # only if you actually need to comment on PRs
```

Set `permissions: {}` at the top of the workflow and grant only what each job needs — this is least privilege applied to CI/CD, not just IAM.

**Senior answer:** "I treat `GITHUB_TOKEN` the same way I treat an IAM role — least privilege by default. I set workflow-level permissions to read-only and elevate only the specific job that needs write access, like a release job that tags a new version."

---

### 17. Workflow Security Risks (Supply Chain & Script Injection)

This is a _big_ senior-level topic your notes didn't cover at all.

**a) Pinning third-party actions:** `uses: some-org/some-action@v1` — a tag like `v1` can be **moved** by the action's maintainer (or an attacker who compromises their account) to point at malicious code, and your workflow would silently pull it in. Senior practice: pin to a **commit SHA**, not a tag:

yaml

```yaml
uses: some-org/some-action@a1b2c3d4...   # exact commit, immutable
```

**b) `pull_request_target` risk:** This trigger runs with access to secrets even on a forked PR (unlike plain `pull_request`). If you check out and run the fork's untrusted code while having that access, an attacker can steal secrets. Senior practice: never run untrusted code directly inside a `pull_request_target` workflow without explicit, careful isolation.

**c) Script injection via untrusted input:** Using `${{ github.event.issue.title }}` directly inside a `run:` shell command lets an attacker put `; rm -rf /` (or similar) into a PR/issue title, and it executes literally in your shell. Fix: pass untrusted values through an `env:` variable instead of inlining them directly into the script.

**Senior answer:** "CI/CD pipelines are part of the attack surface, not just a build tool. I pin third-party actions to commit SHAs, avoid running untrusted code in privileged trigger contexts like `pull_request_target`, and never interpolate user-controlled strings directly into shell commands — I pass them through environment variables instead."

---

### 18. Path Filters & Monorepo Optimization

**Problem:** In a monorepo with 10 microservices, you don't want a change to `service-a` triggering a build of `service-b` through `service-j`.

**Solution:**

yaml

```yaml
on:
  push:
    paths:
      - 'services/service-a/**'
```

`paths` / `paths-ignore` scope a workflow to only run when relevant files change.

**Senior answer:** This is a major cost and speed lever in monorepos — without path filtering, every commit triggers every pipeline, wasting runner minutes and slowing feedback for unrelated teams.

---

### 19. Job Outputs & Passing Data Between Jobs

**Problem:** Job B sometimes needs a value computed in Job A (e.g. a generated image tag).

**Solution:**

yaml

```yaml
jobs:
  build:
    outputs:
      tag: ${{ steps.set-tag.outputs.tag }}
  deploy:
    needs: build
    steps:
      - run: echo ${{ needs.build.outputs.tag }}
```

**Senior answer:** "I avoid hardcoding values across jobs — I compute things like an image tag once and pass it through job outputs, so build and deploy always stay in sync even if the tagging logic changes."

---

### 20. Conditional Execution

yaml

```yaml
if: github.ref == 'refs/heads/main' && success()
```

Lets you skip steps/jobs based on branch, event type, previous step result, or actor.

**Senior example:** "I run deployment steps only `if: github.ref == 'refs/heads/main'`, so feature branches never accidentally trigger a production deploy even if someone copies the workflow file."

---

### 21. Timeouts & Cancellation

yaml

```yaml
timeout-minutes: 15
```

Without this, a hung step (e.g. waiting on a stuck network call) can block a runner indefinitely, wasting runner minutes/cost and delaying the queue for everyone else.

**Senior answer:** "I set `timeout-minutes` on every job, especially ones with network calls — a hung integration test shouldn't hold a runner hostage for hours."

---

### 22. Action Versioning Best Practices

Already touched in #17, but worth its own talking point:

- `@v4` (floating major tag) → convenient, but maintainer can change what it points to
- `@<commit-sha>` → immutable, most secure, but you must manually bump it for updates
- Senior middle ground: use Dependabot to auto-PR action version bumps, while still pinning to SHA for security-sensitive workflows.

---

### 23. Self-Hosted Runner Autoscaling

**Problem:** Static self-hosted runners sit idle most of the time, wasting cost, or get overwhelmed during traffic spikes.

**Solution:** Use the **Actions Runner Controller (ARC)** on Kubernetes, or an AWS Auto Scaling Group, to spin runners up on demand and tear them down after the job — combining self-hosted flexibility with GitHub-hosted-style elasticity.

**Senior answer:** "Static self-hosted runners don't scale well with bursty CI traffic. I'd run ephemeral, autoscaled runners via ARC on EKS — each runner pod handles exactly one job then gets destroyed, which also solves the 'leftover state between jobs' security concern static self-hosted runners have."

---

### 24. Deployment Strategies (Blue-Green / Canary / Rolling)

Your notes cover _rollback_ but not deployment _strategy_, which is a natural senior follow-up.

|Strategy|How it works|Why use it|
|---|---|---|
|Rolling|Replace pods gradually, old and new versions briefly coexist|Default in K8s, minimal extra infra|
|Blue-Green|Deploy new version fully alongside old, then switch traffic instantly|Instant rollback (just switch back), but double the infra cost briefly|
|Canary|Send a small % of traffic to new version first, increase gradually|Lowest risk — catches issues before full rollout|

**Senior answer:** "For low-risk services I use rolling updates. For high-traffic, customer-facing services, I prefer canary — route 5% of traffic to the new version, watch error rates and latency via monitoring, then progressively increase. This catches regressions before they affect all users, and ties naturally into automated rollback if error rate crosses a threshold."

---

### 25. GitOps vs Direct Deploy (ArgoCD vs `kubectl apply` from the pipeline)

**Two philosophies:**

- **Push-based (what your Roboshop pipeline does):** GitHub Actions directly runs `kubectl apply` against the cluster. Simple, but the pipeline needs cluster credentials, and there's no single source of truth for "what's actually running."
- **Pull-based (GitOps, e.g. ArgoCD/Flux):** The pipeline only updates a Git repo (the manifest/Helm values). A controller running _inside_ the cluster watches that repo and applies changes itself.

**Senior answer:** "Push-based deploys are simpler to start with, but at scale I prefer GitOps — the cluster never has to expose credentials to the CI system, Git becomes the single source of truth for desired state, and drift detection is automatic since the controller continuously reconciles. The CI pipeline's job becomes 'build, test, and update the manifest repo' — deployment itself is decoupled from CI."

---

### 26. Cost & Runner-Minute Awareness

Senior engineers are expected to think about pipeline **cost**, not just speed:

- GitHub-hosted runners are billed per-minute (and Windows/macOS runners cost more per minute than Linux).
- Self-hosted runners shift cost to your own infra but remove per-minute billing.
- Unnecessary triggers (e.g. running full test suite on every doc-only change) waste money — tie back to **path filters** (#18).

**Senior answer:** "I think about CI/CD as both an engineering and a cost problem. I scope workflows with path filters, cache aggressively, and choose Linux runners wherever possible since they're the cheapest per minute — macOS/Windows only when the build genuinely requires that OS."

---

### 27. Multi-Cloud OIDC (Not Just AWS)

Your notes only cover AWS OIDC. Worth knowing the same pattern applies to Azure (via Workload Identity Federation) and GCP (Workload Identity Federation) — interviewers may ask if you've only worked with AWS to check you understand the _concept_ generalizes.

**Senior answer:** "The OIDC pattern isn't AWS-specific — it's a general trust relationship between GitHub as an identity provider and any cloud's IAM system. I've implemented it for AWS via IAM roles, and the same trust-token-then-temporary-credentials flow applies to Azure and GCP through their respective Workload Identity Federation setups."

---

### 28. Monitoring & Observability of Pipelines

Your notes mention troubleshooting _after something breaks_, but not proactive observability.

**Senior answer:** "I don't want to find out a pipeline is slow only when someone complains. I'd export workflow run metrics — duration, success/failure rate, queue time — to a dashboard like Datadog or Grafana, and alert if average pipeline duration trends upward or failure rate crosses a threshold. That turns CI/CD health into something measured, not anecdotal."

---

### 29. Custom Actions (Building Your Own)

If you've only _used_ actions, expect a question like "have you ever built one?"

- **JavaScript action**: runs directly on the runner, fast, but Node.js only.
- **Docker action**: packages any language/tool inside a container — slower to start, but flexible.
- **Composite action** (already covered): just YAML steps, no code to maintain.

**Senior answer:** "For simple reusable step sequences I use composite actions since there's no code to maintain. If I need actual logic — parsing a custom file format, calling an internal API — I'd build a JavaScript action for speed, or a Docker action if the tool isn't Node-based."

---

### 30. Local Testing Before Pushing (`act`)

A small but practical tool: `act` runs GitHub Actions workflows locally in Docker, so you can debug a workflow without pushing 10 commits to "fix CI."

**Senior answer:** "For quick iteration I test workflow logic locally with `act` before pushing — it saves the round-trip of pushing, waiting for the runner, finding a YAML typo, and repeating."

---

## PART 3 — SCENARIO QUESTIONS (your evening-drill list, answered)

Keep these answers in the **Problem → Response → Prevention** shape.

**1. Deployment suddenly takes 40 min instead of 8 — how do you investigate?** Compare against a previous successful run's step timings. Check cache hit/miss, dependency download time, Docker build time, security scan time, and (for self-hosted) CPU/memory/disk/network on the runner. Check if a recent workflow change correlates with the slowdown. Fix the _specific_ bottleneck — don't guess and add resources blindly.

**2. Secrets accidentally printed in logs — immediate actions?** Rotate the exposed credential immediately (assume compromise). Revoke active sessions/tokens tied to it. Restrict/delete the exposed log if possible. Investigate root cause (usually a debug `echo` or mishandled variable). Add safeguards: secret masking checks, code review rules, automated secret-scanning in CI (e.g. gitleaks).

**3. Self-hosted runner compromised — incident response?** Isolate it from the network immediately, stop it accepting new jobs. Assume every credential that runner had access to is compromised — rotate AWS keys, GitHub tokens, SSH keys. Collect logs for forensics. Rebuild from a known-good image rather than trying to "clean" the box. Root-cause and patch the gap afterward.

**4. Deploy to production only after staging validation passes — how?** Multi-stage workflow: auto-deploy to staging → run automated smoke/integration/health tests against staging → only on success does the job chain reach a production deploy job, which is additionally gated by an environment approval. `needs:` enforces the order; environment protection enforces the human check.

**5. Rollback strategy?** Use immutable, versioned releases (unique image tag per build). Rollback = redeploy the last known-good tag. In Kubernetes, use deployment revision history (`kubectl rollout undo`) or redeploy the previous tag via GitOps. For Terraform-managed infra, rollback is riskier since state has moved on — prefer a controlled forward-fix over reverting infrastructure state blindly.

**6. Security fix needed across hundreds of repos — design?** Centralize CI/CD logic into reusable workflows (`workflow_call`) maintained in one repo. All other repos consume it. Fix the security issue once in the central workflow; every consuming repo inherits it on the next run — no repo-by-repo patching.

**7. Risks of self-hosted runners?** Unpatched OS, privilege escalation, credential theft, malicious code persisting between jobs (since the VM isn't destroyed like GitHub-hosted), resource exhaustion, network exposure if not isolated in its own subnet/security group.

**8. Why is OIDC better than long-lived AWS credentials?** Long-lived keys must be stored, rotated, and monitored, and remain valid until manually revoked if leaked. OIDC issues short-lived, scoped credentials generated fresh per run after AWS validates a signed token — no static secret ever sits in GitHub, and exposure window shrinks to the lifetime of a single token.

**9. Prevent simultaneous production deployments?** `concurrency: group: production, cancel-in-progress: true` — ensures only one deployment workflow runs per environment at a time; newer runs cancel or queue behind older ones depending on config. Pair with environment approvals for a second layer of control.

**10. Design an enterprise CI/CD platform on GitHub Actions — how?** Standardize via reusable workflows for build/test/scan/deploy. Authenticate via OIDC (no static cloud keys anywhere). Store real secrets in a centralized secret manager (Vault/Secrets Manager), not scattered across repos. Run self-hosted, autoscaled runners (ARC) in isolated network segments. Gate production with environment approvals and branch protection. Bake in security scanning (SAST, dependency scanning, secret scanning, Trivy for containers). Add audit logging/monitoring for visibility. Treat the whole thing as a platform-engineering product — teams consume templates, they don't write pipelines from scratch.

```
Developers
   ↓
Repos (consume reusable workflows)
   ↓
OIDC Authentication (no static keys)
   ↓
Autoscaled Self-Hosted Runners (isolated network)
   ↓
Security Scans (SAST / dependency / secrets / container)
   ↓
Artifact / Image Registry
   ↓
Staging deploy → automated validation
   ↓
Environment Approval (Prod gate)
   ↓
Production (GitOps-reconciled)
   ↓
Monitoring & Audit Logging
```

---

## PART 4 — THE 3-MINUTE TALK TRACK (use for ANY topic above)

When asked about any feature, structure your answer in this order out loud:

1. **What problem existed before this feature?**
2. **Why was that a real problem (cost, risk, speed)?**
3. **How does GitHub Actions solve it — mechanism, not just buzzword.**
4. **A real example from your own work (Roboshop, Terraform, etc.)**
5. **Benefit.**
6. **Tradeoff — this is what separates senior from mid-level. Always name one honestly.**
7. **How you'd troubleshoot it if it broke.**

If you can do this unscripted for all 30 topics in this document, you are ready for follow-up "why?" drilling — because you've already pre-answered the first "why."

Share