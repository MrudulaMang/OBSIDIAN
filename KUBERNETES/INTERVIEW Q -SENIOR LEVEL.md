For a **Senior DevOps Engineer (4–8 years)**, Kubernetes questions are rarely "What is a Pod?" Instead, interviewers test how you think through production issues, design decisions, and operational tradeoffs.

Here are questions grouped by topic.

## Cluster Architecture

1. Explain the lifecycle of a Pod from `kubectl apply` until it becomes Running.
2. What happens inside the control plane when a Deployment is created?
3. Explain the roles of:
    - kube-apiserver
    - etcd
    - scheduler
    - controller-manager
    - kubelet
4. How does kubelet communicate with the API server?
5. Why is etcd considered the heart of Kubernetes?
6. What happens if the scheduler goes down?
7. Can existing applications continue running if the API server becomes unavailable?

---

## Scheduling

1. A Pod is stuck in Pending. How would you troubleshoot?
2. Explain:
    - Node Selector
    - Node Affinity
    - Pod Affinity
    - Pod Anti-Affinity
3. Difference between:
    - Taints
    - Tolerations
4. How would you dedicate GPU nodes only for ML workloads?
5. How do Priority Classes work?
6. What is Preemption?

---

## Networking

1. Explain Kubernetes networking from browser to Pod.
2. Difference between:
    - ClusterIP
    - NodePort
    - LoadBalancer
3. Why does Kubernetes need CNI?
4. Explain how Calico works.
5. Difference between:
    - Ingress
    - Gateway API
6. How does kube-proxy work?
7. Difference between iptables and IPVS mode.
8. What happens if kube-proxy stops?

---

## Services & DNS

1. Explain Service Discovery.
2. How does CoreDNS work?
3. How does a Service know which Pods belong to it?
4. What are EndpointSlices?
5. Why doesn't a Service use Pod IPs directly?

---

## Deployments

1. Difference between:
    - Deployment
    - ReplicaSet
    - StatefulSet
    - DaemonSet
    - Job
    - CronJob
2. Explain Rolling Update.
3. Explain Recreate strategy.
4. How do you perform Zero Downtime Deployments?
5. Explain:
    - maxUnavailable
    - maxSurge

---

## Storage

1. Difference between:
    - PV
    - PVC
    - StorageClass
2. Explain dynamic provisioning.
3. How does EBS CSI Driver work?
4. Can one EBS volume be mounted on multiple nodes?
5. Difference between:
    - EBS
    - EFS
6. What happens when a Pod using PVC moves to another node?

---

## Security

1. What is RBAC?
2. Difference between:
    - Role
    - ClusterRole
3. Difference between:
    - RoleBinding
    - ClusterRoleBinding
4. What is ServiceAccount?
5. Explain IRSA in EKS.
6. Why shouldn't applications use AWS Access Keys?
7. Explain Network Policies.
8. Explain Pod Security Admission.

---

## Scaling

1. Explain HPA.
2. Explain VPA.
3. Explain Cluster Autoscaler.
4. Difference between:
    - HPA
    - Cluster Autoscaler
5. Why can HPA fail to scale?

---

## Production Troubleshooting

1. Pod is in CrashLoopBackOff. Walk me through your troubleshooting.
2. ImagePullBackOff.
3. OOMKilled.
4. ContainerCreating forever.
5. Node NotReady.
6. Pod keeps restarting.
7. One Pod is slow while others are healthy.
8. A Deployment shows all replicas ready, but users still see 503 errors.

---

## Resource Management

1. Difference between:
    - Requests
    - Limits
2. Explain CPU throttling.
3. Explain QoS Classes:
    - Guaranteed
    - Burstable
    - BestEffort
4. Why does a container get OOMKilled?
5. What happens when memory limit is exceeded?

---

## Observability

1. How do you monitor Kubernetes?
2. Explain:
    - Prometheus
    - Grafana
3. Difference between:
    - Metrics
    - Logs
    - Traces
4. How do you debug memory leaks?
5. How do you monitor API Server latency?

---

## EKS Specific

1. Difference between Managed Node Groups and Self-managed Nodes.
2. Explain IRSA.
3. How does AWS Load Balancer Controller work?
4. Difference between ALB and NLB.
5. Explain EKS authentication.
6. How do worker nodes join the cluster?
7. Explain aws-auth ConfigMap (or Access Entries in newer EKS versions).

---

## Helm

1. Why use Helm instead of plain YAML?
2. Explain Helm values.yaml.
3. What are Helm hooks?
4. Difference between:
    - install
    - upgrade
    - rollback

---

## CI/CD

1. How do you deploy to Kubernetes using GitHub Actions?
2. How do you implement GitOps?
3. Explain Argo CD.
4. How do you rollback a failed deployment?
5. Blue-Green vs Canary Deployment.

---

## Scenario-Based (Very Common)

1. One node suddenly goes down. What happens?
2. etcd becomes corrupted. How do you recover?
3. One Availability Zone fails in EKS.
4. A production deployment is causing latency. How do you isolate the issue?
5. A deployment succeeded, but the application is unreachable.
6. Kubernetes is scheduling Pods on the wrong nodes.
7. Users report intermittent failures. How do you troubleshoot?
8. One namespace is consuming 90% of the cluster CPU.
9. Cluster Autoscaler isn't adding nodes even though Pods are Pending.
10. An application needs zero downtime during upgrades. How would you design the deployment?

These are the types of questions that distinguish senior candidates because they require reasoning about system behavior rather than recalling definitions.

For your target Senior DevOps roles, I would focus especially on the scenario-based questions. Those are the ones most frequently used in managerial and technical rounds because they reveal how you diagnose and resolve production issues.