
You can configure them through several mechanisms:

### 1. Docker Run

```
docker run --memory=512m --cpus=1 nginx
```

Most common for testing and learning.

---

### 2. Docker Compose

```
services:  web:    image: nginx    deploy:      resources:        limits:          cpus: '1'          memory: 512M
```

Useful when managing multiple containers.

---

### 3. Kubernetes

```
resources:  requests:    cpu: "500m"    memory: "512Mi"  limits:    cpu: "1"    memory: "1Gi"
```

Kubernetes eventually passes these down to the container runtime, which configures cgroups.

---

### 4. Directly via Linux cgroups

Without Docker at all:

```
mkdir /sys/fs/cgroup/mygroupecho 512M > memory.maxecho <PID> > cgroup.procs
```

This is what Docker is abstracting away from you.

---

The important mental model:

```
Docker CLI     │     ▼Docker Engine     │     ▼containerd / runc     │     ▼Linux cgroups
```

When you specify:

```
--memory=512m
```

Docker is not enforcing the limit itself.

Docker translates your request into a **cgroup configuration**, and the **Linux kernel** enforces it.

That's a subtle but important distinction for interviews:

> Docker configures cgroups; the Linux kernel enforces cgroups. Docker is not continuously policing resource usage itself.