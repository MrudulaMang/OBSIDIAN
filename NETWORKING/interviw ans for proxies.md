# Reverse Proxy — Interview Answer

## Short Answer (1–2 lines)

> A reverse proxy sits in front of backend servers and forwards client requests to appropriate servers. It is commonly used for load balancing, SSL termination, caching, and security.

---

## Medium Answer (Good for Most Interviews)

> A reverse proxy acts as an intermediary between clients and backend servers. Clients send requests to the reverse proxy, and it forwards them internally to application servers. This helps hide backend infrastructure and provides centralized traffic management.
> 
> Reverse proxies are used for:
> 
> - load balancing
> - SSL termination
> - caching
> - routing
> - rate limiting
> - security
> 
> Common examples are NGINX and HAProxy.

---

## Architecture Explanation

```
Client → Reverse Proxy → Backend Servers
```

Example:

```
User → NGINX → Node.js App
```

---

## Real Production Example

> Suppose we have 3 application servers running behind NGINX. Users never directly access those servers. NGINX receives all requests and distributes traffic across backend servers. It can also terminate HTTPS and forward internal traffic over HTTP.

---

## Interview Follow-Up:

### Why use reverse proxy?

> It improves scalability, security, centralized routing, SSL management, and hides backend infrastructure from external users.

---

## Interview Follow-Up:

### Is load balancer same as reverse proxy?

> A reverse proxy can perform load balancing, but reverse proxy is a broader concept. It also handles SSL termination, routing, caching, and security.

---

# Forward Proxy — Interview Answer

## Short Answer (1–2 lines)

> A forward proxy sits between clients and the internet and forwards client requests on their behalf. It is used for anonymity, filtering, monitoring, and outbound traffic control.

---

## Medium Answer

> A forward proxy acts on behalf of clients. Instead of clients directly accessing internet resources, they send requests to the forward proxy, which then contacts external servers.
> 
> Forward proxies are commonly used in corporate or educational networks for:
> 
> - content filtering
> - monitoring
> - access control
> - caching
> - privacy/anonymity

---

## Architecture Explanation

```
Client → Forward Proxy → Internet
```

Example:

```
Employee Laptop → Corporate Proxy → Google
```

---

## Real Production Example

> In many organizations, internet access goes through a proxy server like Squid or Zscaler. The company can block websites, monitor usage, and enforce security policies through the forward proxy.

---

## Interview Follow-Up:

### Why use forward proxy?

> It helps with outbound traffic control, security enforcement, anonymity, monitoring, and bandwidth optimization.

---

# BEST INTERVIEW DIFFERENCE ANSWER

> A forward proxy represents clients and sits between users and the internet, while a reverse proxy represents servers and sits between users and backend applications.

---

# FAST MEMORY TRICK

|Type|Protects|
|---|---|
|Forward Proxy|Clients|
|Reverse Proxy|Servers|

---

# STRONGER SENIOR-STYLE ANSWER

If interviewer pushes deeper:

> Reverse proxies are heavily used in microservices and Kubernetes environments for ingress routing, SSL offloading, and traffic management. Forward proxies are more common in enterprise security and outbound access control scenarios.

That answer signals architectural awareness rather than textbook memorization.