POST
One question that changed how I look at production incidents:

When observability tools show a problem…  
**where do we actually investigate the real issue?**

Monitoring platforms — Grafana, CloudWatch, Datadog, Prometheus — are excellent at detecting symptoms:

🚨 Load Average increasing  
🚨 Latency rising  
🚨 Error rates growing

But observability answers only one question:

**“When did something go wrong?”**

It rarely answers:  
**“Why is the system struggling?”**

Because applications ultimately run as **Linux processes**, the real investigation almost always moves to the operating system.

A typical incident flow looks like this:

Alert fires → Dashboard review → SSH into server → Linux investigation

Once inside the system, the focus shifts from metrics to behavior:

• Are processes competing for CPU?  
• Are they blocked waiting for disk I/O?  
• Is storage latency causing uninterruptible waits?  
• What exactly are processes waiting on?

Commands like:  
`top`  
`vmstat`  
`iostat -x`  
`ps aux`

start revealing what dashboards cannot — **resource pressure at process level**.

A system can show low CPU utilization and still be unhealthy if processes are stuck in I/O wait (D state), silently increasing load average and application latency.

This was a major mindset shift for me:

Observability detects.  
Linux explains.

Real troubleshooting begins when we stop looking only at graphs and start understanding how the operating system schedules, waits, and manages processes under pressure.

Tools raise alerts.  
Systems thinking finds root cause.
---------------------------
posted half part  feb 3rd 2026 6.23pm


🔥 Strategic Branding Insight (important for you)

🔥 Post #4 — Metrics vs Reality: When Dashboards Lie

	Dashboards rarely lie intentionally.
	
	But they don’t always tell the full truth either.
	
	During a recent production incident, monitoring looked reassuring at first glance:
	
	CPU utilization — normal  
	Memory usage — stable  
	Network traffic — expected range
	
	Yet users were reporting slow responses and intermittent timeouts.
	
	From the dashboard perspective, nothing appeared critically wrong.
	
	After logging into the server, the reality was different.
	
	Load average was steadily rising.
	
	Multiple application processes were stuck in **D state**, waiting on disk I/O. The CPUs were mostly idle — not because the system was healthy, but because processes were blocked waiting for storage operations to complete.
	
	The dashboard showed utilization.
	
	Linux revealed waiting.
	
	This is an important distinction:
	
	Metrics summarize resource usage.  
	Operating systems expose resource contention.
	
	A system can look healthy in aggregated graphs while internally accumulating pressure — queues growing, processes blocking, latency spreading across services.
	
	Dashboards are essential for detection.
	
	But real debugging often begins when you move from charts to process-level observation:
	
	`top`  
	`vmstat`  
	`iostat`  
	`ps`
	
	Because outages don’t always announce themselves through spikes.
	
	Sometimes, systems fail quietly while metrics still look acceptable.
	
	Understanding the gap between metrics and reality is where monitoring turns into systems engineering.
------------------------------------------------------------
commandS for the above post make it multiple  posts
Here is your **SSH → Production Debugging commands** rewritten cleanly in **bullet format** (perfect companion to your LinkedIn post or personal playbook).

---



---

## 🌐 Network / NFS Delays

**Requests hanging or timing out**

- `ss -tulpn` → Active listening services
    
- `netstat -an | grep ESTABLISHED` → Connection buildup
    
- `nfsstat` → NFS performance stats
    
- `ping <dependency>` → Connectivity check
    
- `traceroute <service>` → Network path latency
    

---

## 🔒 Application-Level Locks

**CPU low but application frozen**

- `ps aux | grep <app>` → Process status
    
- `strace -p <PID>` → System call waiting analysis
    
- `lsof -p <PID>` → Open files & locks
    

---

## 🚨 Universal First 5 Commands (Real SRE Habit)

Most production debugging begins with:

- `uptime`
    
- `top`
    
- `vmstat 1`
    
- `iostat -x 1`
    
- `free -m`
    

These alone explain **majority of production slowdowns**.

---

## 🧠 Core Insight

- 📊 Monitoring tells you **something is wrong**
    
- 🧩 Linux tells you **why it is wrong**
    

Sometimes real observability still begins with:

ssh production-server
------------



NOTES
Next post options (choose one):

**A)** _Why High Load Average With Low CPU Confuses Teams_  
**B)** _Reading vmstat Like an SRE During Incidents_  
**C)** _How Production Outages Actually Start (Slowly)_  
**D)** _Metrics vs Reality: When Dashboards Lie_
---------------------------------------------------------------------------
-----------------------------------------------------
###### If you want, I can also show you **a 12-post SSH Diaries roadmap** that gradually moves from **basic debugging → real production incident analysis**. It will make your LinkedIn look like a **systems engineer journal**, which recruiters love.
---------------------------------------
**==ALL DEBUG COMMANDS CATEGORIZED==**
# System Overview / Quick Health Check

uptime  
hostname  
uname -a  
date  
who  
w  
last  
history

---

# CPU Investigation

top  
htop  
uptime  
mpstat  
lscpu  
ps aux --sort=-%cpu  
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu

---
# Memory Investigation


free -m  
vmstat  
cat /proc/meminfo  
ps aux --sort=-%mem  
pmap <pid>  
smem
---
______________________
# Disk Space & Filesystem
_________________________-

df -h  
df -i  
du -sh *  
du -ah / | sort -rh | head -20  
lsblk  
blkid  
mount
---
# Disk I/O Investigation
iostat  
iotop  
vmstat 1  
dstat  
sar -d
---
# Process Investigation
ps aux  
ps -ef  
pstree  
pgrep <process_name>  
pidof <process_name>  
top  
htop  
kill <pid>  
kill -9 <pid>  
nice  
renice
---
# Network Investigation
netstat -tulpn  
ss -tuln  
ss -s  
ss -tp  
ip a  
ip addr  
ip route  
ifconfig
--
# Network Connectivity Testing
ping <host>  
traceroute <host>  
mtr <host>  
curl <url>  
wget <url>  
telnet <host> <port>  
nc -zv <host> <port>
--
# Port & Socket Investigation
netstat -an  
ss -an  
ss -lnt  
ss -lup  
lsof -i  
lsof -i :80  
lsof -iTCP  
lsof -iUDP
---
# Log Investigation
tail -f /var/log/syslog  
tail -f /var/log/messages  
journalctl -xe  
journalctl -u <service_name>  
journalctl -f  
less /var/log/syslog  
grep ERROR /var/log/syslog
---
# System Performance & Resource Pressure
vmstat  
sar  
dmesg  
dmesg -T  
uptime
---
# Service & Systemd Investigation
systemctl status <service>  
systemctl restart <service>  
systemctl start <service>  
systemctl stop <service>  
systemctl list-units --type=service  
systemctl list-units --failed  
service <service_name> status
--
# File & Directory Investigation
ls -lh  
ls -ltr  
stat <file>  
file <file>  
find / -name <filename>  
find / -size +100M  
locate <file>
---
# Open Files Investigation
lsof  
lsof -p <pid>  
lsof /path/to/file
---
# User & Permission Investigation
id  
whoami  
groups  
getent passwd  
getent group
---
# Package & Software Check
rpm -qa  
dpkg -l  
apt list --installed  
yum list installed
---
# Kernel & Hardware Info
uname -a  
lsmod  
lshw  
lsusb  
lspci
---
# Useful Quick Checks During Incidents
hostname  
uname -a  
date  
uptime  
who  
w  
history
---

# Common SSH Incident Quick Check Sequence
Many engineers quickly run a small sequence like this immediately after logging into a server:
uptime  
top  
free -m  
df -h  
ps aux --sort=-%cpu | head  
ps aux --sort=-%mem | head  
ss -tuln  
journalctl -xe
---
# Advanced Debugging Commands
strace -p <pid>  
watch -n 1 <command>  
timeout 5 <command>  
time <command>

# Very Common Commands Used During Production Incidents
top  
htop  
free -m  
df -h  
du -sh *  
ps aux  
ss -tuln  
netstat -tulpn  
journalctl -xe  
tail -f /var/log/syslog  
iostat  
vmstat