Here are the core Kubernetes API objects, grouped by category:

## Workloads

|Object|Purpose|
|---|---|
|**Pod**|Smallest deployable unit; one or more containers|
|**ReplicaSet**|Maintains a stable set of replica Pods|
|**Deployment**|Declarative updates for Pods/ReplicaSets|
|**StatefulSet**|Like Deployment but for stateful apps (stable identity/storage)|
|**DaemonSet**|Runs one Pod per node (e.g. log collectors, monitoring agents)|
|**Job**|Runs a Pod to completion (batch tasks)|
|**CronJob**|Runs Jobs on a schedule|

## Configuration & Storage

|Object|Purpose|
|---|---|
|**ConfigMap**|Non-sensitive key-value config data|
|**Secret**|Sensitive data (passwords, tokens, keys)|
|**PersistentVolume (PV)**|A piece of storage in the cluster|
|**PersistentVolumeClaim (PVC)**|A request for storage by a user|
|**StorageClass**|Defines types/tiers of storage|
|**VolumeAttachment**|Attaches a volume to a node|

## Networking

|Object|Purpose|
|---|---|
|**Service**|Stable network endpoint for a set of Pods|
|**Ingress**|HTTP/HTTPS routing rules to Services|
|**IngressClass**|Specifies which Ingress controller to use|
|**NetworkPolicy**|Firewall rules between Pods|
|**EndpointSlice**|Tracks network endpoints for a Service|
|**Endpoints**|Older form of EndpointSlice|

## Cluster & Namespace

|Object|Purpose|
|---|---|
|**Namespace**|Virtual cluster / logical partition|
|**Node**|A worker machine in the cluster|
|**ResourceQuota**|Limits resource usage per namespace|
|**LimitRange**|Default/min/max resource limits per Pod/container|
|**HorizontalPodAutoscaler (HPA)**|Auto-scales Pods based on CPU/memory/metrics|
|**VerticalPodAutoscaler (VPA)**|Adjusts resource requests/limits automatically|
|**PodDisruptionBudget (PDB)**|Ensures minimum availability during disruptions|
|**PriorityClass**|Assigns scheduling priority to Pods|

## RBAC (Access Control)

|Object|Purpose|
|---|---|
|**ServiceAccount**|Identity for processes running in Pods|
|**Role**|Namespace-scoped permissions|
|**ClusterRole**|Cluster-wide permissions|
|**RoleBinding**|Binds a Role to a user/group/ServiceAccount|
|**ClusterRoleBinding**|Binds a ClusterRole cluster-wide|

## Policy & Admission

|Object|Purpose|
|---|---|
|**ResourceQuota**|Caps total resources in a namespace|
|**PodSecurityPolicy** _(deprecated)_|Controlled Pod security settings|
|**ValidatingWebhookConfiguration**|Validates resources on admission|
|**MutatingWebhookConfiguration**|Mutates resources on admission|

## Extensibility

|Object|Purpose|
|---|---|
|**CustomResourceDefinition (CRD)**|Defines your own custom API objects|
|**APIService**|Extends the Kubernetes API with new groups|
|**MutatingWebhookConfiguration**|Hook into the API server for mutations|

## Metadata / Discovery

| Object           | Purpose                                          |
| ---------------- | ------------------------------------------------ |
| **Event**        | Records of what happened in the cluster          |
| **Lease**        | Used for leader election and node heartbeats     |
| **RuntimeClass** | Configures container runtime (e.g. gVisor, Kata) |

---

**Quick tip:** You can list all available API resources in your cluster (including CRDs) with:

bash

```bash
kubectl api-resources
```