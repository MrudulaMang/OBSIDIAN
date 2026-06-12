
When Docker is installed on a system, several things happen:

**System-level changes**

- A Docker daemon (`dockerd`) is installed as a background service that starts automatically on boot
- A CLI client (`docker`) is added to your PATH
- A Unix socket is created at `/var/run/docker.sock` — this is how the CLI communicates with the daemon
- A `docker` group is created so non-root users can be granted access

**Networking**

- A virtual network bridge called `docker0` is created (typically at `172.17.0.0/16`)
- iptables rules are added to handle NAT and container traffic routing
- Each container gets its own virtual network interface

**Filesystem**

- A storage directory is created, usually at `/var/lib/docker/`, which stores:
    - Image layers
    - Container filesystems
    - Volumes
    - Network configs
- A storage driver (like `overlay2`) is configured to manage layered image filesystems

**Kernel features used**

Docker doesn't install anything into the kernel, but it starts using existing kernel features:

- **Namespaces** — isolate processes, networking, filesystems per container
- **cgroups** — limit CPU, memory, I/O per container
- **iptables/nftables** — handle port forwarding and network isolation
- **seccomp / AppArmor / SELinux** — apply security profiles to containers

**On first `docker run`**

- If an image isn't cached locally, it's pulled from Docker Hub (or your configured registry)
- A container is created from the image with a writable top layer
- The container process runs inside its own namespace/cgroup sandbox

In short, Docker sets up a lightweight virtualization layer using Linux kernel primitives, with the daemon acting as the orchestrator between your commands and the kernel.