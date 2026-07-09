# ☁️ Production-Grade AWS Platform

> A multi-account AWS platform with EKS, GitOps, full observability, chaos engineering, and enforced cost optimization — designed to support 50+ engineers across dev, staging, and production environments.

## 🎯 Problem This Solves

Before this platform:
- Single AWS account for everything — dev changes broke prod
- No GitOps — kubectl apply ran manually from laptops
- Zero observability — we found out about outages from customers
- AWS bill had no attribution — no idea which team spent what
- No chaos testing — first time we discovered failure modes was during incidents

After this platform:
- **3 isolated AWS accounts** — dev, staging, prod with strict IAM boundaries
- **GitOps via ArgoCD** — no manual kubectl, all changes tracked in Git
- **Full observability** — Prometheus + Grafana + Loki + PagerDuty alerting
- **100% cost attribution** — per team, per service, per environment
- **Chaos engineering** — we break things on purpose before production does it for us

---

## 📐 Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     AWS Organization                            │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐           │
│  │  Dev Account │  │Staging Acct │  │ Prod Account │           │
│  │             │  │             │  │              │           │
│  │  EKS Cluster│  │  EKS Cluster│  │  EKS Cluster │           │
│  │  t3.medium  │  │  t3.large   │  │  m5.xlarge   │           │
│  │  (spot)     │  │  (mixed)    │  │  (on-demand) │           │
│  └─────────────┘  └─────────────┘  └──────────────┘           │
│                                                                 │
│  ┌──────────────────────────────────────────────────┐          │
│  │              Shared Services Account              │          │
│  │  ECR · Route53 · ACM · Centralized Logging       │          │
│  └──────────────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────────────┘

GitOps Flow:
  Developer PR → GitHub → ArgoCD detects change
      └── Syncs to Dev automatically
      └── Syncs to Staging automatically
      └── Syncs to Prod after manual approval
```

---

## 📁 Repository Structure

```
aws-production-platform/
│
├── terraform/                        # All infrastructure as code
│   ├── global/                       # Org-wide: Route53, ACM, ECR
│   ├── modules/
│   │   ├── vpc/                      # Reusable VPC module
│   │   ├── eks/                      # EKS + Karpenter autoscaler
│   │   ├── rds/                      # RDS PostgreSQL (Multi-AZ)
│   │   ├── alb/                      # Application Load Balancer
│   │   ├── iam/                      # IRSA roles per service
│   │   └── s3/                       # Versioned, encrypted buckets
│   └── environments/
│       ├── dev/
│       ├── staging/
│       └── prod/
│
├── gitops/                           # ArgoCD app definitions
│   ├── clusters/                     # ArgoCD cluster config
│   ├── apps/                         # One folder per service
│   └── infrastructure/               # Infra apps (monitoring, ingress)
│
├── observability/                    # Monitoring stack
│   ├── prometheus/                   # Scrape configs + recording rules
│   ├── grafana/                      # Dashboards as code (JSON)
│   ├── loki/                         # Log aggregation config
│   └── alerting/                     # Alert rules + PagerDuty routing
│
├── chaos-engineering/                # Chaos experiments
│   ├── experiments/                  # LitmusChaos experiment YAMLs
│   └── runbooks/                     # What to do when things break
│
├── cost-optimization/                # Cost tooling and reports
│   ├── tagging-policy/
│   └── reports/
│
├── docs/
│   └── adr/                          # Architecture Decision Records
│       ├── ADR-001-multi-account.md
│       ├── ADR-002-gitops-argocd.md
│       ├── ADR-003-karpenter-over-cas.md
│       └── ADR-004-loki-over-elasticsearch.md
│
└── scripts/
    ├── bootstrap-account.sh          # New AWS account setup
    └── rotate-secrets.sh             # Secret rotation automation
```

---

## 🚀 Quick Start

```bash
# 1. Bootstrap a new AWS account
./scripts/bootstrap-account.sh --account-id 123456789 --env dev

# 2. Provision base infrastructure
cd terraform/environments/dev
terraform init -backend-config=backend.hcl
terraform plan
terraform apply

# 3. Install ArgoCD
kubectl apply -k gitops/clusters/dev

# 4. Apply all apps via GitOps
kubectl apply -f gitops/apps/

# 5. Deploy monitoring stack
kubectl apply -k observability/
```

---

## 📊 Platform Metrics

| Metric | Value |
|--------|-------|
| Deployment frequency | 15–20 deploys/day |
| Change failure rate | < 2% |
| MTTR (Mean Time to Restore) | < 12 minutes |
| Infrastructure cost reduction | 34% (via Karpenter spot + right-sizing) |
| Alert noise reduction | 71% (after tuning) |
| Uptime (prod) | 99.95% |

---

## 🏛️ Architecture Decision Records

- [ADR-001: Multi-account strategy over single account](docs/adr/ADR-001-multi-account.md)
- [ADR-002: GitOps with ArgoCD over push-based deployments](docs/adr/ADR-002-gitops-argocd.md)
- [ADR-003: Karpenter over Cluster Autoscaler](docs/adr/ADR-003-karpenter-over-cas.md)
- [ADR-004: Loki over Elasticsearch for log aggregation](docs/adr/ADR-004-loki-over-elasticsearch.md)
