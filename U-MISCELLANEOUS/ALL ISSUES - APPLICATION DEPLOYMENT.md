This is one of the most common interview topics for senior DevOps roles. A good DevOps engineer thinks through the entire application lifecycle, not just Kubernetes.

Here's a practical checklist.

## 1. Source Code Issues

- Wrong branch deployed
- Merge conflicts
- Missing code changes
- Secrets committed to Git
- Build-breaking code
- Dependency version conflicts

**Symptoms**

- Build fails
- Tests fail
- Application behaves unexpectedly

---

## 2. CI/CD Pipeline Issues

- Jenkins/GitHub Actions pipeline failure
- Missing credentials
- Incorrect environment variables
- Artifact upload failure
- Wrong deployment triggered
- Pipeline timeout

**Symptoms**

- Pipeline stops midway
- Deployment never starts

---

## 3. Build Issues

### Docker

- Dockerfile syntax error
- Wrong base image
- Missing files in image
- Incorrect `COPY`
- Wrong `ENTRYPOINT`
- Wrong `CMD`
- Image too large
- Non-root permission issues

**Symptoms**

- Image build fails
- Container exits immediately

---

## 4. Image Registry Issues

- Authentication failure
- Image not pushed
- Wrong image tag
- Image pull denied
- Registry unavailable

**Symptoms**

- `ImagePullBackOff`
- `ErrImagePull`

---

## 5. Infrastructure Issues

### AWS

- EC2 not running
- EKS cluster unavailable
- Worker nodes not ready
- EBS volume unavailable
- Security Group blocks traffic
- Route Table issues
- NAT Gateway failure
- IAM permission issues
- VPC peering missing

---

## 6. Kubernetes Deployment Issues

### Scheduling

- No available nodes
- Insufficient CPU
- Insufficient memory
- Taints/Tolerations mismatch
- Node affinity mismatch
- Resource quota exceeded

**Symptoms**

```
Pending
```

---

### Pod Startup

- Wrong image
- Wrong command
- Missing ConfigMap
- Missing Secret
- Missing PVC
- Invalid manifest
- Invalid environment variables

**Symptoms**

- `CrashLoopBackOff`
- `CreateContainerConfigError`
- `CreateContainerError`

---

### Application Startup

- Database unavailable
- Redis unavailable
- RabbitMQ unavailable
- Migration failure
- License validation failure
- Configuration error

---

## 7. Storage Issues

- PVC Pending
- PV not bound
- StorageClass missing
- EBS CSI driver issue
- Disk full
- Permission denied

---

## 8. Networking Issues

These are extremely common.

- DNS resolution failure
- Service selector mismatch
- No endpoints
- Wrong Service type
- NetworkPolicy blocks traffic
- Ingress misconfiguration
- Load Balancer unhealthy
- Firewall/Security Group blocks ports
- TLS certificate issue
- Port mismatch

**Symptoms**

- Connection refused
- Timeout
- 502
- 503
- 504

---

## 9. Service Discovery Issues

- Wrong service name
- Wrong namespace
- Incorrect DNS
- Headless service issues

---

## 10. Application Issues

- Null pointer exceptions
- Memory leaks
- Deadlocks
- High CPU
- OutOfMemoryError
- Connection pool exhausted
- Thread pool exhausted
- Slow SQL queries

---

## 11. Database Issues

- Wrong credentials
- Database unavailable
- Lock contention
- Slow queries
- Connection limit exceeded
- Replica lag
- Schema mismatch
- Migration failed

---

## 12. Security Issues

- Expired certificates
- IAM permission denied
- Secret missing
- Token expired
- RBAC denies access
- Vulnerable container image

---

## 13. Scaling Issues

- HPA not scaling
- Cluster Autoscaler not working
- Pods cannot schedule
- Load balancer overloaded
- Database bottleneck

---

## 14. Runtime Issues (After Deployment)

- `CrashLoopBackOff`
- OOMKilled
- High CPU usage
- High memory usage
- Pod restarts
- Disk full
- File descriptor exhaustion
- Ephemeral storage exhaustion

---

## 15. Traffic Issues

- 404
- 401
- 403
- 500
- 502
- 503
- 504
- Sticky session problems
- Session loss
- Uneven load balancing

---

## 16. Monitoring Issues

- Logs not collected
- Metrics missing
- Prometheus scraping fails
- Alerts not firing
- Dashboard shows stale data

---

## 17. Deployment Strategy Issues

- Rolling update stuck
- Canary deployment unhealthy
- Blue-Green switch fails
- Rollback fails
- Old pods still serving traffic

---

## 18. Performance Issues

- High latency
- Slow startup
- Slow response times
- Garbage collection pauses
- Cache misses
- Excessive retries

---

## 19. External Dependency Issues

- Third-party API unavailable
- SMTP server down
- Payment gateway failure
- OAuth provider unavailable
- DNS provider outage

---

## 20. Disaster and Infrastructure Failures

- Node failure
- Availability Zone outage
- Region outage
- Disk failure
- Network partition
- Control plane issues
- Backup restore failure

### How to answer in an interview

A structured answer stands out more than listing random errors:

> "I usually troubleshoot deployment issues in layers. First I verify the CI/CD pipeline completed successfully and the correct image was pushed. Then I check Kubernetes resources—whether the pod is scheduled, starts successfully, and passes readiness and liveness probes. Next I verify networking, including Services, Ingress, DNS, and Network Policies. After that I check dependencies such as databases, caches, and message brokers. Finally, I review application logs, metrics, and resource utilization to identify runtime or performance issues."

This layered approach demonstrates systematic troubleshooting rather than memorizing individual error messages.