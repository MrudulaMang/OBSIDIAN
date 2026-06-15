1. "Your API latency jumped from 50ms to 5 seconds at 2 AM. Walk me through your 
investigation."
2. **Production-focused candidate**

> During a Terraform deployment I noticed a plan showing replacement of production resources. Before applying, I evaluated the blast radius, inspected state consistency, checked for drift, and verified whether a provider upgrade had changed behavior. We avoided a destructive replacement by importing the resource and reconciling state.

Notice what happened?

The second answer immediately creates discussion around:

- Risk management
- Change control
- Recovery planning
- Production safety

That's senior-level territory.

CHATGPT--------------------------------------------
If your goal is becoming a production-grade engineer, don't organize questions by tool. Organize them by how systems fail.

# Level 1 — Detection & Troubleshooting (1–20)

1. Website is slow. What do you check first?
2. CPU is at 100%. How do you investigate?
3. Memory usage keeps growing. What are your next steps?
4. Disk reaches 100%. How do you identify the culprit?
5. Users report intermittent application failures. Where do you start?
6. Service is listening but users cannot connect. Why?
7. Application suddenly stopped writing logs.
8. Load average is high but CPU utilization is low.
9. EC2 instance is reachable but application is not.
10. Application responds slowly only during peak hours.
11. Kubernetes pod keeps restarting.
12. Pod is stuck in Pending state.
13. Pod is Running but application is unavailable.
14. DNS resolution fails inside Kubernetes.
15. Jenkins job suddenly starts failing.
16. Docker container exits immediately after startup.
17. Terraform apply hangs indefinitely.
18. RDS CPU spikes unexpectedly.
19. ALB reports unhealthy targets.
20. CloudWatch alarm triggers every few minutes.

---

# Level 2 — Linux & Infrastructure Failures (21–40)

21. Server suddenly reboots every night.
22. OOM Killer terminates application processes.
23. One process consumes all file descriptors.
24. System reports "No space left on device" but disk appears free.
25. SSH access suddenly stops working.
26. NFS mount becomes unresponsive.
27. High I/O wait impacts performance.
28. Thousands of zombie processes appear.
29. Cron jobs stop executing.
30. Time synchronization drifts significantly.
31. Network throughput drops by 80%.
32. TLS handshake failures start appearing.
33. One node in a cluster behaves differently than others.
34. Packet loss occurs only between specific hosts.
35. Kernel upgrade causes application instability.
36. Docker daemon becomes unresponsive.
37. Container networking stops functioning.
38. Systemd service keeps restarting.
39. Application works locally but fails on server.
40. Rolling restart causes complete outage.

---

# Level 3 — AWS Production Scenarios (41–60)

41. EC2 cannot access S3 despite IAM permissions.
42. Application loses database connectivity.
43. Auto Scaling launches instances but traffic doesn't reach them.
44. NAT Gateway costs suddenly triple.
45. ALB returns 502 errors.
46. Route table misconfiguration causes outage.
47. Security group change impacts production.
48. Public subnet instance loses internet access.
49. CloudTrail logs show unusual API activity.
50. RDS storage approaches full capacity.
51. Multi-AZ failover occurs unexpectedly.
52. Lambda experiences throttling.
53. API Gateway latency doubles overnight.
54. EBS volume performance degrades.
55. S3 bucket accidentally becomes public.
56. Secrets Manager secret rotation fails.
57. Cross-account access stops working.
58. Transit Gateway routing issue impacts connectivity.
59. CloudFormation stack update fails midway.
60. Regional AWS outage impacts service.

---

# Level 4 — Terraform Production Engineering (61–70)

61. Terraform plan wants to recreate production resources.
62. State file becomes corrupted.
63. Terraform state lock never releases.
64. Team accidentally modifies infrastructure manually.
65. Provider upgrade changes resource behavior.
66. Resource import is required for production.
67. Multiple teams manage overlapping resources.
68. Sensitive data appears in Terraform state.
69. Apply succeeds partially and fails midway.
70. Production rollback is required after Terraform deployment.

---

# Level 5 — Kubernetes Production Engineering (71–85)

71. CrashLoopBackOff occurs across multiple pods.
72. OOMKilled appears after deployment.
73. Node enters NotReady state.
74. Cluster DNS outage occurs.
75. Kubernetes API server becomes unavailable.
76. etcd disk fills up.
77. Ingress stops routing traffic.
78. Network policy blocks communication.
79. Persistent volume fails to mount.
80. Deployment rollout gets stuck.
81. HPA scales unexpectedly.
82. Cluster autoscaler fails to add nodes.
83. Pod scheduling fails despite available nodes.
84. Service mesh introduces latency.
85. Entire node pool disappears unexpectedly.

---

# Level 6 — CI/CD & Release Engineering (86–92)

86. Deployment succeeds but application breaks.
87. Jenkins controller crashes during release.
88. Artifact repository becomes unavailable.
89. Rollback introduces additional failures.
90. Blue-Green deployment causes data inconsistency.
91. Canary deployment metrics show degradation.
92. GitHub Actions pipeline exposes secrets.

---

# Level 7 — DevSecOps & Security Incidents (93–100)

93. AWS access key is committed to GitHub.
94. Developer receives AdministratorAccess in production.
95. Container image contains critical vulnerabilities.
96. Supply-chain attack affects a dependency.
97. Production secret appears in logs.
98. Ransomware encrypts a Kubernetes worker node.
99. CloudTrail shows suspicious privilege escalation.
100. You suspect a production breach. What are your first 10 actions?

---

Now for the uncomfortable part.

Most candidates can answer questions 1–40.

Good engineers can answer 41–70.

Senior engineers can answer 71–90.

The engineers who get trusted with critical systems are the ones who can handle 91–100 while also explaining:

```
ImpactDetectionBlast RadiusRiskMitigationRoot CausePreventionBusiness Tradeoff
```

for every scenario.

If you can thoroughly answer all 100, with investigation steps and decision-making rationale rather than tool commands, you will be operating at a level that resembles senior SRE/platform/reliability interviews much more than typical DevOps interview preparation.


---------------------------------------





