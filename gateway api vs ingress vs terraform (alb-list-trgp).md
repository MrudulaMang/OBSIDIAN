Most teams don't choose their traffic routing layer.

They inherit it. And three years later, they're paying the complexity tax on a decision they never made.

After debugging enough production incidents across all three models, here's what I've actually learned:

Ingress

Deceptively simple until it isn't. Annotations compound silently. One day you have 40 of them on a single resource and nobody can explain half of them. The real problem: it fails quietly. No structural error — just wrong behavior at 2am.

Gateway API

This isn't a v2 of Ingress. It's a different mental model — infrastructure owners control Gateways, teams own HTTPRoutes. The separation sounds like overhead until you operate Kubernetes at scale across multiple teams. Then it's the thing you wish you'd had from day one.

Terraform-managed load balancers

Maximum control. Maximum operational surface. State drift, missed target registrations, and slow apply cycles make this a liability if your team isn't disciplined. I've seen a single stale state file cause a 45-minute outage on a "working" cluster.

The cost trap nobody budgets for:

10 services × 10 ALBs = a bill that grows faster than your traffic. One shared ALB with proper routing rules often handles the same load at 1/5th the cost. This isn't a Kubernetes problem — it's an architecture review problem.

The failure modes tell the real story:

→ Ingress fails silently — hard to catch, expensive to debug

→ Gateway API fails structurally — louder, but catchable with good policy

→ Terraform fails operationally — human process failures, not code failures

The question I ask teams now isn't "which is better."

It's: where do you want your complexity to live — and who owns it when things go wrong?

Because complexity doesn't disappear. It just moves. You either design for where it lands, or you find out in an incident.

What's your stack using today — and what's the failure you still think about?

#Kubernetes#Platform Engineering#DevOps#CloudArchitecture#SRE