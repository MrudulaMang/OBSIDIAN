**CPU throttling** is the process of **temporarily limiting how much CPU time a process or container can use**, even if it wants to use more.

### Simple analogy

Imagine a highway with a speed limit.

- Your car (application) wants to drive at **120 km/h**.
- The speed limit is **60 km/h**.
- The police force you to slow down.

The car isn't broken—it is being **throttled**.

Similarly, a container may want 100% of a CPU core, but Kubernetes or Docker only allows it to use a configured amount.

### In Docker

If you run:

```
docker run --cpus=0.5 nginx
```

Docker allows the container to use **at most half of one CPU core**.

If the application tries to use more, the Linux kernel pauses it periodically. This is CPU throttling.

### In Kubernetes

Example:

```
resources:  requests:    cpu: "500m"  limits:    cpu: "1"
```

- **Request = 500m** → Kubernetes reserves 0.5 CPU for scheduling.
- **Limit = 1 CPU** → The container can use up to 1 CPU.

If the application tries to use **1.5 CPUs**, it is throttled back to **1 CPU**.

### How does Linux do this?

Docker and Kubernetes use Linux **cgroups** (control groups).

The kernel tracks how much CPU time a container has consumed in a scheduling period. Once the container reaches its quota, it is paused until the next period begins.

For example:

- Scheduling period: 100 ms
- CPU quota: 50 ms

The container can run for 50 ms, then waits the remaining 50 ms before running again.

### Symptoms of CPU throttling

You might observe:

- High application latency
- Slow API responses
- Longer job execution times
- CPU usage appearing capped at the configured limit
- Increased request queues despite available work

### How to detect it

In Kubernetes:

```
kubectl top pod
```

To inspect CPU limits:

```
kubectl describe pod <pod-name>
```

With Prometheus, common metrics include:

- `container_cpu_cfs_throttled_seconds_total`
- `container_cpu_cfs_throttled_periods_total`

A steadily increasing value indicates the container is being throttled.

### CPU throttling vs. CPU starvation

- **CPU throttling**: The kernel deliberately limits CPU usage because of configured CPU limits.
- **CPU starvation**: The process can't get enough CPU because other processes are consuming it or the node is overloaded, even though no explicit limit is enforcing it.

For DevOps interviews, a concise definition is:

> CPU throttling occurs when the Linux kernel, using cgroups, enforces a configured CPU limit by temporarily pausing a container after it has consumed its allotted CPU time for a scheduling period. This prevents the container from exceeding its CPU quota while allowing it to resume in the next scheduling interval.