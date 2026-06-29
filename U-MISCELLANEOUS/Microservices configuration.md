
  

how to configure db with backend microservices. also, how too configure backend microservices which talk to each other

11:19 AM

## Configuring a Database with Backend Microservices

### 1. Database-per-Service Pattern (Recommended)

Each microservice should own its database — this is the core principle of microservices architecture.

```
User Service      → PostgreSQL (users_db)
Order Service     → MySQL (orders_db)
Inventory Service → MongoDB (inventory_db)
Payment Service   → PostgreSQL (payments_db)
```

**Why?** Loose coupling, independent scaling, and tech flexibility per service.

---

### 2. DB Connection Configuration

**Environment-based config (Node.js example):**

js

```js
// config/db.js
const { Pool } = require('pg');

const pool = new Pool({
  host:     process.env.DB_HOST,
  port:     process.env.DB_PORT || 5432,
  database: process.env.DB_NAME,
  user:     process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max:      10,  // connection pool size
});

module.exports = pool;
```

**.env per service:**

env

```env
# user-service/.env
DB_HOST=postgres-user
DB_PORT=5432
DB_NAME=users_db
DB_USER=user_svc
DB_PASSWORD=secret
```

**Python (SQLAlchemy):**

python

```python
from sqlalchemy import create_engine
import os

DATABASE_URL = os.getenv("DATABASE_URL")
# e.g. postgresql://user:pass@host:5432/db_name

engine = create_engine(DATABASE_URL, pool_size=10, max_overflow=20)
```

---

### 3. Docker Compose Setup

yaml

```yaml
version: '3.8'
services:

  user-service:
    build: ./user-service
    environment:
      DB_HOST: postgres-user
      DB_NAME: users_db
      DB_USER: user_svc
      DB_PASSWORD: secret
    depends_on:
      - postgres-user

  order-service:
    build: ./order-service
    environment:
      DB_HOST: postgres-orders
      DB_NAME: orders_db
      DB_USER: order_svc
      DB_PASSWORD: secret
    depends_on:
      - postgres-orders

  postgres-user:
    image: postgres:15
    environment:
      POSTGRES_DB: users_db
      POSTGRES_USER: user_svc
      POSTGRES_PASSWORD: secret
    volumes:
      - user_data:/var/lib/postgresql/data

  postgres-orders:
    image: postgres:15
    environment:
      POSTGRES_DB: orders_db
      POSTGRES_USER: order_svc
      POSTGRES_PASSWORD: secret
    volumes:
      - order_data:/var/lib/postgresql/data

volumes:
  user_data:
  order_data:
```

---

## Microservice-to-Microservice Communication

There are two main patterns:

### Pattern 1 — Synchronous (REST / gRPC)

Best for: real-time queries where you need an immediate response.

```
Order Service ──HTTP──▶ User Service
                        (verify user exists)
```

js

```js
// order-service: calling user-service via REST
const axios = require('axios');

async function getUser(userId) {
  const response = await axios.get(
    `${process.env.USER_SERVICE_URL}/users/${userId}`
  );
  return response.data;
}
```

env

```env
# order-service/.env
USER_SERVICE_URL=http://user-service:3001
INVENTORY_SERVICE_URL=http://inventory-service:3002
```

**With gRPC (faster, typed):**

proto

```proto
// user.proto
service UserService {
  rpc GetUser (UserRequest) returns (UserResponse);
}
```

---

### Pattern 2 — Asynchronous (Message Queue)

Best for: events, notifications, decoupled workflows (no waiting needed).

```
Order Service ──publish──▶ RabbitMQ/Kafka ──consume──▶ Email Service
                                                  └──▶ Inventory Service
```

**RabbitMQ example:**

js

```js
// order-service: publish event
const amqp = require('amqplib');

async function publishOrderCreated(order) {
  const conn = await amqp.connect(process.env.RABBITMQ_URL);
  const ch = await conn.createChannel();
  await ch.assertQueue('order.created');
  ch.sendToQueue('order.created', Buffer.from(JSON.stringify(order)));
}

// inventory-service: consume event
async function consumeOrders() {
  const conn = await amqp.connect(process.env.RABBITMQ_URL);
  const ch = await conn.createChannel();
  await ch.assertQueue('order.created');
  ch.consume('order.created', (msg) => {
    const order = JSON.parse(msg.content.toString());
    updateInventory(order);
    ch.ack(msg);
  });
}
```

---

### Pattern 3 — API Gateway (Entry Point)

All external traffic goes through one gateway; internal services talk directly.

```
Client ──▶ API Gateway (nginx / Kong) ──▶ User Service
                                    └──▶ Order Service
                                    └──▶ Payment Service
```

**nginx config:**

nginx

```nginx
location /api/users/ {
    proxy_pass http://user-service:3001/;
}
location /api/orders/ {
    proxy_pass http://order-service:3002/;
}
```

---

## Quick Decision Guide

|Need|Use|
|---|---|
|Immediate response required|REST or gRPC|
|Fire-and-forget / events|RabbitMQ / Kafka|
|Service discovery at scale|Kubernetes + DNS|
|Secrets management|Vault / K8s Secrets|
|Resilience (retries, timeouts)|Circuit Breaker (e.g. `opossum`)|

**Key rules to follow:**

- Never share a database between two services
- Always use env variables for DB credentials — never hardcode
- Use a **service registry** (like Consul or K8s DNS) in production for dynamic URLs
- Add **health checks** (`/health` endpoint) to every service
- Use **circuit breakers** to prevent cascade failures when one service is down

  

[Claude is AI and can make mistakes. Please double-check responses.](https://support.anthropic.com/en/articles/8525154-claude-is-providing-incorrect-or-misleading-responses-what-s-going-on)