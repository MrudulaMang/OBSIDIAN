

# 📘 DevOps Learning Notes — Mongo, Ansible, Debugging (Today)

---

## 🧠 1. Key Mindset Shift

- Don’t just **run scripts** → **verify systems**
    
- Think in layers:
    
    1. Infrastructure (SG, routing)
        
    2. Network (port reachable)
        
    3. OS (service running)
        
    4. Application (actually responding)
        

---

## 🔥 2. MongoDB bindIp Concept

### ❗ Problem

Mongo not reachable from other instances even though:

- Service running
    
- Port open
    

### 🔍 Cause

```yaml
bindIp: 127.0.0.1
```

👉 Only allows local connections

---

### ✅ Fix

```yaml
bindIp: 0.0.0.0
```

Restart service:

```bash
sudo systemctl restart mongod
```

---

### 🔎 Verify

```bash
ss -lntp | grep 27017
```

Expected:

```bash
0.0.0.0:27017
```

---

## 🧠 3. ss Command (Very Important)

### Command:

```bash
ss -lntp
```

### Meaning:

- `-l` → listening
    
- `-n` → numeric
    
- `-t` → TCP
    
- `-p` → process
    

### Use:

- Check if service is running
    
- Check which port is open
    
- Check which process owns it
    

---

## 🔍 4. Port Check vs Application Check

### ❌ Only Port Check (not enough)

```bash
telnet <mongo-ip> 27017
```

👉 Only checks network

---

### ✅ Application-Level Check

```bash
mongosh --eval 'db.runCommand({ ping: 1 })'
```

👉 Checks:

- Mongo running
    
- Accepting connections
    
- Responding properly
    

---

### ✅ Expected Output

```json
{ "ok" : 1 }
```

---

## 🧠 5. What is --eval

- Runs Mongo command directly
    
- No interactive shell needed
    

Example:

```bash
mongosh --eval 'db.runCommand({ ping: 1 })'
```

👉 Opens → runs → exits

---

## 🔥 6. Ansible Verification (Better than manual telnet)

### Wait for Mongo Port

```yaml
- name: Wait for MongoDB to be up
  wait_for:
    port: 27017
    host: 127.0.0.1
    timeout: 30
```

---

### Check Mongo Response

```yaml
- name: Check MongoDB is responding
  command: mongosh --eval 'db.runCommand({ ping: 1 })'
  register: mongo_status
  failed_when: "'ok' not in mongo_status.stdout"
```

---

## 🔐 7. Security Understanding

- `0.0.0.0` opens Mongo to network
    
- BUT actual control = Security Groups
    

### Best Practice:

- Allow only specific SG (like catalog)
    
- NOT `0.0.0.0/0`
    

---

## ⚠️ 8. Why remote-exec feels wrong

Even if using Ansible inside script:

Problems:

- Hard to debug
    
- Not easily repeatable
    
- Mixed responsibilities (infra + config)
    

### Better approach:

- Terraform → create infra
    
- Ansible → run separately
    

---

## 🧠 9. Debugging Flow (VERY IMPORTANT)

If catalog cannot connect to Mongo:

1. Check Security Group
    
2. Check bindIp
    
3. Check port:
    
    ```bash
    ss -lntp | grep 27017
    ```
    
4. Check network:
    
    ```bash
    telnet <mongo-ip> 27017
    ```
    
5. Check application:
    
    ```bash
    mongosh --host <mongo-ip> --eval 'db.runCommand({ ping: 1 })'
    ```
    
6. Check authentication (if enabled)
    

---

## 🔥 10. Key Takeaways

- Port open ≠ service working
    
- bindIp is a common hidden issue
    
- Always verify at application level
    
- Think in layers, not commands
    
- Automation should remove manual checks
    

---

## 🧠 Final Thought

👉 “System should prove it is working — I should not manually check”

---