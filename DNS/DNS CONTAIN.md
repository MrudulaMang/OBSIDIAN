DNS fundamentally stores mappings and metadata.

Most beginners think DNS only stores:

```
domain → IP
```

That is only one record type.

DNS is actually a distributed hierarchical database.

Core mental model:

```
Human-friendly names        ↓DNS records        ↓Networking destinations/services/policies
```

DNS stores multiple kinds of records.

The important ones:

|Record|Purpose|
|---|---|
|A|Domain → IPv4|
|AAAA|Domain → IPv6|
|CNAME|Alias to another domain|
|MX|Mail server|
|NS|Name servers|
|TXT|Arbitrary text/verification|
|PTR|Reverse DNS|
|SRV|Service discovery|
|SOA|Zone authority metadata|

Example:

```
google.com  → 142.250.x.x
```

That is an A record.

---

# 1. A Record

Most common.

```
example.com → 1.2.3.4
```

Used when browsers connect to servers.

---

# 2. CNAME Record

Alias.

```
www.example.com → example.com
```

Instead of storing IP directly.

Very common in:

- CDNs
- load balancers
- SaaS integrations

---

# 3. MX Record

Mail routing.

```
gmail.com → Google mail servers
```

Without MX records:  
email delivery fails.

---

# 4. TXT Record

This became extremely important in cloud/security.

Used for:

- domain verification
- SPF
- DKIM
- DMARC
- ownership proofs

Example:

```
"google-site-verification=abc123"
```

DevOps engineers constantly touch TXT records.

---

# 5. NS Record

Tells the world:

```
"These servers are authoritative for this domain"
```

Example:

```
example.com   ↓ns1.cloudflare.comns2.cloudflare.com
```

---

# 6. SOA Record

Start Of Authority.

Contains:

- primary DNS server
- admin contact
- refresh timers
- serial numbers

Critical for DNS synchronization.

---

# 7. PTR Record

Reverse lookup:

```
IP → domain
```

Used heavily in:

- email anti-spam
- security systems
- logging

---

# Real DNS Zone Example

A domain zone might internally look like:

```
example.com.     A       1.2.3.4www              CNAME  example.commail             MX      10 mail.example.comexample.com.     TXT     "v=spf1 include:_spf.google.com"
```

---

# What DNS DOES NOT Store

DNS does not store:

- webpages
- application data
- files
- HTML
- databases

DNS only helps locate services/resources.

Think of DNS like:

```
Internet phonebook + routing hints
```

---

# Important Advanced Insight

Modern cloud architecture heavily depends on DNS because infrastructure is dynamic.

Servers change constantly.

Instead of:

```
hardcoded IPs
```

systems use:

```
stable DNS names
```

Examples:

- Kubernetes service discovery
- load balancers
- service meshes
- failover systems
- CDN routing
- multi-region architecture

This is why DNS failures can take down massive systems even when servers are healthy.

A strong systems engineer eventually realizes:

```
DNS is not “just naming.”It is part of distributed systems coordination.
```