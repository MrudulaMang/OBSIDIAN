### What CKA will add on top of what you already know

Things YAML writing doesn't cover:

- **kubeadm** — bootstrapping a cluster from scratch
- **etcd backup & restore** — critical for admin role
- **Node troubleshooting** — kubelet failures, node not ready scenarios
- **Cluster upgrades** — upgrading control plane + worker nodes
- **Network troubleshooting** — CNI issues, DNS failures, pod-to-pod connectivity
- **Certificate management** — rotating certs, TLS for API server
- **RBAC deep dive** — ClusterRoles, ServiceAccounts, RoleBindings
- **Persistent Volume troubleshooting** — PVC stuck in pending, etc.

Answer these quickly:
- Can you restore an etcd snapshot?
- Can you fix a broken kubelet on a node?
- Can you bootstrap a cluster with kubeadm from scratch?
- Can you troubleshoot a CrashLoopBackOff at the node level (not just pod level)?
- Can you upgrade a cluster from 1.29 → 1.30?