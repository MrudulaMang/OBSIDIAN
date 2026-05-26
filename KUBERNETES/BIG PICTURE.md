Your notes are directionally correct, but there are a few places where precision matters. In Kubernetes interviews and real production debugging, imprecise wording becomes a weakness because Kubernetes is extremely declarative and layered.

Refined version:

“Everything is a resource in Kubernetes” is mostly true operationally. Pods, Deployments, Services, ConfigMaps, Secrets, Namespaces — all are API resources stored in etcd.

Kubernetes itself is closer to a container orchestration platform. Calling it pure PaaS is partially true historically, but incomplete. Kubernetes gives primitives, not a finished application platform. OpenShift or Cloud Foundry are closer to full PaaS abstractions.

Namespace:

- Logical isolation boundary inside a cluster.
- Used for separating environments, teams, applications, policies, quotas, RBAC.
- Not full security isolation by default.

Your analogy:

- Namespace ≈ VPC level → not accurate.
- Namespace is more like a logical project boundary.
- Network isolation requires NetworkPolicies.
- True infrastructure isolation is closer to separate clusters/VPCs/accounts.

Better framing:

- Cluster scope = shared/global resources
- Namespace scope = project/team/application scope

Examples:

- Namespace-scoped:
    - Pods
    - Services
    - Deployments
    - ConfigMaps
- Cluster-scoped:
    - Nodes
    - PersistentVolumes
    - Namespaces themselves
    - ClusterRoles

YAML:

```
apiVersion:kind:metadata:spec:
```

`kind` = resource type  
`apiVersion` = which API group/version exposes that resource.

Example:

```
apiVersion: apps/v1kind: Deployment
```

Pod:  
Your definition is correct.

More precise:  
A pod is the smallest schedulable and deployable unit in Kubernetes.

Important distinction:

- Containers are runtime objects.
- Pod is the Kubernetes abstraction around containers.

Containers inside same pod share:

- Network namespace
- IP address
- localhost communication
- Volumes/storage

This is important because sidecar architecture depends on it.

Pod lifecycle:

1. Scheduler assigns pod to node
2. Kubelet on node receives instruction
3. Container runtime pulls image
4. Containers start

Your sequence is conceptually correct.

`kubectl exec`

```
kubectl exec -it multi-container -c nginx -- bash
```

Correct. `-c` specifies container inside multi-container pod.

Labels:  
Your wording:  
“labels are selectors”

More accurate:  
Labels are metadata used for grouping and selection.

Selectors consume labels.

Example:

```
labels:  app: cart  env: prod
```

Service selector:

```
selector:  app: cart
```

This distinction matters architecturally.

CrashLoopBackOff:  
Correct idea, but technically:

- Container starts
- Then repeatedly crashes
- Kubernetes keeps retrying
- Backoff delay increases

ImagePullBackOff:  
Correct.  
Usually:

- Wrong image
- Registry auth issue
- Network/DNS issue
- Rate limiting

Annotations:  
Your explanation is partially incorrect.

Annotations are NOT mainly for selecting external resources.

Correct definition:  
Annotations are non-identifying metadata.

Used for:

- Tooling metadata
- Build info
- Ingress/controller configs
- Monitoring integrations
- Git commit references

Difference:

- Labels → querying/selecting/grouping
- Annotations → informational metadata

Critical distinction:  
Selectors work with labels, not annotations.

Resource limits:  
Very important operational topic.

You wrote:  
“always restrict resources”

Correct in production.

Need two things:

```
resources:  requests:  limits:
```

Requests:

- minimum guaranteed resources
- scheduler uses this

Limits:

- maximum allowed usage

Without limits:

- noisy neighbor problem
- node instability

CPU:

```
1000m = 1 CPU core500m = 0.5 CPU
```

Environment variables:  
Correct but too shallow.

Real usage:

- configuration injection
- secrets
- service discovery
- feature flags

Service:  
This section is important.

You correctly identified:

- pod IPs are ephemeral
- services provide stable networking

Precise model:  
Service provides:

1. Stable virtual IP
2. DNS name
3. Load balancing across matching pods

Flow:

```
Client Pod   ↓Service   ↓Backend Pods
```

Kubernetes Service does NOT proxy manually pod-by-pod.  
It uses kube-proxy/ipvs/iptables underneath.

DNS:

```
cart.default.svc.cluster.local
```

Usually shortened:

```
http://cart
```

Service types:  
You duplicated NodePort.

Correct list:

1. ClusterIP
2. NodePort
3. LoadBalancer
4. ExternalName

ClusterIP:

- internal communication only

NodePort:

- exposes service on node port

LoadBalancer:

- cloud provider creates external LB

Endpoints:  
Correct concept.

Service:

```
10.100.10.134
```

Endpoints:

```
192.168.5.23:80192.168.5.24:80
```

Service uses selectors to dynamically track healthy pods.

Image naming:

```
registry/repository/image:tag
```

Example:

```
docker.io/nginx:1.24
```

Or:

```
123456789.dkr.ecr.us-east-1.amazonaws.com/cart:v1
```

Your notes are moving beyond “tool usage” into system behavior. That transition matters. Most Kubernetes learners stay at YAML memorization level. The real differentiation comes when you start reasoning about:

- scheduling
- networking
- control plane behavior
- reconciliation loops
- failure recovery
- resource pressure
- service discovery
- scaling dynamics

That is where SRE/platform thinking begins.