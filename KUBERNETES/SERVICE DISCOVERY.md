![[{CF6E3221-35C4-42E4-9D95-CA70A972598B}.png]]

Think of Kubernetes Service Discovery as a **phone directory**.

Your application knows only the **service name** (`nginx-svc`), not the Pod IPs. Kubernetes figures out the rest.

### Step 1: Application makes a request

Inside a pod:

```
curl nginx-svc
```

The application doesn't know:

```
10.244.1.1010.244.1.1110.244.1.12
```

It only knows:

```
nginx-svc
```

---

### Step 2: Linux checks `/etc/resolv.conf`

Inside every pod:

```
cat /etc/resolv.conf
```

Example:

```
nameserver 10.96.0.10
search default.svc.cluster.local svc.cluster.local cluster.local
options ndots:5
```

This tells the pod:

> "For DNS queries, ask CoreDNS at 10.96.0.10"

---

### Step 3: What does `ndots:5` do?

You typed:

```
curl nginx-svc
```

That name has **0 dots**.

Since:

```
0 < 5
```

Kubernetes assumes it is a short name and tries:

```
nginx-svc.default.svc.cluster.local
```

instead of immediately searching the internet.

---

### Step 4: CoreDNS receives the query

The pod asks:

```
Who is nginx-svc.default.svc.cluster.local?
```

CoreDNS checks Kubernetes API.

CoreDNS finds:

```
Service:  nginx-svc
```

and returns:

```
10.96.100.25
```

This is the Service IP (ClusterIP).

---

### Step 5: Request goes to Service IP

Now traffic becomes:

```
Pod  |  v10.96.100.25
```

But remember:

```
10.96.100.25
```

is not a real application.

It is a **virtual IP**.

---

### Step 6: kube-proxy takes over

Every node runs:

```
kube-proxy
```

kube-proxy watches:

```
Services
Endpoints
EndpointSlices
```

and programs:

```
iptables
or
IPVS
```

rules.

When traffic reaches:

```
10.96.100.25
```

kube-proxy says:

> "This service has 3 backend pods."

```
10.244.1.1010.244.1.1110.244.1.12
```

---

### Step 7: Endpoint / EndpointSlice

Kubernetes stores backend pod IPs.

Older method:

```
kubectl get ep
```

Example:

```
nginx-svc  10.244.1.10  10.244.1.11  10.244.1.12
```

Modern method:

```
kubectl get endpointslices
```

Same information, but more scalable.

---

### Step 8: One pod gets selected

kube-proxy load balances:

```
10.244.1.1010.244.1.1110.244.1.12
```

Maybe Pod 2 is selected:

```
10.244.1.11
```

Request goes there.

---

### Step 9: Pod responds

```
Application Pod      |      vResponse      |      vClient Pod
```

Response reaches the calling application.

---

### The entire flow in one line

```
Application   |curl nginx-svc   |   v/etc/resolv.conf   |   vCoreDNS   |   vService ClusterIP   |   vkube-proxy   |   vEndpoint/EndpointSlice   |   vPod IP   |   vResponse
```

### Real-world analogy

Imagine you call:

```
"Customer Support"
```

You don't know which employee will answer.

1. DNS = Phone directory
2. CoreDNS = Operator looking up the number
3. Service = Customer support phone number
4. kube-proxy = Call routing system
5. EndpointSlice = List of available agents
6. Pod = Actual employee answering the call

You dial:

```
nginx-svc
```

but the request always ends up at a real Pod IP.

That is Kubernetes Service Discovery.