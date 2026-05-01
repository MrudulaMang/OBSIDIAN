architecture diagram of ingress in eks cluster exposing the app, want a detailed one

2:25 PM

Here's the full traffic flow from top to bottom:

**Ingress path** — a client hits `app.example.com`, Route 53 resolves it to the ALB's DNS. The ALB (provisioned automatically by the AWS Load Balancer Controller watching your `Ingress` resource) terminates TLS using an ACM certificate, then forwards HTTP traffic into the cluster. An optional WAF attachment blocks malicious traffic before it reaches your pods.

**Inside the cluster** — the Ingress Controller reads your `Ingress` resource rules (`/api` → `api-svc`, `/` → `frontend-svc`) and configures routing accordingly. Services use `ClusterIP` to load-balance across pods spread across two AZs for high availability.

**Supporting objects** — ConfigMaps and Secrets mount env config and credentials into pods. An HPA scales the deployment based on CPU or custom metrics. PVCs backed by EBS gp3 handle persistent storage needs.

**Downstream** — api pods connect to RDS (database) and ElastiCache (Redis), while a Fluent Bit DaemonSet (or CloudWatch agent) ships logs and metrics to CloudWatch.