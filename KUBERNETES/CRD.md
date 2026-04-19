what is CRD

**CRD = Custom Resource Definition**

It's a Kubernetes mechanism that lets you extend the K8s API with your own resource types — beyond the built-in ones like `Pod`, `Deployment`, `Service`.

Normally K8s only knows about its native objects. A CRD lets you register a brand new "kind" into the cluster, and then `kubectl` + the API server treat it like a first-class resource.

**Concrete example — K8s Gateway API:**

Without CRDs, K8s has no idea what an `HTTPRoute` is. When you install the Gateway API CRDs, you're essentially teaching the cluster a new vocabulary:

bash

```bash
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/.../standard-install.yaml
```

After that, this becomes valid:

yaml

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute          # <-- this "kind" only exists because of the CRD
metadata:
  name: my-route
spec:
  parentRefs:
    - name: my-gateway
  rules:
    - matches:
        - path:
            value: /api
      backendRefs:
        - name: my-service
          port: 80
```

**The three parts of a CRD in practice:**

- **The CRD itself** — registered once in the cluster, defines the schema (`HTTPRoute`, `Gateway`, `GatewayClass`)
- **A controller** — watches for those custom resources and acts on them (AWS LBC is the controller here — it sees your `HTTPRoute` and provisions the ALB)
- **The custom resource instance** — what you actually write in your manifests (the `HTTPRoute` above)

Think of it this way: CRD is the _noun definition_, the controller is the _verb that acts on it_, and your manifest is the _sentence_.

This is how almost every major K8s ecosystem tool works — Istio, ArgoCD, Cert-manager, Crossplane — they all ship CRDs to extend the cluster with their own concepts.