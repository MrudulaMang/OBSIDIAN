POSTS

----------------------------
***********
------------------------------------------

NOTES

Kubernetes **does NOT create containers**.

Linux does.

Kubernetes only tells Linux:

> “Run this process with limits and isolation.”

---

## ✅ 1. Namespaces → Isolation (WHO can see WHAT)

Linux **namespaces** make containers feel separate.

Example:

|Namespace|What it isolates|
|---|---|
|PID|processes|
|NET|network|
|MNT|filesystem|
|IPC|communication|
|UTS|hostname|

So inside a Pod:

ps aux

You see only pod processes.

But actually → same Linux machine.

✅ Isolation illusion.

---

## ✅ 2. cgroups → Resource Control (HOW MUCH you can use)

When you write in K8s:

resources:  
  limits:  
    cpu: 1  
    memory: 512Mi

Kubernetes converts this into:

👉 **Linux cgroups**

Linux kernel enforces:

- CPU limit
    
- Memory limit
    
- I/O limit
    

If memory exceeds →  
💥 Linux kills process → `OOMKilled`

Not Kubernetes.

---

## ✅ 3. Pod = Just Linux Processes

Reality:

Pod  
 ├── container process  
 ├── pause container  
 └── shared namespaces

Check on node:

ps -ef | grep containerd

You’ll literally see container processes.

---

## ✅ 4. Flow (MOST IMPORTANT)

kubectl apply  
      ↓  
kubelet  
      ↓  
containerd  
      ↓  
Linux namespaces + cgroups  
      ↓  
Process runs

Kubernetes = orchestrator  
Linux = executor

---

## ⚡ Golden One-Line Understanding

> **A container is just a Linux process with namespaces + cgroups.**

---

Next powerful step (2-minute concept):

👉 **Why every Kubernetes engineer must understand Load Average inside nodes**
------
Next powerful step (recommended):

👉 **How DNS works inside Kubernetes**  
👉 **Why CoreDNS crashes bring entire clusters down**  
👉 **Real DNS debugging during pod crash**

Shall we go there next?