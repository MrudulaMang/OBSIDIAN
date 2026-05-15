


━━━━━━━━━━━━━━━━━━━━━━
🧠 CONTROL PLANE — The brain
━━━━━━━━━━━━━━━━━━━━━━

⚙️ kube-apiserver
Every single interaction with your cluster goes through here. kubectl apply, Helm installs, ArgoCD syncs — all of it hits the API server first. It's the only component that talks to etcd directly. Scale it horizontally in production — never run a single instance.

🗄️ etcd
This is your entire cluster's memory. Every pod, secret, configmap, node status — stored here as key-value pairs. If etcd dies without a backup, your cluster is gone. Not degraded. Gone.

Backup command you should have in your muscle memory:
etcdctl snapshot save /backup/etcd-snapshot.db

📅 kube-scheduler
Doesn't run your pods. Just decides WHERE they run. It evaluates every node against resource requests, taints, tolerations, affinity rules, and topology constraints — then assigns the best fit. Most engineers treat it as a black box. Don't.

🔄 kube-controller-manager
A single binary running multiple control loops in the background — node controller, replication controller, endpoints controller, serviceaccount controller. Its only job: make sure actual state matches desired state. Forever.

━━━━━━━━━━━━━━━━━━━━━━
🔧 WORKER NODE — Where workloads live
━━━━━━━━━━━━━━━━━━━━━━

🤖 kubelet
The agent on every node. Reads PodSpecs, talks to the container runtime, and reports back to the control plane. When a pod is stuck — this is the first place I check. Not the pod. The kubelet.

🌐 kube-proxy
Maintains iptables/ipvs rules on every node to make Services work. Worth noting: if you're running Cilium or some CNI plugins, kube-proxy is replaced entirely. It's optional — not mandatory.

📦 Container Runtime
The layer that actually pulls images and runs containers. containerd is the standard now. Docker was removed as a supported runtime in K8s 1.24. If you're still using dockershim anywhere in production — fix that.

━━━━━━━━━━━━━━━━━━━━━━
📌 Ports worth memorising
━━━━━━━━━━━━━━━━━━━━━━

• kube-apiserver → 6443
• etcd → 2379–2380
• kubelet → 10250
• kube-scheduler → 10259
• kube-controller-manager → 10257

These matter the moment you're hardening firewall rules or debugging cluster connectivity in production.

━━━━━━━━━━━━━━━━━━━━━━

Understanding internals is what separates engineers who manage Kubernetes from engineers who truly operate it.

Anyone can apply a YAML. Not everyone can tell you why a node went NotReady at 2am.

Save this for reference. Share it with your team.

#Kubernetes #DevOps #PlatformEngineering #CloudNative #K8s #SRE #DevOpsEngineer #CNCF #CloudInfrastructure