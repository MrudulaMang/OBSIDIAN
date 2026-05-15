Let's go! 💪

Here's your **90-day CKA battle plan:**

---

### Month 1 — Core Foundations (Days 1–30)

**Week 1–2: Cluster Architecture**

- kubeadm cluster setup from scratch
- Control plane components — API server, etcd, scheduler, controller manager
- Worker node components — kubelet, kube-proxy, container runtime

**Week 3–4: Workloads & Scheduling**

- ReplicaSets, Deployments, DaemonSets, StatefulSets
- Resource limits, taints/tolerations, node affinity
- Manual scheduling, static pods

---

### Month 2 — Networking + Storage (Days 31–60)

**Week 5–6: Networking**

- CNI plugins (Calico, Flannel, Weave)
- Services deep dive — ClusterIP, NodePort, LoadBalancer
- Ingress controllers, DNS troubleshooting
- Network policies

**Week 7–8: Storage + Security**

- PV, PVC, StorageClass
- RBAC — Roles, ClusterRoles, ServiceAccounts
- kubeconfig, contexts, certificates

---

### Month 3 — Admin Skills + Exam Prep (Days 61–90)

**Week 9–10: Cluster Maintenance**

- etcd backup & restore ← most important exam topic
- Cluster upgrades with kubeadm
- Node drain, cordon, uncordon
- Troubleshooting kubelet, API server failures

**Week 11–12: Mock Exams**

- killer.sh (2 free attempts with exam purchase)
- KodeKloud mock exams
- Time yourself — exam is 2 hours, 15–20 questions
- Practice `kubectl` speed — aliases, shortcuts

---

### Most Important Exam Tips

**Set these aliases on exam day — saves huge time:**

bash

```bash
alias k=kubectl
export do="--dry-run=client -o yaml"
export now="--force --grace-period 0"
```

**Most common exam tasks:**

- Create a pod/deployment from scratch
- Fix a broken cluster (kubelet down)
- RBAC — create role and bind it
- etcd backup & restore
- Upgrade cluster version
- Network policy creation
- Persistent volume setup

---

### Best Free & Paid Resources

|Resource|Type|Cost|
|---|---|---|
|[KodeKloud CKA Course](https://kodekloud.com)|Video + Labs|₹2,500/month|
|[Killer.sh](https://killer.sh)|Mock exam|Free with CKA purchase|
|Kubernetes docs (kubernetes.io)|Reference|Free|
|TechWorld with Nana YouTube|Concepts|Free|
|[Play with Kubernetes](https://labs.play-with-k8s.com)|Practice lab|Free|

---

### The Single Most Important Advice

> **Practice on a real cluster every single day — even 30 minutes.** CKA is 100% hands-on. Reading and watching videos alone will fail you. Your fingers need to know the commands faster than your brain thinks.

---

You already have a massive head start knowing YAML deeply. Honestly with focused prep **you can clear CKA in 60 days** not even 90.

Want me to make you a week-by-week detailed schedule with daily tasks?