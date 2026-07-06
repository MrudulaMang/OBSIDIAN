They're saying

> "We expect Platform Engineers to also be Software Engineers."

At Monzo, Platform Engineers don't just write Terraform.

They build internal products.

Examples:

- Internal Kubernetes operators
- APIs
- Controllers
- Platform services
- Automation services
- CLI tools

That's software engineering.

---

### Biggest gap #1 — Go

They specifically mention

> We build services in Go.

Your resume currently has almost no Go.

That doesn't mean they won't interview you.

But during interviews they'll probably ask

> Tell me about software you've built.

Today your strongest stories are infrastructure stories.

---

### Biggest gap #2 — Backend Development

Look at these bullets.

> Designing backend services

> APIs

> Controllers

> Platform software

These are software engineering tasks.

Your resume focuses much more on

- infrastructure
- deployments
- pipelines

than

- backend software.

---

### Biggest gap #3 — Distributed Systems

Monzo is famous for asking questions like

"What happens if..."

Examples:

- etcd becomes unavailable
- kube-apiserver dies
- Envoy stops routing
- DNS cache expires
- ALB health checks fail
- one AZ disappears
- pod receives SIGTERM
- gRPC timeout occurs
- leader election fails
- packet loss between services

Notice these aren't Kubernetes trivia.

They're about understanding distributed systems.

---

### Biggest gap #4 — System Design

Final interview includes

> System Design

Not

"Design Netflix"

Instead they'll ask things like

Design:

- Secret management platform
- Internal deployment platform
- Log aggregation platform
- Platform for hundreds of services
- Kubernetes multi-cluster platform

You need strong architecture thinking.