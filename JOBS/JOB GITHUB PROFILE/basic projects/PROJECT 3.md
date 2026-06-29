# ⎈ Kubernetes Production Setup

> Production-grade Kubernetes configuration with zero-downtime deployments, autoscaling, ingress routing, and a full Prometheus + Grafana monitoring stack.

## 🏗️ What's Included

- ✅ Namespace isolation per environment
- ✅ Horizontal Pod Autoscaler (HPA)
- ✅ Pod Disruption Budgets (zero-downtime)
- ✅ Nginx Ingress + TLS (cert-manager)
- ✅ Prometheus + Grafana monitoring
- ✅ Resource limits & requests on all pods
- ✅ Liveness & readiness probes
- ✅ RBAC roles per team

## 📁 Repo Structure

```
k8s-production-setup/
├── namespaces/
├── deployments/
│   ├── app-deployment.yaml
│   ├── hpa.yaml
│   └── pdb.yaml
├── services/
├── ingress/
├── monitoring/
│   ├── prometheus/
│   └── grafana/
├── rbac/
└── helm/
```

## 🔑 Key Snippet — Zero Downtime Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0      # never kill a pod before new one is ready
      maxSurge: 1
  template:
    spec:
      containers:
      - name: myapp
        image: myapp:latest
        resources:
          requests:
            cpu: "250m"
            memory: "256Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
```

## 🚀 How to Run

```bash
kubectl apply -f namespaces/
kubectl apply -f deployments/
helm install prometheus monitoring/prometheus/
helm install grafana monitoring/grafana/
```