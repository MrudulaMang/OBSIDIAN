|Layer|What it tests|Command|
|---|---|---|
|L3 — Network|Pod-to-pod reachability (ICMP)|`kubectl exec -it <pod> -- ping <target-pod-ip>`|
|L4 — TCP|Is the port open on a pod?|`kubectl exec -it <pod> -- nc -zv <target-pod-ip> <port>`|
|L4 — UDP|UDP port check|`kubectl exec -it <pod> -- nc -zvu <target-pod-ip> <port>`|
|L7 — DNS|Service name resolution|`kubectl exec -it <pod> -- nslookup <service-name>`|
|L7 — DNS (full)|FQDN resolution|`kubectl exec -it <pod> -- nslookup <svc>.<namespace>.svc.cluster.local`|
|L7 — HTTP|Service responding?|`kubectl exec -it <pod> -- curl -v http://<service-name>:<port>`|
|L7 — App health|Returns 200?|`kubectl exec -it <pod> -- curl -o /dev/null -sw "%{http_code}" http://<svc>:<port>/health`|
|K8s — Service|Endpoints registered?|`kubectl get endpoints <service-name>`|
|K8s — DNS config|CoreDNS running?|`kubectl get pods -n kube-system -l k8s-app=kube-dns`|
|K8s — Network Policy|Traffic blocked by policy?|`kubectl get networkpolicy -n <namespace>`|

**Debugging order in K8s:**

```
1. kubectl get endpoints      → are pods actually behind the service?
2. ping <pod-ip>              → basic pod-to-pod reachability
3. nslookup <service-name>    → DNS resolving correctly?
4. nc -zv <svc> <port>        → TCP port reachable?
5. curl -v http://<svc>:<port>→ app responding?
6. get networkpolicy          → anything blocking traffic?
```

**Key difference vs Docker:**

- Docker uses container names for DNS
- K8s uses `<service>.<namespace>.svc.cluster.local` — if cross-namespace, always use the FQDN

Want this folded into a LinkedIn post alongside the Docker one — like a "Docker vs K8s networking debug" comparison post?