
If you're practicing Docker troubleshooting for interviews or DevOps learning, intentionally break things at different layers.

**1. Dockerfile Errors**

Wrong base image:

```
FROM ubuntu123:latest
```

Error:

```
pull access deniedrepository does not exist
```

---

Missing file:

```
COPY app.jar /app.jar
```

when `app.jar` doesn't exist.

Error:

```
COPY failedfile not found
```

---

**2. Container Startup Errors**

Bad CMD:

```
CMD ["java", "-jar", "missing.jar"]
```

Error:

```
Error: Unable to access jarfile missing.jar
```

Check:

```
docker logs container-id
```

---

**3. Port Issues**

Application listens on 8080:

```
docker run -p 80:8080 app
```

works.

Break it:

```
docker run -p 80:9090 app
```

Now browser won't connect.

Debug:

```
docker psdocker logsdocker exec -it container shnetstat -tulnp
```

---

**4. Environment Variable Issues**

Application expects:

```
MONGO_URL
```

Run without it:

```
docker run app
```

Error:

```
Mongo connection failedMONGO_URL undefined
```

---

**5. Volume Issues**

Mount wrong path:

```
docker run -v /tmp/data:/app/config app
```

but application expects:

```
/app/data
```

Result:

```
File not foundConfiguration missing
```

---

**6. Network Issues**

Run MongoDB:

```
docker run -d --name mongo mongo
```

Run app:

```
docker run app
```

Application tries:

```
mongodb://localhost:27017
```

Fails because localhost inside container means the container itself.

Fix:

```
mongodb://mongo:27017
```

This is one of the most common interview scenarios.

---

**7. Permission Issues**

Run as non-root:

```
USER appuser
```

Try writing:

```
/var/log/app.log
```

Error:

```
Permission denied
```

---

**8. Resource Issues**

Limit memory:

```
docker run --memory=100m app
```

Application needs more.

Error:

```
OOMKilledExit Code 137
```

Check:

```
docker inspect container-id
```

---

**9. Image Pull Errors**

```
docker pull nginx:abc
```

Error:

```
manifest unknown
```

---

**10. Docker Daemon Errors**

Stop Docker service:

```
sudo systemctl stop docker
```

Then:

```
docker ps
```

Error:

```
Cannot connect to the Docker daemon
```

This is an excellent troubleshooting exercise because it forces you to check:

1. Is Docker daemon running?
2. Is image available?
3. Is container running?
4. Is application running?
5. Is port listening?
6. Is network working?
7. Are logs showing errors?

That sequence is essentially the Docker equivalent of your Terraform L1 → L10 troubleshooting ladder.


### 11. DNS Resolution Issues

Container cannot resolve another service.

```
curl catalogue
```

Error:

```
Could not resolve host
```

Check:

```
cat /etc/resolv.confnslookup catalogue
```

---

### 12. Container Restart Loops

```
docker ps
```

Shows:

```
Restarting (1) 5 seconds ago
```

Common causes:

- App crash
- Missing env vars
- Missing config files

Check:

```
docker logs <container>
```

---

### 13. Health Check Failures

Container running but marked unhealthy.

```
HEALTHCHECK CMD curl localhost:8080/health
```

App returns 500.

Check:

```
docker inspect <container>
```

---

### 14. Disk Full Issues

Very common in Jenkins servers.

```
No space left on device
```

Check:

```
df -hdocker system df
```

Cleanup:

```
docker system prune
```

---

### 15. Overlay2 Storage Corruption

Docker starts behaving strangely.

Symptoms:

```
read-only filesystemlayer not found
```

Check:

```
docker info
```

Look at:

```
Storage Driver: overlay2
```

---

### 16. Registry Authentication Failures

```
docker push
```

Error:

```
unauthorizeddenied
```

Check:

```
docker login
```

Very common with ECR.

---

### 17. Multi-Architecture Problems

Built on Mac M-series.

Run on EC2.

Error:

```
exec format error
```

Check:

```
docker inspect image
```

Look for:

```
arm64amd64
```

---

### 18. ENTRYPOINT vs CMD Issues

Container starts but arguments don't work.

```
ENTRYPOINT ["java"]CMD ["-jar","app.jar"]
```

Misconfiguration here causes lots of confusion.

---

### 19. User Permission Problems

```
USER appuser
```

Application needs:

```
/var/log/tmp/config
```

Error:

```
Permission denied
```

Very common in security-hardened images.

---

### 20. Timezone / Clock Drift Issues

Container works locally.

Fails in production.

Examples:

```
JWT token expiredSSL certificate invalid
```

Check:

```
datetimedatectl
```

---

### 21. SSL/TLS Certificate Problems

```
curl https://api.company.com
```

Error:

```
certificate signed by unknown authority
```

Common in corporate environments.

---

### 22. Container-to-Host Connectivity

Container cannot reach host services.

Many engineers try:

```
localhost
```

from inside container.

Wrong.

Need:

```
host.docker.internal
```

(or host IP depending on platform).

---

### 23. OOMKilled (Extremely Important)

One of the most common production incidents.

Container disappears.

Check:

```
docker inspect container
```

Look for:

```
ExitCode: 137
```

---

### 24. CPU Throttling

Container not crashing.

Just extremely slow.

Check:

```
docker stats
```

Often mistaken for application bugs.

---

### 25. Docker Networking (Bridge / Host / Overlay)

Interview favorite.

```
Container A can't talk to B
```

Check:

```
docker network lsdocker network inspect
```

---

### If I were building a "Docker Production Troubleshooting Cheatsheet", the top recurring incidents would be:

🥇 Container CrashLoop / Restart Loop

🥈 OOMKilled (Exit Code 137)

🥉 Port Mapping Errors

🏅 Environment Variables Missing

🏅 DNS Resolution Failures

🏅 Registry Authentication Issues

🏅 Disk Full (`No space left on device`)

🏅 Network Connectivity Problems

These 8 categories alone probably account for 80–90% of real Docker incidents you'll see in production.