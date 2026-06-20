Think of **governance** as the umbrella.
You can answer:

> Governance is the process of enforcing organizational rules and standards on infrastructure deployments. It ensures infrastructure complies with security, operational, compliance, and cost requirements before changes are applied.

Under governance sit:

- Security policies
- Operational policies
- Compliance policies
- Cost policies

A simple hierarchy:
Governance
│
├── Security
│   ├── Encrypt EBS
│   ├── No public S3 buckets
│   └── MFA required
│
├── Operational
│   ├── Mandatory tags
│   ├── Naming standards
│   └── Approval workflows
│
├── Compliance
│   ├── GDPR
│   ├── HIPAA
│   └── Data residency
│
└── Cost
    ├── No expensive instances in Dev
    └── Budget limits

```

So if someone asks:

> "What is governance in Terraform?"



Even simpler:

> Governance = Guardrails for infrastructure.

Terraform creates resources.

Governance decides:

```
Should this resource be allowed?
```

If yes:

```
terraform apply
```

If no:

```
❌ Blocked by policy
```

That's governance in one sentence:

> **Governance is the set of rules and controls that determine what infrastructure can and cannot be deployed.**