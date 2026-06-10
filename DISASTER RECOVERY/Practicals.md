Good instinct. Most people learn DR conceptually but never actually fail a system and recover it. The learning happens during recovery.

For your stage, don't rush into a full multi-region DR setup yet. Build it progressively:

**Level 1: Backup & Restore DR**

- Create an EC2 instance.
- Host a small application.
- Store data in a database.
- Take backups/snapshots.
- Deliberately destroy the server.
- Restore from backup and measure recovery time.

You'll learn:

- Snapshots
- AMIs
- Database backups
- Recovery procedures
- RTO/RPO practically

**Level 2: Infrastructure as Code Recovery**

- Build everything with Terraform.
- Delete the entire infrastructure.
- Recreate it from Git + Terraform.
- Restore data.

This teaches a key lesson: infrastructure is disposable, data is not.

**Level 3: Multi-AZ Resilience**

- Load Balancer
- Auto Scaling Group
- Multi-AZ database

Now test:

- Stop an instance.
- Kill an instance.
- Simulate an AZ failure.

**Level 4: Cross-Region DR**

- Primary region: Mumbai (ap-south-1)
- DR region: Hyderabad (ap-south-2) or another region
- Database replication
- S3 cross-region replication
- Route 53 failover

Test:

- Shut down the primary environment.
- Switch traffic to DR.

**Level 5: Chaos Testing**  
Start breaking things intentionally:

- Revoke IAM permissions
- Fill disk space
- Stop databases
- Kill instances
- Break security groups
- Expire certificates

This is where SRE-style thinking develops.

For your long-term goal of becoming a systems-minded DevOps/SRE engineer, a DR project is stronger on a resume than another Terraform tutorial. It demonstrates architecture, reliability, recovery, automation, and operational thinking.

When you're ready, a solid portfolio project would be:

```
Terraform    +3-tier application    +RDS backups    +Cross-region S3 replication    +Route53 failover    +Runbook    +DR test report
```

Very few candidates actually perform and document a DR drill. The drill report itself becomes valuable evidence of engineering maturity.