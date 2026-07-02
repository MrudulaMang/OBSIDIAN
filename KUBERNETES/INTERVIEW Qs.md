![[Pasted image 20260510010023.png]]

answers these questions

1. Zero-downtime deployment in Kubernetes

I would design it around controlled rollout, health validation, and rollback safety—not just “use rolling update.”

First, I’d use a Deployment with a RollingUpdate strategy:

- maxUnavailable: 0 → ensures no existing pods are killed before replacements are ready
- maxSurge: 1 or more → allows extra pods during rollout

Second, readiness probes are critical. Traffic should only reach pods after the application is actually ready, not just because the container started. Many failures happen because people confuse liveness with readiness.

Third, I’d use proper resource requests/limits so the scheduler can place new pods. Many “zero-downtime” failures are actually capacity failures where new pods never schedule.

Fourth, I’d use PodDisruptionBudgets to prevent voluntary disruptions from reducing availability during upgrades or node maintenance.

For higher-risk releases:

- Blue-Green for instant switch + easy rollback
- Canary for gradual exposure and metrics-based validation

Also:

- backward-compatible DB migrations
- version-safe APIs
- rollback strategy tested in advance

Most people fail because they think deployment strategy alone guarantees zero downtime. It doesn’t. Readiness, capacity, and dependency compatibility matter more.

---

2. When to choose StatefulSet over Deployment

I use Deployment for stateless apps:  
web servers, APIs, microservices.

I use StatefulSet when identity and persistence matter:  
databases, Kafka, ZooKeeper, Elasticsearch, Redis clusters, etc.

Why:  
StatefulSet gives:

- stable pod identity (db-0, db-1)
- stable persistent volumes per pod
- ordered startup/shutdown
- ordered rolling updates

A Deployment treats pods as replaceable cattle.  
A StatefulSet assumes each pod has identity and attached state.

Complications:

- scaling down can risk data handling issues
- storage management becomes critical
- failed pod recovery is more sensitive
- upgrades require more caution
- split-brain risks in clustered systems

People often misuse StatefulSet for simple apps because “it sounds advanced.” That’s bad engineering. StatefulSet is complexity you should justify.

---

3. Last time I debugged a failing pod — systematic process

I never start by restarting the pod. That hides evidence.

My flow:

Step 1: Identify pod state

kubectl get pods -n <ns>

Check:  
CrashLoopBackOff?  
Pending?  
OOMKilled?  
ImagePullBackOff?  
Init container failure?

Different failure types mean different investigations.

Step 2: Describe the pod

kubectl describe pod <pod>

This reveals:

- events
- scheduling failures
- probe failures
- mount issues
- secret/configmap problems
- node-level issues

This is where most answers already exist.

Step 3: Check logs

kubectl logs <pod>  
kubectl logs <pod> --previous

Especially --previous for crash loops.

I look for:

- startup failures
- dependency timeouts
- DB auth failures
- DNS resolution problems
- port binding issues

Step 4: Validate dependencies

Sometimes pod is healthy but environment is broken:

- DB unreachable
- DNS broken
- IAM permission denied
- service account issue
- secret expired
- network policy blocked

People wrongly blame Kubernetes for application dependency failures.

Step 5: Node-level check if needed

If issue looks infra-related:

- disk pressure
- memory pressure
- node not ready
- kubelet issue
- container runtime issue

Then:  
kubectl describe node

Where people mess up:  
They debug symptoms, not failure domains.

They say:  
“pod failed”

Wrong.

Ask:  
Did scheduling fail?  
Did container fail?  
Did app fail?  
Did dependency fail?  
Did infrastructure fail?

That separation is what makes debugging fast.

