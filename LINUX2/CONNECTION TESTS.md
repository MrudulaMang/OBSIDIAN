Think of these tools as answering different troubleshooting questions.

|Tool|Question it answers|
|---|---|
|`ping`|Can I reach the host at the IP layer?|
|`nc`|Can I connect to a specific TCP/UDP port?|
|`telnet`|Can I manually open a TCP connection and interact with it?|
|`ss` / `netstat`|What ports are listening on this machine?|
|`curl`|Is the HTTP/HTTPS application responding?|
|`dig` / `nslookup`|Is DNS resolving correctly?|
|`traceroute`|Where is traffic getting stuck?|

### 1. ping

```
ping mongodb-dev.devopsgeek.online
```

Checks:

```
DNS → IPIP Reachability
```

Good for:

- Is the server alive?
- Is routing working?

Bad for:

- Verifying applications

Example:

```
ping worksMongoDB still down
```

because ping only checks ICMP.

---

### 2. nc (Netcat)

```
nc -zv mongodb-dev.devopsgeek.online 27017
```

Checks:

```
Can I open a TCP connection to this port?
```

Good for:

- Security Group testing
- Port connectivity testing
- Quick network verification

Example:

```
DNS ✓Network ✓Port 27017 ✓
```

---

### 3. telnet

```
telnet mongodb-dev.devopsgeek.online 27017
```

Older version of what people often use `nc` for.

Good for:

- Manual TCP testing
- SMTP testing
- Redis testing
- HTTP testing

Example:

```
telnet google.com 80GET /
```

You'll see the raw response.

Nowadays most engineers prefer `nc`.

---

### 4. ss

Modern Linux tool.

```
ss -tulpn
```

Checks:

```
What is listening on this machine?
```

Example:

```
ss -tulpn | grep 27017
```

Output:

```
LISTEN 0 128 *:27017
```

Meaning:

```
MongoDB is running and listening.
```

This is usually the first command I run after SSHing into a server.

---

### 5. netstat

Older version of `ss`.

```
netstat -tulpn
```

Same purpose:

```
What ports are open?
```

Most modern Linux distributions prefer:

```
ss
```

because it's faster.

---

### 6. curl

```
curl http://frontend-dev.devopsgeek.online
```

Checks:

```
Application layer
```

Good for:

- Web servers
- REST APIs
- Load balancers

Example:

```
curl localhost:8080/health
```

Response:

```
{"status":"UP"}
```

This proves the application works.

---

### 7. dig / nslookup

```
dig mongodb-dev.devopsgeek.online
```

Checks:

```
DNS only
```

Questions answered:

```
What IP does this hostname resolve to?
```

Example:

```
mongodb-dev.devopsgeek.online→ 10.0.21.218
```

DNS works.

---

### 8. traceroute

```
traceroute mongodb-dev.devopsgeek.online
```

Checks:

```
Path between source and destination
```

Useful when:

```
Ping failsConnection times out
```

Shows where packets stop.

---

## Real DevOps Troubleshooting Flow

Suppose:

```
Application cannot connect to MongoDB
```

Don't start with MongoDB logs.

Start systematically:

### Step 1

```
dig mongodb-dev.devopsgeek.online
```

Question:

```
Does DNS work?
```

---

### Step 2

```
nc -zv mongodb-dev.devopsgeek.online 27017
```

Question:

```
Can I reach the port?
```

---

### Step 3

SSH to MongoDB server.

```
ssh ec2-user@mongodb-server
```

---

### Step 4

```
ss -tulpn | grep 27017
```

Question:

```
Is MongoDB listening?
```

---

### Step 5

```
systemctl status mongod
```

Question:

```
Is MongoDB running?
```

---

### Mental Model

When debugging, move from lower layers to higher layers:

```
DNS ↓Network Reachability (ping) ↓Port Connectivity (nc/telnet) ↓Listening Process (ss/netstat) ↓Service Status (systemctl) ↓Application Response (curl) ↓Logs
```

Many engineers jump straight to logs. Strong troubleshooters isolate the layer first, then investigate within that layer. That's faster and produces cleaner root-cause analysis.