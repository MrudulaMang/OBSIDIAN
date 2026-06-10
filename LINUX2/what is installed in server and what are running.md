suppose i am in a server, donno what it is mongo or mysql or else, how do i know

Good question. This is exactly how an SRE or production engineer thinks.

Suppose someone gives you:

```
10.0.21.218
```

and says:

> "Something is wrong. Investigate."

You don't assume MongoDB, MySQL, or anything else.

### Step 1: What machine am I on?

```
hostnamehostnamectlcat /etc/os-release
```

Understand the basic host.

---

### Step 2: What processes are running?

```
ps -ef
```

or

```
ps aux
```

Look for clues:

```
mysqldmongodnginxhttpdjavanoderedis-serverrabbitmq-server
```

Example:

```
ps -ef | grep mongo
```

---

### Step 3: What ports are listening?

Most important command:

```
ss -tulpn
```

Example output:

```
LISTEN 0 128 *:22      sshdLISTEN 0 128 *:27017   mongod
```

Immediately tells you:

```
Port 27017Process mongod
```

Likely MongoDB server.

Another example:

```
LISTEN 0 128 *:3306 mysqld
```

Likely MySQL.

---

### Common Port Clues

|Port|Usually|
|---|---|
|22|SSH|
|80|HTTP|
|443|HTTPS|
|3306|MySQL|
|5432|PostgreSQL|
|27017|MongoDB|
|6379|Redis|
|5672|RabbitMQ|
|8080|Java app/Tomcat|
|9090|Prometheus|
|9100|Node Exporter|

Port alone is not proof, but it's a strong hint.

---

### Step 4: Check services

On modern Linux:

```
systemctl list-units --type=service --state=running
```

or

```
systemctl status mongodsystemctl status mysqldsystemctl status rabbitmq-server
```

Example:

```
mongod.service active (running)
```

Now you're much more confident.

---

### Step 5: Look at installed packages

RHEL/CentOS:

```
rpm -qa
```

Ubuntu:

```
dpkg -l
```

Search:

```
rpm -qa | grep mongorpm -qa | grep mysql
```

---

### Step 6: Check listening process ownership

Very useful:

```
ss -tulpn
```

Example:

```
LISTEN 0 128 *:27017 users:(("mongod",pid=1234))
```

The process name is often the answer.

---

### Step 7: Check disk layout

Databases often leave obvious traces.

```
df -hls /var/lib
```

Examples:

```
/var/lib/mysql/var/lib/mongo/var/lib/rabbitmq
```

---

### Step 8: Cloud clues

In AWS:

```
curl http://169.254.169.254/latest/meta-data/tags/instance/Name
```

or

```
aws ec2 describe-tags ...
```

You might see:

```
roboshop-dev-mongodb
```

Instant clue.

---

### How experienced engineers usually do it

If I SSH into an unknown Linux server, my first 3 commands are often:

```
hostnamess -tulpnps -ef
```

Within 30 seconds I usually know:

```
What service it runsWhat ports are exposedWhether it is healthy
```

The deeper lesson: don't identify a server by its name. Identify it by the process that is listening and serving traffic. In production you'll often encounter badly named hosts, stale documentation, and outdated diagrams. The process table and listening sockets are the ground truth.