list out all possible errors we get in docker

3:44 PM

Here's a comprehensive list organized by category:

---

**🔴 Image Errors**

- `image not found` / `pull access denied`
- `manifest unknown` — wrong tag or image doesn't exist
- `no such image` — image not built/pulled locally
- `image layer already exists` — usually harmless, but can block push
- `unauthorized: authentication required` — registry auth failed
- `toomanyrequests` — Docker Hub rate limit hit

---

**🟠 Container Runtime Errors**

- `container exited with code 1` — app crashed on startup
- `container exited with code 137` — OOM killed (out of memory)
- `container exited with code 139` — segfault
- `no such container` — container ID/name wrong or already removed
- `container already exists` — name conflict, `docker rm` first
- `container is not running` — exec on stopped container
- `cannot stop container: permission denied`

---

**🟡 Networking Errors**

- `port is already allocated` — host port in use
- `bind: address already in use` — same as above
- `network not found` — custom network doesn't exist
- `could not attach to network` — network/container mismatch
- `no route to host` — firewall or network policy blocking
- `connection refused` — port not exposed or app not listening
- `name does not resolve` — DNS broken, container not on same network

---

**🟢 Volume & Storage Errors**

- `mount denied` — permission issue on host path
- `no such file or directory` — wrong bind mount path
- `volume is in use` — can't remove, container still using it
- `read-only file system` — writing to a read-only volume
- `device or resource busy` — volume detach issue

---

**🔵 Build Errors**

- `COPY failed: no such file or directory` — wrong path in Dockerfile
- `RUN returned non-zero exit code` — command failed during build
- `failed to solve: dockerfile parse error` — syntax error in Dockerfile
- `unauthorized` — can't pull base image during build
- `no space left on device` — disk full, run `docker system prune`
- `invalid reference format` — bad image name/tag syntax
- `failed to read dockerfile` — Dockerfile not found

---

**🟣 Docker Daemon Errors**

- `cannot connect to Docker daemon` — daemon not running
- `permission denied /var/run/docker.sock` — user not in docker group
- `context deadline exceeded` — daemon timeout
- `daemon is not running` — service stopped
- `EOF` — daemon connection dropped mid-operation

---

**⚫ Docker Compose Errors**

- `service has neither an image nor a build` — missing image/build in compose file
- `network already exists` — leftover from previous run
- `depends_on service not found` — wrong service name reference
- `version is obsolete` — compose file version deprecated
- `no configuration file provided` — wrong directory or missing `docker-compose.yml`
- `port is already in use` — host port conflict

---

**🟤 Registry & Push/Pull Errors**

- `denied: requested access to resource is denied`
- `blob upload invalid`
- `layer already exists`
- `unknown: not found` — repo doesn't exist on registry
- `dial tcp: connection refused` — private registry unreachable

---

**Bonus — Exit Codes cheatsheet:**

|Code|Meaning|
|---|---|
|0|Success|
|1|General app error|
|126|Permission denied|
|127|Command not found|
|137|OOM killed (SIGKILL)|
|139|Segfault (SIGSEGV)|
|143|Graceful shutdown (SIGTERM)|

Want me to turn this into a LinkedIn post, a cheatsheet HTML artifact, or map each error to its fix?