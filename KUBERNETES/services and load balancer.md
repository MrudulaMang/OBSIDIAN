  

if i create multiple services with type lb, will aws create multiple lb's
  
Yes — in most standard Kubernetes setups on AWS (like Amazon EKS or self-managed K8s on AWS cloud), **each Service of type `LoadBalancer` usually creates its own separate AWS Load Balancer**.

to remove alb created in aws, just change servie type to NODEPORT instead of LOAD BALANCER

### Example

If you create:

- `service-a` → `type: LoadBalancer`
    
- `service-b` → `type: LoadBalancer`
    
- `service-c` → `type: LoadBalancer`
    

AWS will usually create:

- LB-1 for service-a
    
- LB-2 for service-b
    
- LB-3 for service-c
    

So yes, **multiple services = multiple LBs** (unless using a different ingress pattern).

---

### Why?

Because Kubernetes `Service type=LoadBalancer` means:

> “Cloud provider, please provision an external load balancer for this service.”

AWS interprets that as a dedicated LB resource.

That means:

- separate DNS name
    
- separate target groups
    
- separate listeners
    
- separate cost
    

---

### Better Production Pattern

Instead of many `LoadBalancer` services, people often use:

### One Ingress Controller + One ALB

Example:

- install AWS Load Balancer Controller
    
- create one Application Load Balancer
    
- route multiple apps using Ingress rules
    

Like:

```
app.company.com → service-aapi.company.com → service-badmin.company.com → service-c
```

This saves:

- cost
    
- IP usage
    
- operational complexity
    

---

### Simple Interview Line

> “If I create multiple Kubernetes Services with type LoadBalancer on AWS, AWS usually provisions multiple separate load balancers. In production, we often prefer Ingress + ALB to reduce cost and centralize routing.”

That sounds much stronger than just saying “yes.”