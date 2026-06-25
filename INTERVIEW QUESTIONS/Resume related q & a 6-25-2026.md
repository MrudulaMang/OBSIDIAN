**Senior DevOps Engineer — Resume Interview Q&A Prep**

Model answers for likely questions tied to your resume. Replace any bracketed placeholder with your real number, tool name, or specific incident before using it in an interview.

**1. GITOPS / ARGOCD**

**Q:** **How is ArgoCD different from a push-based Jenkins deploy?**

In our setup, the pipeline — GitHub Actions or Jenkins — handled build, test, and security scanning, but it stopped short of pushing the deploy directly once we brought in ArgoCD. Its job ended at updating the image tag in a manifests repo. ArgoCD watched that repo and pulled the change, reconciling the cluster to match what's in Git, instead of CI just assuming the deploy worked and walking away.

**Q:** **What happens when someone manually changes something in the cluster?**

ArgoCD diffs the live state against Git continuously. If someone runs a manual `kubectl edit`, it shows up as OutOfSync. For sensitive apps we kept that as manual sync, so a human had to approve the correction — self-heal once reverted a legitimate hotfix someone made mid-incident. For lower-risk apps we let self-heal auto-correct drift.

**Q:** **How do you handle secrets, since you shouldn't commit them to Git?**

We never put raw secrets in the manifests repo. We used _[External Secrets Operator / your tool]_ to reference values stored in _[Secrets Manager/Vault]_ — what's in Git is just a pointer; the real value gets synced into a Kubernetes Secret outside Git entirely.

**Q:** **Walk me through a rollback.**

Because everything's Git-driven, a rollback was just `git revert` on the manifests repo to the last known-good commit — ArgoCD picks that up and reconciles the cluster back, usually within a minute or two. We had a bad image tag get promoted once, and instead of scrambling with kubectl we just reverted the commit and watched it sync back.

**2. COST OPTIMIZATION**

**Q:** **How did you find what was actually costing money?**

We started with Cost Explorer broken down by service and tag — EC2/EKS compute and a few oversized RDS instances were the biggest chunk. On the Kubernetes side we used _[Kubecost/your tool]_ to see cost per namespace and workload, which made it obvious which services were over-provisioned.

**Q:** **How do you decide right-sizing for instances or pods?**

We looked at real CPU/memory utilization over a couple of weeks via CloudWatch and Prometheus, rather than going off what teams originally requested — a lot of services were set way higher than needed "just to be safe." We brought requests down closer to actual P95 usage, turned on Cluster Autoscaler and HPA so capacity could flex with traffic, and moved batch/non-critical workloads to spot instances.

**Q:** **Did you ever cut too close?**

Yes — we trimmed memory on one service a bit too aggressively, and it got OOMKilled during a traffic spike days later. After that we based right-sizing on peak/P95 usage instead of averages, and rolled changes out gradually with monitoring in between rather than everywhere at once.

**Q:** **Break down where the 25% actually came from.**

Roughly _[X]_% from right-sizing over-provisioned requests/limits, _[X]_% from moving non-prod environments to a schedule (shut off nights/weekends), and _[X]_% from spot instances on stateless, non-critical workloads. Reserved Instances/Savings Plans covered the steady-state baseline on top of that.

**3. DISASTER RECOVERY / BACKUP-RESTORE**

**Q:** **What were your RTO/RPO targets?**

For our critical services we targeted an RTO of around _[X hours]_ and an RPO of around _[X minutes]_ — meaning we could tolerate losing at most _[X]_ of data and needed to be back up within _[X]_.

**Q:** **Walk me through an actual DR test you ran.**

We simulated losing an entire EKS cluster — restored persistent volumes from Velero backups into a fresh cluster, and restored RDS from a recent snapshot into a new instance. The restore took longer than expected, mainly because of _[your actual bottleneck]_. We documented that and adjusted the runbook and backup frequency afterward.

**Q:** **How do you back up stateful stuff in Kubernetes — PVs, databases?**

For PVs we used Velero, which snapshots the underlying EBS volumes and restores them into a new cluster. For RDS we relied on automated daily snapshots plus point-in-time recovery, and we periodically test-restored those into non-prod to confirm the backups were actually usable, not just being taken.

**4. SECRETS MANAGEMENT**

**Q:** **Why Secrets Manager over Vault, or vice versa?**

We went with _[your actual choice]_ mainly because _[reason — e.g., native IAM/IRSA integration meant no separate auth layer to run, vs. Vault giving dynamic secrets but more operational overhead]_.

**Q:** **How do secrets get into the pod — env var or mounted file?**

We synced values into native Kubernetes Secrets and mounted them as files wherever possible. Mounted files are safer than env vars — env vars can leak into process dumps or get logged by an error handler.

**Q:** **How do you rotate without downtime?**

Rotation runs on a schedule via _[Lambda/your mechanism]_ for things like DB credentials. The trickier part is getting the running app to pick up the new value without a restart — for services that only read the secret at startup, we either triggered a rolling restart after rotation, or moved to a pattern where the app periodically reloads instead of caching the value forever.

**Q:** **How do you keep secrets out of CI/CD logs?**

We used GitHub Actions' encrypted secrets, which get auto-masked in console output. The bigger discipline was never echoing variables in debug steps — we caught a misconfigured error handler once that was logging the full environment object on crash, which would've leaked a secret if it ever fired during a real incident.

**5. TERRAFORM / IAC & LANDING ZONES**

**Q:** **Walk me through your module structure — how granular, and how do you version them?**

We kept modules scoped to a single concern — VPC, EKS, IAM, Route53, Auto Scaling — each as its own module rather than one giant "infrastructure" module. They're versioned via Git tags, and consuming teams pin to a specific tag rather than tracking `main`, so a module update doesn't silently break someone's environment.

**Q:** **How do multiple teams use the same modules without stepping on each other's state?**

Each team/environment has its own state file — we never shared one state across teams. The module code is shared and reused; the state is isolated per consumer. That's the part people get wrong: reusable module ≠ shared state.

**Q:** **What's in your remote state setup, and what does locking actually prevent?**

S3 for the state file itself, DynamoDB for locking. The lock prevents two people — or two pipeline runs — from running `apply` at the same time and corrupting state or applying conflicting changes. Without it, a second apply kicking off mid-run can leave state and real infrastructure out of sync.

**Q:** **Tell me about a time `terraform apply` did something you didn't expect.**

_[Insert a real one if you have it — e.g., a renamed resource that Terraform read as "destroy + recreate" instead of "modify," taking down something live.]_ The fix was reviewing the plan output more carefully before applying, and for anything destructive, using `terraform plan` in CI with a required manual approval step before `apply` ran.

**Q:** **How do you handle secrets or sensitive values in Terraform state?**

State files can contain plaintext values, so we treated the S3 bucket itself as sensitive — encryption at rest, restricted IAM access, no broad read access. For actual secret values, we referenced them from Secrets Manager/SSM Parameter Store inside the Terraform config rather than hardcoding them as variables.

**Q:** **What does "removing configuration drift across environments" mean concretely?**

Before, dev/QA/staging were partially hand-built or had one-off changes applied directly in the console, so they didn't match what Terraform thought existed. We brought everything under the same modules with environment-specific `tfvars`, so all environments are provisioned from the same code path and `terraform plan` actually reflects reality instead of showing constant unexplained diffs.

**Q:** **How do you structure environments — separate state, workspaces, or separate repos?**

_[Pick what you actually did]_ — e.g., separate state files per environment using a consistent backend key pattern (`env/dev/terraform.tfstate`, `env/prod/terraform.tfstate`), rather than Terraform workspaces, since workspaces made it too easy to apply against the wrong environment by forgetting to switch.

**6. KUBERNETES / EKS ARCHITECTURE & TROUBLESHOOTING**

**Q:** **Walk me through diagnosing a CrashLoopBackOff from scratch.**

First `kubectl describe pod` to see the last termination reason and events, then `kubectl logs --previous` to see what the container printed right before it died. From there it usually splits into: a real application error (bad config, missing dependency), a failing liveness probe killing a healthy app too aggressively, or a resource limit causing an OOM kill that shows up as a crash loop rather than an obvious OOM message.

**Q:** **OOMKilled vs. a regular crash — how do you fix it long-term?**

OOMKilled shows a specific exit reason and code 137 — the kernel killed it for exceeding its memory limit. A regular crash is the app exiting on its own. Short-term fix is bumping the limit; long-term is profiling actual memory usage and fixing a leak or setting limits based on real P95 usage instead of a guess.

**Q:** **How did you design for multi-AZ HA?**

Both — node groups spread across multiple AZs so losing one AZ doesn't take out all capacity, and pod topology spread constraints / anti-affinity so replicas of the same service don't all land in one AZ even when nodes are available everywhere.

**Q:** **Tell me about an EKS upgrade that went wrong or went smoothly.**

_[Insert real example.]_ Generally: upgrade the control plane first, then node groups one at a time using a rolling/blue-green node group swap rather than in-place, watching pod disruption budgets so workloads stay available throughout.

**Q:** **How do you handle node group lifecycle during an upgrade with zero downtime?**

We'd spin up a new node group on the target version, cordon and drain the old nodes gradually so pods reschedule onto the new nodes, and only terminate old nodes once everything's confirmed healthy — combined with PodDisruptionBudgets so we never drop below minimum replicas for a service mid-drain.

**Q:** **What ingress controller did you use, and why?**

_[AWS Load Balancer Controller / NGINX — say which one you actually used.]_ We went with the ALB Controller because it integrates directly with native AWS ALBs and gave us automatic target group management without running an extra ingress layer ourselves.

**Q:** **Explain IRSA like I've never heard of it.**

Without IRSA, pods either inherit the node's IAM role — way too broad, every pod on that node gets the same permissions — or you're managing static AWS credentials inside the pod, which is worse. IRSA lets a specific Kubernetes service account assume a specific IAM role via OIDC federation, so each workload only gets the exact AWS permissions it needs, scoped to that one service account.

**Q:** **DNS resolution failures — what was actually wrong?**

_[Insert your real root cause — e.g., CoreDNS pods getting throttled/OOM under high query volume, or a NetworkPolicy blocking egress to kube-dns.]_ We fixed it by _[scaling CoreDNS replicas / adding the NetworkPolicy exception / tuning the ndots setting]_, and added a CoreDNS-specific alert so it surfaces before it becomes a full outage next time.

**7. CI/CD PIPELINES**

**Q:** **Walk me through your pipeline stages end to end.**

Build → unit tests → SonarQube static analysis → Trivy image scan → push to registry → deploy to staging automatically → manual approval gate → deploy to prod. Anything that fails security scanning or tests blocks the pipeline before it ever reaches staging.

**Q:** **70% reduction in deployment lead time — lead time from what to what?**

From "code merged" to "running in production." Before, that involved manual handoffs between dev and ops, manual approvals tracked outside the tool, and inconsistent pipeline definitions per repo. Standardizing on one reusable workflow template across repos removed most of that manual coordination time.

**Q:** **GitHub Actions vs. Jenkins — why both?**

_[Be honest about the real split — e.g., GitHub Actions for newer repos already living in GitHub, Jenkins for legacy pipelines that predated the migration and weren't worth rewriting yet.]_ We were gradually consolidating toward GitHub Actions, but Jenkins still owned anything tightly coupled to older on-prem-adjacent steps.

**Q:** **How do self-hosted runners differ from GitHub-hosted, and what are the security tradeoffs?**

GitHub-hosted runners are ephemeral and fully managed — fresh VM every run, no persistent state, no network access to internal resources. Self-hosted runners gave us access to internal/VPC resources and more control over the toolchain, but the tradeoff is we owned patching and securing them, and had to be careful about which repos could even target them — a self-hosted runner usable by a public repo is a real attack surface for arbitrary code execution against your own network.

**Q:** **How do you prevent a bad deploy from reaching 20+ repos at once?**

The shared workflow lives in one reusable workflow file pinned by a version tag, not by branch — so repos pull a specific tested version, not whatever's currently on `main`. Changes to the shared workflow go through their own review and get rolled out by bumping the version tag gradually rather than every consumer picking it up instantly.

**8. SECURITY & GOVERNANCE**

**Q:** **How is RBAC actually structured in your clusters?**

Role-per-namespace combined with role-per-team — a team's service account gets a Role scoped to their namespace with only the verbs they need (get/list/watch for most things, write access only where justified), rather than ClusterRole admin access by default.

**Q:** **What does a Trivy/SonarQube finding actually block?**

_[Be specific about your real gate — e.g., Critical/High CVEs fail the build outright; Medium/Low log a warning but don't block.]_ SonarQube's quality gate failed the build on new critical code smells or a drop in coverage below a threshold, rather than just reporting after the fact.

**Q:** **What did "periodic infrastructure security review" look like in practice?**

_[Pick what's true — e.g., a quarterly internal review where we walked through IAM policies looking for overly broad permissions, checked for unused access keys/roles, and cross-referenced against AWS Trusted Advisor/Security Hub findings.]_

**Q:** **An example of least-privilege IAM going wrong before you tightened it?**

_[Insert real example — e.g., a CI role originally had broad `s3:*` access because it was easier to set up, and we later scoped it down to exactly the buckets/actions it needed after a security review flagged it.]_

**9. OBSERVABILITY & INCIDENT RESPONSE**

**Q:** **60% MTTR reduction — what changed specifically?**

Before, alerts were noisy and dashboards were scattered per-service, so the first 15-20 minutes of any incident were spent just figuring out what was actually wrong. Centralizing into Prometheus/Grafana with service-level dashboards and tighter, actionable alert thresholds cut that triage time dramatically — most of the MTTR drop came from faster detection and localization, not faster fixes.

**Q:** **How do you avoid alert fatigue at this scale?**

Alerting on symptoms that actually affect users (error rate, latency, availability) rather than every underlying metric, tiered severity so only real pages wake someone up, and routinely pruning alerts that fired without ever leading to action.

**Q:** **Walk me through an actual incident end-to-end.**

_[Use a real one.]_ Detected via _[alert/dashboard]_ → checked recent deploys/changes first since that's the most common cause → isolated to _[specific service/cause]_ → mitigated by _[rollback/scale-up/config fix]_ → wrote up RCA covering root cause, timeline, and the follow-up action item that prevents recurrence.

**Q:** **What's in your ELK pipeline, and how do you control log volume cost?**

_[Specify what you actually ship — app logs, ingress logs, etc.]_ We controlled volume by setting appropriate log levels per environment (debug only in non-prod), filtering out noisy/low-value log lines before they hit the pipeline, and using index lifecycle management to age out and delete old indices instead of keeping everything indefinitely.

**10. CONTAINER / DOCKER**

**Q:** **What did "container image optimization" involve?**

Multi-stage builds so build tools and dependencies never end up in the final image, switching to smaller base images (alpine/distroless where the app supported it), and ordering Dockerfile layers so frequently-changing code comes after dependency installation, to maximize layer cache hits on rebuilds.

**Q:** **Give me a before/after image size or build time number.**

_[Insert your real numbers — e.g., "we cut a Node service image from roughly 900MB down to under 150MB switching to a multi-stage build with an alpine runtime stage," or build time improvement from better layer caching.]_

**Q:** **How do you scan images without slowing the pipeline down too much?**

Trivy scans run against the built image in parallel with other pipeline steps rather than blocking serially, and we cache the vulnerability database between runs instead of re-downloading it every time, which was the actual slow part.

**11. PLATFORM ENGINEERING**

**Q:** **What does "Internal Developer Platform" / "self-service provisioning" mean concretely?**

_[Pick what's true — e.g., a curated catalog of pre-approved Terraform modules that teams can compose for their own environments without filing a ticket to the platform team, with guardrails baked into the module itself rather than enforced manually after the fact.]_

**Q:** **How do you balance standardization against teams wanting flexibility?**

We standardized the things that have real blast radius if done wrong — networking, IAM, security baselines — and left application-level configuration flexible. Teams get a golden path that's fast by default, with an escape hatch to request an exception when they have a genuine reason to deviate, rather than a single rigid template with no flexibility at all.

**12. CAREER NARRATIVE / POSITIONING**

**Q:** **Your resume says 9+ years IT, 4+ years DevOps — walk me through that transition.**

I spent the earlier part of my career as an application and ETL developer, working close to production systems, data pipelines, and release activities. Over time I found I was more drawn to the infrastructure and reliability side of things than to feature development — how systems get deployed, scaled, and kept running — so I moved deliberately into DevOps, starting with CI/CD and infrastructure automation and growing into platform-level ownership over Terraform, Kubernetes, and AWS.

**Q:** **What from your ETL/application dev background do you still use day-to-day?**

SQL and data-flow thinking come up constantly — debugging a pipeline issue often comes down to the same instincts as debugging a stuck ETL job: trace the data, find where it actually stopped, don't assume. It also gave me a production-support mindset early — I was doing on-call-style troubleshooting and RCA writeups long before "DevOps" was the job title.

**Q:** **Why specialize in DevOps rather than stay in development?**

I liked development, but I got more energy from solving "why is this slow/down/inconsistent across environments" problems than from building net-new features. DevOps let me work across the whole stack — infra, deployment, reliability — instead of one layer of it.

**Q:** **You're at [Company] since 2022 — what's kept you there, and why look now?**

_[Be honest and specific — e.g., "I've owned the platform's growth from a handful of services to 100+ microservices, which has been a great problem to work on. I'm looking now because I want to keep growing into more architecture-level ownership, and I want to see how a different team/scale approaches these same problems."]_

**13. BEHAVIORAL / SENIOR-LEVEL**

**Q:** **Tell me about a time you disagreed with another team's approach to infrastructure.**

_[Use the STAR structure with a real example.]_ Situation/Task: what the disagreement was about. Action: how you brought data or a prototype rather than just opinion to make the case. Result: what was actually decided, and how you handled it if they didn't go your way.

**Q:** **How do you get buy-in from multiple teams to adopt a shared module or framework?**

Lead with the team's own pain point, not the framework itself — show them the time/risk they'd save rather than asking them to adopt something "because it's standard." Start with one willing team as a reference implementation, then use that as proof when other teams push back.

**Q:** **Tell me about a decision you'd do differently now.**

_[Pick a real, specific technical decision — e.g., an early Terraform module that wasn't granular enough and became painful to maintain, or a self-heal ArgoCD policy applied too broadly before you understood the blast radius.]_ Be honest about what you'd change and why — this question is testing self-awareness, not perfection.

**Q:** **How do you mentor or support junior engineers?**

_[Use something real — e.g., pairing on root-cause debugging instead of just handing them the fix, or writing runbooks so production knowledge isn't only in your head.]_

**14. CERTIFICATIONS**

**Q:** **CKA — what's been the hardest part of prep?**

_[Be honest — e.g., the time pressure on the exam more than the concepts themselves, or troubleshooting scenarios under the clock since that's different from troubleshooting calmly on the job.]_

**Q:** **How has the AWS Solutions Architect cert changed how you design infrastructure?**

It gave me a more deliberate framework for thinking about tradeoffs — availability vs. cost, managed services vs. self-managed — rather than defaulting to whatever I'd used before. It shows up in things like choosing when a managed service (RDS, EKS Fargate) is worth the cost premium versus running it ourselves.

**HOW TO USE THIS**

Read each answer out loud once, then try answering from memory without looking — the goal isn't to recite this script verbatim, it's to have the structure loaded so you're not building the answer from scratch live. Fill in every `_[bracket]_` with your real specifics before your next interview; a vague placeholder is more obvious to an interviewer than just saying "I don't have an exact number, but roughly..."