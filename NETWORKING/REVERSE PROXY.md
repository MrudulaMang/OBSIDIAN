A reverse proxy sits in front of servers and receives client requests before forwarding them to backend services.

Flow:

```
Client → Reverse Proxy → Backend Servers
```

The client usually does NOT directly talk to the actual application server.

---

# WHY REVERSE PROXIES EXIST

Modern applications rarely expose backend servers directly.

Reverse proxies handle:

- traffic routing
- SSL termination
- load balancing
- caching
- security
- compression
- hiding internal architecture

Without reverse proxies, scaling modern infrastructure becomes messy.

---

# REAL-WORLD EXAMPLES

## 1. NGINX Fronting Multiple Apps

```
Internet Users      ↓NGINX Reverse Proxy   ↓         ↓App1      App2
```

Example:

- `/api` → backend API
- `/static` → static content server

---

# 2. Load Balancer for Multiple Servers

```
Users  ↓Reverse Proxy ↓   ↓   ↓S1  S2  S3
```

Purpose:

- distribute traffic
- avoid overload
- improve availability

Examples:

- NGINX
- HAProxy
- Traefik

---

# 3. SSL Termination

Instead of every backend server handling HTTPS:

```
Client HTTPS      ↓Reverse Proxy handles SSL      ↓Internal HTTP traffic
```

Benefits:

- simpler backend configuration
- centralized certificate management
- lower backend overhead

Very common in Kubernetes ingress setups.

---

# 4. Kubernetes Ingress

In Kubernetes:

```
Internet   ↓Ingress Controller   ↓Pods/Services
```

Ingress controller acts like reverse proxy.

Common ingress tools:

- NGINX
- Traefik

---

# 5. Cloud Reverse Proxy / CDN

Example:

```
User → Cloudflare → Your Server
```

Cloudflare acts as reverse proxy.

It provides:

- DDoS protection
- caching
- SSL
- CDN acceleration

Your real server remains hidden.

---

# SIMPLE NGINX EXAMPLE

Suppose backend app runs on:

```
localhost:3000
```

NGINX config:

```
server {    listen 80;    location / {        proxy_pass http://localhost:3000;    }}
```

Flow:

```
User → NGINX:80 → App:3000
```

User never directly sees port 3000.

---

# REVERSE PROXY FEATURES

## Load Balancing

Distribute requests:

```
Req1 → Server1Req2 → Server2Req3 → Server3
```

---

## Caching

Store frequently accessed content.

Improves:

- speed
- scalability

---

## Security

Hide backend infrastructure.

Attackers see:

- proxy

Not:

- internal servers

---

## Compression

Reduce bandwidth.

---

## Rate Limiting

Prevent abuse.

Example:

- max 100 requests/minute

---

# FORWARD VS REVERSE PROXY

|Forward Proxy|Reverse Proxy|
|---|---|
|protects clients|protects servers|
|client-side|server-side|
|outbound traffic|inbound traffic|
|anonymity/filtering|scaling/security|

---

# INTERVIEW QUESTIONS

## What is reverse proxy?

Strong answer:

> A reverse proxy sits in front of backend servers and forwards client requests to appropriate services. It is used for load balancing, SSL termination, security, caching, and traffic routing.

---

## Why use reverse proxy instead of exposing servers directly?

Because it provides:

- centralized traffic management
- security
- scalability
- abstraction
- SSL handling

---

## Difference between load balancer and reverse proxy?

Important nuance:

- A reverse proxy CAN act as a load balancer.
- But not every reverse proxy is only doing load balancing.

Reverse proxy is broader.

---

# REAL DEVOPS IMPORTANCE

Reverse proxies appear everywhere:

- Kubernetes ingress
- API gateways
- microservices
- cloud architectures
- Docker deployments
- CDN setups

If you understand reverse proxies deeply, many networking architectures suddenly become easier to reason