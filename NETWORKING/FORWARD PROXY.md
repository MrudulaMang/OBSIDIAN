A forward proxy sits between the client and the internet.

Flow:

```
Client → Forward Proxy → Internet
```

The server on the internet sees the proxy, not the original client directly.

---

# REAL-WORLD EXAMPLES

## 1. Corporate Internet Proxy

Common in companies.

Employees:

```
Laptop → Corporate Proxy → Internet
```

Purpose:

- monitor traffic
- block websites
- log usage
- enforce security policies

Example products:

- Blue Coat Systems
- Zscaler
- Squid

Example:  
Company blocks:

- YouTube
- torrents
- social media

The proxy filters requests before internet access.

---

# 2. School/College Network Proxy

Used to:

- restrict websites
- cache educational content
- reduce bandwidth usage

Example:

```
Student Browser → College Proxy → Google
```

---

# 3. Anonymous Browsing Proxy

User hides their IP.

```
User → Proxy Server → Website
```

Website sees proxy IP instead of user IP.

Used for:

- privacy
- geo-restriction bypass
- masking location

---

# 4. VPN (Conceptually Similar)

VPN is not exactly the same as a forward proxy, but similar idea exists.

```
Laptop → VPN Server → Internet
```

The external website sees VPN server IP.

Examples:

- NordVPN
- ExpressVPN

Difference:  
VPN usually tunnels all traffic at network layer, not just application traffic.

---

# 5. Caching Proxy

Proxy stores frequently requested content.

Example:  
100 employees downloading same update.

Instead of:

```
100 downloads from internet
```

Proxy:

- downloads once
- serves locally afterward

Saves:

- bandwidth
- latency

---

# COMMON FORWARD PROXY SOFTWARE

|Tool|Purpose|
|---|---|
|Squid|caching + filtering|
|HAProxy|mostly reverse proxy/load balancer|
|TinyProxy|lightweight proxy|
|Privoxy|privacy filtering|

---

# FORWARD PROXY VS REVERSE PROXY

This is extremely important in interviews.

## Forward Proxy

Represents:  
CLIENTS

```
Users → Proxy → Internet
```

Used for:

- privacy
- filtering
- outbound control

---

## Reverse Proxy

Represents:  
SERVERS

```
Users → Reverse Proxy → Backend Servers
```

Used for:

- load balancing
- SSL termination
- routing
- caching

Examples:

- NGINX
- HAProxy
- Traefik

---

# DEVOPS INTERVIEW EXPLANATION

Good concise answer:

> A forward proxy sits between client and internet, forwarding client requests on behalf of users. It is commonly used for security, filtering, anonymity, and outbound traffic control.

---

# EASY MEMORY TRICK

Forward proxy protects/hides:

- CLIENTS

Reverse proxy protects/hides:

- SERVERS

That single distinction solves most beginner confusion.