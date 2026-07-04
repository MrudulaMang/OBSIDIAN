Runtime Issues (After Deployment), IF IT IS not kubernetes

If the application is **not running on Kubernetes** (for example, on a VM, physical server, or directly on an EC2 instance), the runtime issues are different. You're primarily concerned with the application process, the operating system, the web server, and external dependencies.

Here are the common runtime issues after deployment.

### 1. Application Process Issues

- Application crashes unexpectedly
- Process exits immediately
- Process hangs or becomes unresponsive
- Application never starts
- Background services fail

**Examples**

- Java application exits with an exception
- Node.js process crashes
- Python service terminates

---

### 2. Memory Issues

- Out of memory
- Memory leak
- Swap usage increases
- JVM heap exhausted
- Excessive garbage collection

**Symptoms**

- Slow responses
- Application killed by the OS
- High memory usage

---

### 3. CPU Issues

- High CPU utilization
- Infinite loops
- Excessive thread creation
- Busy waiting

**Symptoms**

- Server becomes slow
- Increased response times

---

### 4. Disk Issues

- Disk full
- Log files consume all disk space
- Temporary directory fills up
- Unable to write files

**Symptoms**

- "No space left on device"
- Application errors while writing logs or uploads

---

### 5. File Permission Issues

- Application cannot read configuration files
- Cannot write logs
- Cannot access uploaded files
- Executable permission missing

---

### 6. Port Issues

- Required port already in use
- Wrong port configured
- Firewall blocks the port

**Symptoms**

- Application starts but isn't reachable
- "Address already in use"

---

### 7. Network Issues

- DNS resolution fails
- Cannot reach database
- API calls time out
- Packet loss
- High latency

---

### 8. Database Issues

- Database server unavailable
- Authentication failure
- Connection pool exhausted
- Slow queries
- Deadlocks
- Database locks

---

### 9. External Dependency Issues

- Redis unavailable
- RabbitMQ unavailable
- SMTP server unreachable
- Payment gateway down
- Third-party API unavailable

---

### 10. Configuration Issues

- Wrong environment variables
- Incorrect configuration file
- Missing secrets
- Invalid property values

---

### 11. Web Server Issues

If using Nginx or Apache:

- Nginx not running
- Apache crashed
- Reverse proxy misconfigured
- SSL certificate expired
- Incorrect virtual host configuration

---

### 12. Security Issues

- Expired SSL certificate
- Authentication failures
- Authorization failures
- Firewall rules blocking traffic

---

### 13. Performance Issues

- Slow response times
- High latency
- Cache misses
- Thread pool exhaustion
- Connection pool exhaustion

---

### 14. Logging Issues

- Logs not generated
- Incorrect log level
- Log rotation not configured
- Log directory permissions incorrect

---

### 15. OS-Level Issues

- Too many open files (`ulimit` reached)
- Too many processes
- Zombie processes
- Time synchronization issues
- Kernel resource limits exceeded

---

### 16. Runtime Errors

- Null pointer exceptions
- Segmentation faults
- Unhandled exceptions
- Stack overflow
- Library incompatibilities

---

### 17. Service Management Issues

- Service not enabled after reboot
- Service repeatedly restarts
- `systemd` service failure
- Incorrect service dependencies

---

### Common Linux commands used to troubleshoot

|Area|Commands|
|---|---|
|Process|`ps -ef`, `top`, `htop`, `pgrep`|
|Logs|`journalctl`, `tail -f`, `less`|
|Memory|`free -h`, `vmstat`, `top`|
|CPU|`top`, `mpstat`, `sar`|
|Disk|`df -h`, `du -sh`, `lsblk`|
|Network|`ping`, `curl`, `ss -tulnp`, `netstat`, `traceroute`|
|Ports|`ss -tulnp`, `lsof -i`|
|Services|`systemctl status`, `systemctl restart`|
|Files|`ls -l`, `stat`, `chmod`, `chown`|

In an interview, avoid simply listing issues. A stronger answer is to explain your troubleshooting sequence:

1. Confirm the application process is running.
2. Check service status (`systemctl status`).
3. Review application and system logs.
4. Verify CPU, memory, and disk utilization.
5. Ensure the application is listening on the expected port.
6. Test connectivity to databases and external services.
7. Validate configuration files and environment variables.
8. Confirm the application is serving requests correctly.

This demonstrates a systematic approach rather than knowledge of isolated problems.