# Runbook: High Error Rate in Production

**Alert:** `HighErrorRate`
**Severity:** Critical
**Expected resolution time:** < 15 minutes

---

## What This Alert Means

More than 5% of HTTP requests to a service are returning 5xx errors over a 3-minute window. This is customer-facing — act immediately.

---

## Step 1 — Assess Scope (2 minutes)

Open Grafana → **Service Health Dashboard**

```
Dashboard URL: https://grafana.myorg.com/d/service-health
```

Answer these questions:
- Is it one service or multiple?
- Is error rate climbing, stable, or dropping?
- Did it coincide with a recent deployment? (check ArgoCD)
- Is it affecting all instances or a subset?

---

## Step 2 — Check Recent Deployments (1 minute)

```bash
# Check ArgoCD for recent syncs
argocd app history <service-name> --namespace argocd

# Check last 5 deployments
kubectl rollout history deployment/<service-name> -n <namespace>
```

**If a deployment happened in the last 30 minutes → go to Step 3 (rollback)**
**If no recent deployment → go to Step 4 (investigate)**

---

## Step 3 — Rollback (3 minutes)

```bash
# Immediate rollback via ArgoCD (preferred — keeps Git as source of truth)
argocd app rollback <service-name> --namespace argocd

# OR via kubectl if ArgoCD is unavailable
kubectl rollout undo deployment/<service-name> -n <namespace>

# Verify rollback succeeded
kubectl rollout status deployment/<service-name> -n <namespace>

# Check error rate dropped in Grafana — should recover within 2 minutes
```

After rollback:
1. Confirm error rate drops below 1%
2. Post in `#incidents` Slack: "Rolled back `<service>` to previous version — investigating root cause"
3. Open a post-mortem ticket

---

## Step 4 — Investigate (if not a deployment issue)

```bash
# Get error logs from the last 10 minutes
kubectl logs -l app=<service-name> -n <namespace> --since=10m | grep -i error

# Check if pods are healthy
kubectl get pods -n <namespace> -l app=<service-name>

# Describe a crashing pod
kubectl describe pod <pod-name> -n <namespace>

# Check downstream dependencies (DB, external APIs)
kubectl exec -it <pod-name> -n <namespace> -- curl -s http://dependency-service/health
```

**Common causes:**
- Database connection pool exhausted → check RDS CloudWatch metrics
- Downstream service degraded → check that service's error rate in Grafana
- Memory leak causing OOMKills → check `kubectl get events -n <namespace>`
- Certificate expiry → check cert-manager: `kubectl get certificates -A`

---

## Step 5 — Escalation

If not resolved within 15 minutes:
1. Page the on-call engineer: `/pd trigger` in Slack
2. Loop in the service team lead
3. Consider enabling maintenance mode: `kubectl scale deployment/<service> --replicas=0 -n <namespace>`

---

## Post-Incident

Within 24 hours:
- [ ] Write a 5-Why root cause analysis
- [ ] Add a test or monitoring that would have caught this earlier
- [ ] Update this runbook if steps were missing or wrong
- [ ] Share learnings in the weekly platform sync

---

## Related Runbooks
- [Pod CrashLoop](./pod-crashloop.md)
- [Database Connection Issues](./db-connection.md)
- [Rollback Procedure](./rollback.md)
