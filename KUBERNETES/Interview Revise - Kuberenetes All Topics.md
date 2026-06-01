KUBERNETES
│
├── 1. FUNDAMENTALS
│   ├── What is Kubernetes?
│   ├── Container Orchestration
│   ├── Cluster Architecture
│   ├── Control Plane
│   └── Worker Nodes
│
├── 2. CLUSTER COMPONENTS
│   ├── API Server
│   ├── ETCD
│   ├── Scheduler
│   ├── Controller Manager
│   ├── Kubelet
│   ├── Kube Proxy
│   └── Container Runtime
│
├── 3. PODS
│   ├── Pod Lifecycle
│   ├── Multi-container Pods
│   ├── Init Containers
│   ├── Sidecars
│   └── Pod States
│
├── 4. WORKLOADS
│   ├── Deployment
│   ├── ReplicaSet
│   ├── StatefulSet
│   ├── DaemonSet
│   ├── Job
│   └── CronJob
│
├── 5. SERVICES
│   ├── ClusterIP
│   ├── NodePort
│   ├── LoadBalancer
│   ├── Headless Service
│   └── Service Discovery
│
├── 6. INGRESS
│   ├── Ingress
│   ├── Ingress Controller
│   ├── Path Routing
│   ├── Host Routing
│   └── TLS
│
├── 7. NETWORKING
│   ├── CNI
│   ├── Pod Networking
│   ├── Service Networking
│   ├── Network Policies
│   └── DNS
│
├── 8. STORAGE
│   ├── Volumes
│   ├── Persistent Volume
│   ├── Persistent Volume Claim
│   ├── Storage Class
│   └── Dynamic Provisioning
│
├── 9. CONFIGURATION
│   ├── ConfigMaps
│   ├── Secrets
│   ├── Environment Variables
│   └── Mounted Files
│
├── 10. SCHEDULING
│   ├── Labels
│   ├── Selectors
│   ├── Taints
│   ├── Tolerations
│   ├── Affinity
│   └── Anti-Affinity
│
├── 11. SECURITY
│   ├── RBAC
│   ├── Service Accounts
│   ├── Network Policies
│   ├── Pod Security
│   └── Secrets Management
│
├── 12. SCALING
│   ├── HPA
│   ├── VPA
│   ├── Cluster Autoscaler
│   └── Resource Requests/Limits
│
├── 13. OBSERVABILITY
│   ├── Logs
│   ├── Events
│   ├── Metrics
│   ├── Prometheus
│   └── Grafana
│
├── 14. DEPLOYMENTS
│   ├── Rolling Update
│   ├── Recreate
│   ├── Rollback
│   ├── Blue-Green
│   └── Canary
│
└── 15. TROUBLESHOOTING
    ├── kubectl get
    ├── kubectl describe
    ├── kubectl logs
    ├── kubectl exec
    ├── Events
    └── Node Investigation

-----------------------TROUBLESHOOTING
K8S TROUBLESHOOTING
│
├── Pod Pending
│   ├── insufficient CPU
│   ├── insufficient memory
│   ├── taints
│   ├── node selector mismatch
│   └── PVC pending
│
├── Pod CrashLoopBackOff
│   ├── application crash
│   ├── bad config
│   ├── secret missing
│   ├── dependency unavailable
│   └── startup failure
│
├── ImagePullBackOff
│   ├── wrong image
│   ├── registry auth issue
│   ├── image not found
│   └── network issue
│
├── Service Not Reachable
│   ├── selector mismatch
│   ├── endpoint missing
│   ├── wrong port
│   └── pod not ready
│
├── Ingress Not Working
│   ├── controller issue
│   ├── DNS issue
│   ├── TLS issue
│   └── routing rule issue
│
├── DNS Resolution Failure
│   ├── CoreDNS issue
│   ├── network issue
│   └── service lookup issue
│
├── PVC Pending
│   ├── storage class missing
│   ├── PV unavailable
│   └── provisioner failure
│
├── Node Not Ready
│   ├── kubelet issue
│   ├── disk pressure
│   ├── memory pressure
│   └── network issue
│
├── High CPU
│   ├── application issue
│   ├── no limits
│   ├── traffic spike
│   └── scaling issue
│
├── High Memory
│   ├── memory leak
│   ├── no limits
│   ├── cache growth
│   └── OOM kill
│
├── Deployment Stuck
│   ├── readiness probe failure
│   ├── image issue
│   ├── insufficient resources
│   └── scheduling issue
│
└── HPA Not Scaling
    ├── metrics server issue
    ├── requests missing
    ├── thresholds incorrect
    └── metrics unavailable