**cgroups = Control Groups**

------By default, **Docker does not impose most resource limits.**
------Container Limit ≈ Host Limit

**cgroups
They are a Linux kernel feature that controls and limits how much system resources a process can use.

Without cgroups:

```
Process A → Can consume all CPUProcess B → Can consume all MemoryProcess C → Can starve other processes
```

With cgroups:

```
Process A → Max 1 CPUProcess B → Max 512 MB RAMProcess C → Max 20% CPU
```

Docker uses cgroups heavily.

Example:

```
docker run -m 512m nginx
```

Docker tells the kernel:

```
Create a cgroupMemory limit = 512 MBPut nginx process inside that cgroup
```

Now if nginx tries to use:

```
600 MB RAM
```

the kernel intervenes.

---

Think of namespaces and cgroups as two different things:

### Namespaces = Isolation

```
Container A cannot see Container B's processes.Container A has its own network view.Container A has its own hostname.
```

### cgroups = Resource Control

```
Container A gets 1 CPUContainer A gets 512 MB RAMContainer B gets 2 CPUsContainer B gets 2 GB RAM
```

---

A simple analogy:

Imagine a shared apartment.

**Namespaces**

```
Each person gets their own room.
```

**cgroups**

```
Each person gets a monthly electricity quota.
```

One provides separation.

The other provides limits.

---

Without cgroups, a container could do this:

```
while true; do   consume_cpudone
```

and use:

```
100% CPU
```

causing all other applications on the server to suffer.

With cgroups:

```
Container limited to 25% CPU
```

The kernel throttles it.

---

When you run:

```
docker run \  --cpus=1 \  --memory=512m \  nginx
```

Docker is basically translating that into Linux cgroup settings.

This is one of the reasons containers are lightweight.

```
VMs:Hypervisor enforces limitsContainers:Linux cgroups enforce limits
```

So if someone asks:

> "What are cgroups in one sentence?"

A good interview answer is:

**"cgroups are a Linux kernel mechanism that limits, prioritizes, and accounts for resource usage (CPU, memory, disk I/O, etc.) for a group of processes; Docker uses them to enforce container resource limits."**