  

[

](https://chatgpt.com/)

all probes in k8 , explain in short notes

  

There are **3 types of probes** in Kubernetes. They answer different questions about your application.

|Probe|Question it answers|Action if it fails|
|---|---|---|
|**Liveness Probe**|_Is the application alive?_|Restarts the container|
|**Readiness Probe**|_Can the application serve traffic?_|Removes Pod from Service endpoints (no restart)|
|**Startup Probe**|_Has the application finished starting?_|Keeps checking during startup; if it fails repeatedly, restarts container|

---

## 1. Liveness Probe

**Purpose**

- Detects whether the application is stuck or deadlocked.
    
- Kubernetes restarts the container if the probe fails.
    

**Think of it as**

> "Is the app still alive?"

**Used for**

- Deadlocks
    
- Infinite loops
    
- Hung processes
    

**Example**

```
livenessProbe:
  httpGet:
    path: /health
    port: 8080
```

**Important**

- Failing liveness = **Container Restart**
    

---

## 2. Readiness Probe

**Purpose**

- Determines whether the application is ready to receive user requests.
    
- If it fails, Kubernetes **does not restart** the container.
    
- Instead, it removes the Pod from the Service.
    

**Think of it as**

> "Can users safely send requests?"

**Used for**

- Database not connected
    
- Cache warming
    
- Dependency unavailable
    
- Application initialization
    

**Example**

```
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
```

**Important**

- Failing readiness = **No Traffic**
    
- Pod keeps running.
    

---

## 3. Startup Probe

**Purpose**

- Gives slow-starting applications enough time to boot.
    
- Until it succeeds:
    
    - Liveness Probe is disabled.
        
    - Readiness Probe is also not evaluated for serving traffic.
        

**Think of it as**

> "Has the application finished starting?"

**Used for**

- Spring Boot
    
- Large Java applications
    
- Applications performing long initialization
    

**Example**

```
startupProbe:
  httpGet:
    path: /startup
    port: 8080
```

**Important**

- Prevents unnecessary restarts during startup.
    

---

# Probe Methods

All three probes can use the same mechanisms.

### HTTP GET

```
httpGet:
  path: /health
  port: 8080
```

Checks if HTTP returns **200–399**.

---

### TCP Socket

```
tcpSocket:
  port: 3306
```

Checks whether a TCP connection can be established.

Useful for databases like MySQL or Redis.

---

### Exec Command

```
exec:
  command:
    - cat
    - /tmp/healthy
```

Runs a command inside the container.

Exit code:

- `0` → Success
    
- Non-zero → Failure
    

---

## Common Parameters

```
initialDelaySeconds: 30
periodSeconds: 10
timeoutSeconds: 2
failureThreshold: 3
successThreshold: 1
```

|Parameter|Meaning|
|---|---|
|`initialDelaySeconds`|Wait before first probe|
|`periodSeconds`|Probe interval|
|`timeoutSeconds`|Time allowed for each probe|
|`failureThreshold`|Consecutive failures before considering the probe failed|
|`successThreshold`|Consecutive successes needed to recover (mostly used with Readiness)|

---

## Quick Comparison

|Feature|Liveness|Readiness|Startup|
|---|---|---|---|
|Checks if app is alive|✅|❌|❌|
|Checks if app can serve traffic|❌|✅|❌|
|Handles slow startup|❌|❌|✅|
|Failure restarts container|✅|❌|✅ (during startup)|
|Failure removes Pod from Service|❌|✅|No (startup must succeed first)|
|Runs after startup|Yes|Yes|No (stops after first success)|

---

## Interview Summary

- **Liveness Probe** → Detects a hung application and **restarts the container**.
    
- **Readiness Probe** → Controls whether the Pod **receives traffic**; failures remove it from Service endpoints without restarting it.
    
- **Startup Probe** → Protects slow-starting applications by delaying liveness checks until startup completes, preventing premature restarts.
    

  

orderof probing

  

The execution order is:

```
Container Starts
      │
      ▼
Startup Probe (if configured)
      │
      ├── Success
      │      ▼
      │  Readiness Probe starts
      │      │
      │      ▼
      │  Liveness Probe starts
      │
      └── Failure (failureThreshold reached)
             ▼
      Container Restart
```

### If a Startup Probe is configured

1. Container starts.
    
2. **Startup Probe** runs.
    
3. Until the Startup Probe succeeds:
    
    - ❌ Liveness Probe does **not** run.
        
    - ❌ Readiness Probe does **not** make the Pod ready for traffic.
        
4. Once Startup succeeds:
    
    - ✅ Readiness Probe begins checking if the Pod can receive traffic.
        
    - ✅ Liveness Probe begins checking if the application is healthy.
        

---

### If no Startup Probe is configured

```
Container Starts
      │
      ▼
Readiness Probe
      │
      ▼
Liveness Probe
```

In practice, **Readiness and Liveness are scheduled independently** based on their own `initialDelaySeconds` and `periodSeconds`. One does not wait for the other. The readiness probe often reports success first, allowing the Pod to receive traffic, while the liveness probe continues monitoring for hangs or deadlocks.

### Easy way to remember

```
Startup  →  "Can I start?"
Readiness → "Can I take traffic?"
Liveness → "Am I still alive?"
```

Or as a timeline:

```
Container Created
       │
       ▼
Startup Probe
       │
       ▼
Readiness Probe
       │
       ▼
Pod added to Service
       │
       ▼
Liveness Probe (continues throughout the Pod's lifetime)
```

The key point for interviews is that **Startup Probe temporarily disables liveness checks until the application has finished starting**, preventing unnecessary restarts of slow-starting applications.