Round 1 – Systems at Scale, K8s, Cloud & Linux  
• How would you implement fine-grained service discovery across 1000+ microservices using Envoy or Istio?  
• Explain how you’d leverage eBPF + Cilium to enforce network security policies at runtime, and what the advantages are over traditional CNIs?  
• Netflix runs multi-cloud. Describe your approach to cross-cloud routing, IAM, and secret syncing.  
• What happens when systemd units fail intermittently on EKS nodes? How do you detect and heal?  
• Your app teams demand custom AMIs. What’s your pre-prod vetting strategy at kernel and runtime?  
• Walk through advanced kube-probe configurations to detect business logic failures, not just HTTP 200.  
• How do you handle DNS-level outages inside a service mesh without a full app redeploy?  
• Terraform remote_state backend suddenly times out. What’s your recovery and damage containment strategy?  
  
Round 2 – RCA, Fire Drills, and [Netflix](https://www.linkedin.com/company/netflix/)-Scale Chaos  
• A new Envoy config rollout silently broke mTLS between edge and mesh. What’s your RCA trace?  
• HPA refuses to scale even though Prometheus shows CPU > 80%. Diagnose with cloud + K8s metrics.  
• You introduced a sidecar-based caching layer. Suddenly, tail latency spikes. What’s your debug path?  
• 504 errors on the playback service. Cloud LB shows healthy, mesh sidecars pass, but users can’t stream. Triage?  
• You notice surging NAT costs. No infra changes this week. What could silently trigger that?  
  
Round 3 – Leadership, Chaos Culture & Engineering Influence  
• How do you build an engineering culture where SLOs are owned, not ignored?  
• You’re asked to ship a multi-region failover in 3 weeks, no DNS layer allowed. Your plan?  
• Describe how you’d test infra chaos and graceful degradation for a Netflix Originals release.  
• How do you prove the ROI of infra modernization to non-technical execs?  
  
💡 TL;DR:  
If you haven’t:  
1. Used eBPF to trace a TCP reset at runtime  
2. Investigated TLS outages across sidecars  
3. Debugged Redis inconsistency under pressure  
4. Simulated a kubelet crash mid-streaming session  
  
Then [Netflix](https://www.linkedin.com/company/netflix/) interviews won’t just test you; they’ll expose the cracks in your production mindset.  
But what if you could train on this before getting grilled?  
  
That’s what [InfraThrone](https://www.linkedin.com/company/infrathrone/) was built for: RCA drills, Fire room simulations, Real infra chaos