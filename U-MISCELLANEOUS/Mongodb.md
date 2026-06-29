## Core diagram (simple + powerful)

           ┌───────────────────────────────┐  
           │         Your Host             │  
           │  (Laptop / EC2 / VM)         │  
           └──────────────┬────────────────┘  
                          │  
                    Docker Engine  
                          │  
           ┌──────────────▼────────────────┐  
           │     MongoDB Container         │  
           │                               │  
           │   ┌───────────────────────┐   │  
           │   │     mongod            │   │  
           │   │ (MongoDB Server)      │   │  
           │   │ listens on 27017      │   │  
           │   └───────────┬───────────┘   │  
           │               │               │  
           │        (connection)           │  
           │               │               │  
           │   ┌───────────▼───────────┐   │  
           │   │      mongosh          │   │  
           │   │  (Client / Shell)     │   │  
           │   └───────────────────────┘   │  
           └───────────────────────────────┘

---

## 🔥 What actually happens (step-by-step)

### 1. You start container

docker run mongo

👉 Inside container:

- `mongod` starts automatically ✅
- DB is now running

---

### 2. You enter container

docker exec -it <container> /bin/bash

👉 You are now:

- Inside container OS
- NOT inside database yet ❌

---

### 3. You connect to DB

mongosh

👉 Now:

- You are connected to `mongod`
- Can run queries ✅

---

## 🔹 Flow in one line

docker exec → container shell → mongosh → mongod → data

---

## 🔥 Key insight (this is what interviewers want)

> MongoDB is a **client-server model even inside a container**

- `mongod` = server
- `mongosh` = client
- Container = just environment

---

## 🔹 Alternative (skip manual steps)

You can directly do:

docker exec -it <container> mongosh

👉 Combines:

- enter container
- connect to DB

---

## 🔥 Real DevOps debugging mapping

|Problem|Where to check|
|---|---|
|Container not running|`docker ps`|
|DB not running|`ps aux|
|Can't connect|`mongosh`|
|No data|`db.collection.find()`|

---

## 🔥 Final mental model (lock this in)

Container ≠ Database  
Container runs the database  
You still need a client to talk to it