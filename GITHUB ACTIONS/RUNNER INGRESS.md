runner egress rules

For a self-hosted GitHub Actions runner, egress rules matter more than ingress in most cases.

Because the runner usually initiates connections outward.

Typical required egress:

1. GitHub communication

```
HTTPS TCP 443Destination: GitHub endpoints
```

Used for:

- job polling
- runner registration
- workflow execution
- artifact upload/download
- action downloads

2. Repository/package access

```
HTTPS TCP 443
```

For:

- Git clone
- package managers
- Docker pulls
- Maven/npm/pip dependencies

3. SonarQube access (if self-hosted)

```
TCP 9000Destination: SonarQube server
```

4. SSH if needed (rare)

```
TCP 22
```

5. Database/API/internal service access depending on deployment flow

Example:

```
TCP 5432 to PostgreSQLTCP 3306 to MySQL
```

Most common simple SG:

### Outbound

```
All traffic0.0.0.0/0
```

This works for labs.

For production, restrict by destination and purpose.

Important:

You usually do NOT need inbound 443/9000 on runner for Actions itself.

Because flow is:

```
Runner → GitHubRunner → SonarQube
```

not:

```
GitHub → RunnerSonarQube → Runner
```

Bad engineers memorize ports.

Good engineers ask:  
“Who initiates the TCP handshake?”