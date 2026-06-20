Use the tool based on the protocol you're testing.

### SSH (port 22)

```
ssh ec2-user@mysql-dev.devopsgeek.online
```

Tests:

- DNS resolution
- Network connectivity
- Security Groups/NACLs
- SSH service running
- Authentication

---

### HTTP / HTTPS

For web applications or APIs:

```
curl http://catalogue-dev.devopsgeek.online
```

or

```
curl https://catalogue-dev.devopsgeek.online
```

Tests:

- DNS resolution
- Network connectivity
- Web server reachable
- HTTP response

---

### Port connectivity only

If you just want to know whether a port is open:

```
nc -zv mysql-dev.devopsgeek.online 3306
```

or

```
telnet mysql-dev.devopsgeek.online 3306
```

For Redis:

```
nc -zv redis-dev.devopsgeek.online 6379
```

For RabbitMQ:

```
nc -zv rabbitmq-dev.devopsgeek.online 5672
```

---

### Database-specific tests

MySQL:

```
mysql -h mysql-dev.devopsgeek.online -u root -p
```

Redis:

```
redis-cli -h redis-dev.devopsgeek.online
```

MongoDB:

```
mongosh mongodb-dev.devopsgeek.online
```

---

In Roboshop troubleshooting, a common sequence from the Bastion host is:

```
# HTTP servicecurl http://catalogue-dev.devopsgeek.online# MySQL portnc -zv mysql-dev.devopsgeek.online 3306# Redis portnc -zv redis-dev.devopsgeek.online 6379# RabbitMQ portnc -zv rabbitmq-dev.devopsgeek.online 5672
```

`curl` is primarily for **HTTP/HTTPS endpoints**. For databases and message brokers, use the native client (`mysql`, `redis-cli`, `mongosh`) or a port test (`nc`, `telnet`).