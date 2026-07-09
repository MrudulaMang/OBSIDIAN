# ADR-001: Multi-Account AWS Strategy over Single Account

**Date:** 2024-01-10
**Status:** Accepted
**Author:** Platform Team

---

## Context

We started with a single AWS account for all environments. As the team grew to 15 engineers and 12 microservices, we ran into serious problems:

- A dev misconfiguration brought down a production RDS instance (the IAM role had too broad permissions)
- AWS Service Control Policies couldn't be applied granularly
- Cost attribution was impossible — one bill, all environments mixed
- Security audit found dev engineers had read access to prod secrets

We needed to decide: stay in one account with better guardrails, or move to multiple accounts?

---

## Decision

**We moved to a multi-account strategy using AWS Organizations:**

- `dev` account — unrestricted experimentation, engineers have broad access
- `staging` account — mirrors prod config, limited engineer access
- `prod` account — strict IAM, no direct human access (all changes via GitOps)
- `shared-services` account — ECR, Route53, ACM, centralized CloudTrail

---

## Alternatives Considered

### Option 1: Single account with better IAM boundaries
- **Pro:** Simpler to manage, no cross-account complexity
- **Con:** IAM policies are hard to audit at scale; blast radius of a mistake is still the whole account; SCP enforcement is not possible within a single account
- **Verdict:** Rejected — IAM alone can't provide the isolation we need

### Option 2: Multi-account (chosen)
- **Pro:** Hard isolation between environments; each account has its own billing; SCP at org level enforces guardrails; prod has zero dev access
- **Con:** Cross-account IAM roles add complexity; ECR images need cross-account pull permissions; more Terraform state files to manage
- **Verdict:** Accepted — the security and cost clarity wins outweigh the operational complexity

---

## Consequences

**Positive:**
- No incident has crossed account boundaries since migration
- AWS Cost Explorer now shows per-account spend — team leads can see their costs
- Prod account has no human IAM users — only IRSA roles and the GitOps service account
- Security audit findings related to cross-env access: 0 (down from 7)

**Negative:**
- Engineers needed onboarding on assuming cross-account roles
- Terraform remote state management is more complex (one S3 bucket per account)
- Cross-account ECR pull required adding resource policies to every image repo

---

## Review Date

Revisit if team grows beyond 100 engineers — may need per-team accounts at that point.
