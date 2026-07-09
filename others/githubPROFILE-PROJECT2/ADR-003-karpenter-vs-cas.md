# ADR-003: Karpenter over Cluster Autoscaler

**Date:** 2024-02-05
**Status:** Accepted
**Author:** Platform Team

---

## Context

Our EKS clusters were using the Kubernetes Cluster Autoscaler (CAS). It worked, but we had recurring problems:

- Scale-up took 3–5 minutes — pods sat Pending while nodes bootstrapped
- Node groups were fixed instance types — we'd over-provision to handle peaks
- Spot interruptions caused 2–3 minute outages because CAS didn't handle rebalancing well
- Monthly EC2 cost was consistently 40–50% higher than AWS Compute Optimizer recommended

---

## Decision

**Replace Cluster Autoscaler with Karpenter.**

---

## Alternatives Considered

### Option 1: Cluster Autoscaler (existing)
- **Pro:** Battle-tested, well-documented, familiar to the team
- **Con:** Works at node group level — can't pick the best instance type per workload; slow to react; no bin-packing consolidation
- **Verdict:** Rejected — cost and speed problems outweigh familiarity

### Option 2: Karpenter (chosen)
- **Pro:** Provisions nodes in ~30 seconds; picks optimal instance type per pod requirements; consolidates underutilised nodes automatically; native spot interruption handling
- **Con:** Newer project (less community knowledge); requires IRSA setup; node pools need careful tuning; not compatible with managed node groups for app workloads
- **Verdict:** Accepted

### Option 3: KEDA + fixed node groups
- **Pro:** Good for event-driven scaling
- **Con:** Still doesn't solve the node provisioning speed or cost problem
- **Verdict:** Not applicable for general workload autoscaling

---

## Results (3 months post-migration)

| Metric | CAS | Karpenter |
|--------|-----|-----------|
| Scale-up time | 3–5 min | 25–40 sec |
| EC2 monthly cost | $4,200 | $2,750 |
| Spot interruption recovery | Manual runbook | Automatic |
| Node utilisation (avg) | 41% | 68% |

**34% cost reduction.** The provisioning speed improvement alone paid for the migration effort.

---

## Tradeoffs We Accepted

- We maintain a small fixed node group (`system` node group, 2x t3.medium) for critical system pods (CoreDNS, kube-proxy, ArgoCD) that must never be on spot or subject to Karpenter consolidation.
- Karpenter version upgrades require more careful testing — we pin versions and test in dev before rolling to prod.

---

## Review Date

Revisit when Karpenter reaches v1.0 stable — API changes may require migration.
