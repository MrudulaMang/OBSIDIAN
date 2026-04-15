## ⚡ Quick DevOps Insight (Important for You)

- 🔥 **Ports matter in debugging**  
    When service fails → first check:
    
    netstat -tulnp | grep <port>
    
- 🧠 **Common production issues**
    - Port already in use
    - Security group blocking port (AWS)
    - Container not exposing port
    - Service listening on `localhost` instead of `0.0.0.0`
- 🐳 **Docker example**
    
    -p 3306:3306   # MySQL  
    -p 6379:6379   # Redis  
    -p 27017:27017 # MongoDB
    

---

If you want, I can give you a **"debugging cheatsheet using these ports"** — like how to quickly identify which service is failing in a microservices setup (very useful for interviews + real production).

OK

Good. Let’s turn this into **real DevOps debugging muscle** (this is where you’ll stand out in interviews).

---

# 🔍 Database Port Debugging Cheat Sheet

## 🧠 Step 1: Check if service is listening on port

netstat -tulnp | grep 3306

or

ss -lntp | grep 3306

👉 If nothing shows → DB is **not running / not listening**

---

## 🔌 Step 2: Check connectivity from same machine

nc -zv localhost 3306

👉 Output:

- `open` ✅ → Port is reachable
- `connection refused` ❌ → Service down
- `timed out` ❌ → Firewall / network issue

---

## 🌐 Step 3: Check from another container / server

nc -zv mysql 3306

👉 This is where most microservice failures happen.

---

## 🐳 Step 4: Docker-specific checks

### Check running containers

docker ps

### Check port mapping

docker port <container>

### Common mistake:

ports:  
  - "3306:3306"

BUT app connects to:

localhost:3306 ❌

👉 Inside Docker, use:

mysql:3306 ✅

---

## ☁️ Step 5: AWS / Cloud debugging

### Check Security Group

- Inbound rule must allow:

3306 (MySQL)  
6379 (Redis)  
27017 (MongoDB)

### Check binding

DB must listen on:

0.0.0.0  ❗ (not 127.0.0.1)

---

## 🚨 Step 6: Identify exact failure type

|Error Message|Meaning|Root Cause|
|---|---|---|
|connection refused|Service not running|DB crashed / not started|
|timeout|Network blocked|Security group / firewall|
|access denied|Auth issue|Wrong username/password|
|unknown host|DNS issue|Service name wrong|

---

## 🧠 Real Production Thinking (THIS is your edge)

When something fails:

👉 Don’t jump to logs immediately  
👉 First ask:

1. **Is service running?**
2. **Is port open?**
3. **Is network reachable?**
4. **Is DNS resolving?**
5. **Then check logs**

---

## 🔥 Real Example (Your kind of scenario)

You saw:

Communications link failure (MySQL)

👉 Your thought process should be:

- Check MySQL container running?
- Check port 3306 listening?
- Try:
    
    nc -zv mysql 3306
    
- If fail → network / container issue
- If success → credentials / config issue

---

## ⚡ Interview Gold Line

Say this confidently:

> “When debugging DB connectivity, I first validate port-level reachability using nc/ss before jumping into logs. It helps isolate infra vs application issues quickly.”

---

If you want next level 🚀  
I can simulate a **real production outage scenario (Redis/MySQL down)** and make you debug it step-by-step like an SRE.