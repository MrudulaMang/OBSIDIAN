Here is the complete list of commands you used in **Day-1 (CPU + Process + Memory observation)**.

---
# 🧠 System Identification

uname -a  
nproc

---

# 🔍 Process Observation

ps aux | head  
ps aux | grep python  
ps -o pid,%mem,rss,cmd -C python3  
ps -eo pid,state,comm | grep "^.* R"

---

# 🖥 CPU Monitoring

top  
uptime  
  - Current time
  - how long system has been running
  - Number of logged-in users
  - Load average (1, 5, 15 min)
vmstat 1  
vmstat 1 5

---

# 🔥 CPU Stress Simulation

yes > /dev/null &  
kill <PID>

---

# 🧠 Memory Observation

free -m  
python3 -c "a = ' ' * (500 * 1024 * 1024); input('...')"  
python3 -c "a = bytearray(500 * 1024 * 1024); input('...')"

---

# 📊 What You Practiced

- CPU usage (%CPU)
    Load = pressure indicator
    %CPU = utilization indicator
- Load average interpretation
    
- Run queue (`vmstat r`)
    
- Process states (R)
    
- RSS vs VSZ
    
- Memory allocation attempt
    python3 -c "a = ' ' * (500 * 1024 * 1024); input('Press Enter to exit...')"
     tried to observe the ram used by python3 process by using ps aux | grep "python3"
- Cause → effect correlation
- ------------------------------------------
1. What I observed about CPU saturation**  
2. How load average behaves**  
      depending upon load average u can tell the load on cpu 
      it depends on no of cpus and avg load value
      - Time-averaged value
     - Shows **average runnable processes over time**
     - 1 min, 5 min, 15 min
     - The average number of runnable (or waiting-for-CPU) processes over time.
      
3. What `vmstat r` means**  
  `vmstat r` = live traffic at signal
   if u have nroc =2 ; means u have 2 cpus 
   shows no of proccess running or waitng or qque forming
   if r =1 ; only 1 process wants cpu; 
   if r =2 
    → 2 processes want CPU  
      Both CPUs busy
   if r =3 
    → 2 running  
    → 1 waiting  
    → Queue forming
4. Difference between RSS and VSZ**   
   rss is total memory used  
   %mem is mem used by single process
 5. One thing that confused me (if any)**
6. yes > /dev/null &
      yes command continuously print letter y  and this output is sent to black hole null and the process is executed in the background by using &. to kill the process use : kill pid

## vmstat Core Metrics — Operational Reference

|Field|Meaning|Healthy Value|Warning|Critical|Indicates|
|---|---|---|---|---|---|
|**r**|Runnable processes waiting for CPU|≤ number of CPU cores|Slightly above cores|Much higher than cores|CPU contention|
|**b**|Processes blocked on I/O|0|1–2 occasional|≥2 sustained|Disk / storage bottleneck|
|**id**|CPU idle percentage|20–70%|10–20%|<10%|CPU saturation|
|**wa**|CPU time waiting for disk I/O|<5%|5–10%|>15%|Storage latency| 

***
---------------------
LEARN COMMANDS FROM ABHISHEK LINUX COMMANDS LATEST-- UNKONWN CMDS


