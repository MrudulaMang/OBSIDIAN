# 🧠 **What is `ss`?**

👉 `ss` = **socket statistics**

It shows:

who is talking to whom (IP + PORT)

---

# 🔥 Think of it like:

👉 `ss` = **live network connections viewer**

---

# ⚡ Why it matters (DevOps/SRE)

When something fails:

- App not connecting?
- Port not listening?
- Too many connections?

👉 `ss` tells you the truth instantly

---

# 🧾 **Basic Usage**

## ✅ Show all listening ports

ss -lntp

👉 Meaning:

- `l` → listening
- `n` → numeric (no DNS)
- `t` → TCP
- `p` → process

---

## ✅ Example output

LISTEN 0 128 0.0.0.0:27017  0.0.0.0:* users:(("mongod",pid=1234))

👉 This means:

- MongoDB is listening on **27017**
- Process = `mongod`

---

# 🔍 **Check active connections**

ss -antp

👉 Shows:

- established connections

Example:

ESTAB 0 0 10.0.1.10:49152 10.0.2.20:27017

👉 This is EXACTLY what we discussed:

Catalogue:49152 → MongoDB:27017

---

# 🔥 **Filter for MongoDB**

ss -lntp | grep 27017

👉 Check if MongoDB is running

---

# 🔥 **Real Debugging Scenarios**

### 1️⃣ App can't connect

ss -lntp | grep 27017

❌ No output → MongoDB not running

---

### 2️⃣ Too many connections

ss -ant | grep 27017

👉 Count connections

---

### 3️⃣ Port conflict

ss -lntp | grep :80

👉 See who is using port 80

---

# ⚡ `ss` vs `netstat`

|Command|Status|
|---|---|
|`ss`|✅ Modern (fast)|
|`netstat`|❌ Old|