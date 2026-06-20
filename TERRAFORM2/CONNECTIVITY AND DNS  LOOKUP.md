
`nslookup` is used to test **DNS resolution**.

It answers the question:

> "What IP address does this hostname resolve to?"

Example:

```
nslookup mysql-dev.devopsgeek.online
```

Output:

```
Server:         172.31.0.2Address:        172.31.0.2#53Name:   mysql-dev.devopsgeek.onlineAddress: 10.0.1.45
```

This tells you:

- DNS is working
- The hostname exists
- It resolves to `10.0.1.45`

---

Common troubleshooting flow:

### 1. Check DNS

```
nslookup mysql-dev.devopsgeek.online
```

If this fails:

```
NXDOMAIN
```

or

```
server can't find mysql-dev.devopsgeek.online
```

then the DNS record is missing or incorrect.

---

### 2. Check connectivity

```
nc -zv mysql-dev.devopsgeek.online 3306
```

If DNS works but connectivity fails, look at:

- Security Groups
- NACLs
- Route Tables
- Service status

---

### 3. Check application

```
mysql -h mysql-dev.devopsgeek.online -u root -p
```

If port is open but login fails, it's an application/configuration issue.

---

Other useful DNS commands:

```
dig mysql-dev.devopsgeek.online
```

(More detailed than `nslookup`)

```
host mysql-dev.devopsgeek.online
```

(Simple DNS lookup)

---

For DevOps interviews:

|Command|Tests|
|---|---|
|`nslookup hostname`|DNS resolution|
|`ping hostname`|DNS + ICMP reachability|
|`curl http://host`|HTTP service|
|`nc -zv host port`|TCP port connectivity|
|`ssh user@host`|SSH connectivity|
|`telnet host port`|Basic TCP connectivity|

A common troubleshooting sequence is:

```
nslookup hostnamenc -zv hostname portcurl http://hostname
```

This checks DNS → Network → Application, in that order.