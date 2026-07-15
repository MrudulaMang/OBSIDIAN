**NodePort = expose an application outside the cluster using `Node IP + Port`.**

It is commonly useful for **testing, labs, development, or environments where an external load balancer isn't available**. For normal production internet traffic, `LoadBalancer` or `Ingress` is usually preferred.

              Outside the Kubernetes Cluster
                         │
                         │  NodeIP:30080
                         ▼
┌─────────────────────────────────────────────────┐
│              Kubernetes Cluster                 │
│                                                 │
│   Worker Node 1              Worker Node 2      │
│   10.0.1.10                  10.0.1.20          │
│                                                 │
│   :30080                     :30080              │
│      │                          │                │
│      └──────────┬───────────────┘                │
│                 ▼                               │
│          NodePort Service                       │
│          nodePort: 30080                        │
│          port: 80                               │
│                 │                               │
│          ┌──────┴──────┐                        │
│          ▼             ▼                        │
│       Pod A          Pod B                      │
│       :8080          :8080                      │
└─────────────────────────────────────────────────┘
You can access the application using **any node's IP**:

```
http://10.0.1.10:30080
```

or:

```
http://10.0.1.20:30080
```
Kubernetes forwards the request to one of the matching Pods.

### Simple use case: testing an application

You deploy an application in Kubernetes and want to access it from your laptop, but you **don't want to create a LoadBalancer**.

```
Your Laptop
    │
    │ http://<Node-IP>:30080
    ▼
Worker Node :30080
    │
    ▼
NodePort Service
    │
    ▼
Application Pod
```