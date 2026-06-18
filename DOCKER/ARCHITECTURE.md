docker run nginx

docker CLI
      │
      ▼
docker.sock
      │
      ▼
dockerd
      │
      ▼
containerd
      │
      ▼
runc
      │
      ▼
Linux namespaces/cgroups
      │
      ▼
Container starts

-----


- Containerd actually manages container lifecycles underneath Docker.
- `runc` is the component that actually creates and starts the container.
	-`runc` makes the actual Linux system calls needed to:
	-Create namespaces
	-Configure cgroups
	-Set filesystem mounts
	-Set capabilities
	-Start the container process


### Where is Docker Engine?

Historically, **Docker Engine** refers to the whole Docker runtime stack:

```
Docker Engine
├── Docker CLI
├── dockerd
├── containerd
└── runc
```

### Verify Everything on Your EC2

```
which docker
which dockerd
ps -ef | grep dockerd
ps -ef | grep containerd
systemctl status docker
ls -l /var/run/docker.sock
```