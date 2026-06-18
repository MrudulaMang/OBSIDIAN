
Here's the full layer-by-layer testing breakdown for Docker container connectivity:

| Layer                   | What it tests                      | Command                                                               |
| ----------------------- | ---------------------------------- | --------------------------------------------------------------------- |
| L3 — Network            | Is the container reachable? (ICMP) | `ping <container-name>`                                               |
| L4 — Transport          | Is the TCP port open?              | `nc -zv <host> <port>`                                                |
| L4 — UDP                | Is the UDP port open?              | `nc -zvu <host> <port>`                                               |
| L7 — Application (HTTP) | Is the service responding?         | `curl -v http://<service>:<port>`                                     |
| L7 — DNS                | Is name resolution working?        | `nslookup <container-name>` or `dig <container-name>`                 |
| L7 — App health         | Does the endpoint return 200?      | `curl -o /dev/null -sw "%{http_code}" http://<service>:<port>/health` |

**Execution order when debugging:**

```
1. ping        → if fails, network/DNS issue
2. nslookup    → if ping works but name fails, DNS resolution broken
3. nc -zv      → if DNS ok, check if port is actually open
4. curl -v     → if port open, check if app is responding correctly
```
One-liner to run all from inside a container:

docker exec -it <container> sh -c "
  ping -c 2 <target> &&
  nc -zv <target> <port> &&
  curl -v http://<target>:<port>
-------------------------------------------------------------------------------


🐳 Docker Container Connectivity — Mistakes I see engineers make (and how to fix them)

After working with Docker in production, here are the top connectivity mistakes that cost teams hours of debugging:

─────────────────────────
❌ Mistake 1: Containers on different networks wondering why they can't talk

By default, each `docker run` uses the bridge network — but custom bridge networks are isolated from each other.

✅ Fix: Put containers on the same custom network.
```
docker network create myapp-net
docker run --network myapp-net --name api ...
docker run --network myapp-net --name db ...
```
Containers on the same custom network get automatic DNS resolution. `api` can reach `db` just by name.
─────────────────────────
❌ Mistake 2: Using `localhost` inside a container to reach another container

`localhost` inside a container = that container itself. Not your host. Not another container.

✅ Fix: Use the container name (on a custom network) or the service name (in Docker Compose).
─────────────────────────
❌ Mistake 3: Port not exposed ≠ port not running

Engineers confuse `EXPOSE` in Dockerfile with actually publishing the port.
`EXPOSE` is documentation. It does nothing at runtime.

✅ Fix: Use `-p host:container` to actually publish.
```
docker run -p 8080:80 nginx
```
─────────────────────────
❌ Mistake 4: Forgetting that Docker Desktop on Mac/Windows runs inside a Linux VM

Your container's `host.docker.internal` ≠ your laptop's localhost in all situations. Network paths go through the VM layer.

✅ Fix: Use `host.docker.internal` explicitly when a container needs to reach a service on your host machine.
─────────────────────────
❌ Mistake 5: No network alias, multiple containers, same service

When scaling, containers need a stable DNS name regardless of which instance handles the request.

✅ Fix: Use `--network-alias` or let Docker Compose handle service discovery automatically.
─────────────────────────

**Why `nc -zv` earns its place here:**

- `ping` tests Layer 3 (ICMP) — is the container reachable at all?
- `curl` tests Layer 7 (HTTP) — is the service responding?
- `nc -zv` tests Layer 4 (TCP) — is the port open, even if the app isn't HTTP?