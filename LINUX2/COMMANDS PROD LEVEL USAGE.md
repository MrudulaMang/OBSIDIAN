# Linux Production / SRE One-Sheet (50 Commands That Solve Most Incidents)

|Category|Command|Purpose|
|---|---|---|
|Identity|`whoami`|Current user|
|Identity|`id`|User/group details|
|Identity|`sudo -l`|Check sudo permissions|
|System Health|`uptime`|Load average|
|System Health|`date`|Verify system time|
|CPU|`top`|Live CPU/memory view|
|CPU|`htop`|Better process view|
|CPU|`ps aux --sort=-%cpu`|Top CPU consumers|
|CPU|`mpstat -P ALL`|CPU by core|
|Memory|`free -h`|Memory usage|
|Memory|`vmstat 1`|CPU/memory/process stats|
|Memory|`ps aux --sort=-%mem`|Top memory consumers|
|Memory|`cat /proc/meminfo`|Detailed memory info|
|Processes|`ps -ef`|Process list|
|Processes|`pgrep appname`|Find process|
|Processes|`pstree`|Process hierarchy|
|Processes|`kill -9 PID`|Kill process|
|Disk|`df -h`|Disk utilization|
|Disk|`du -sh *`|Folder sizes|
|Disk|`lsblk`|Block devices|
|Disk|`mount`|Mounted filesystems|
|Disk|`find / -size +500M`|Large files|
|Network|`ip addr`|Network interfaces|
|Network|`ip route`|Routing table|
|Network|`ping host`|Connectivity test|
|Network|`traceroute host`|Path analysis|
|Network|`curl URL`|Application connectivity|
|Ports|`ss -tulpn`|Open ports|
|Ports|`lsof -i :8080`|Process using port|
|DNS|`dig domain.com`|DNS lookup|
|DNS|`nslookup domain.com`|DNS resolution|
|Logs|`journalctl -xe`|System errors|
|Logs|`journalctl -u service`|Service logs|
|Logs|`tail -f logfile`|Live log monitoring|
|Logs|`grep ERROR logfile`|Search logs|
|Services|`systemctl status service`|Service health|
|Services|`systemctl restart service`|Restart service|
|Packages|`yum list installed`|Installed packages|
|Packages|`rpm -qa`|Package inventory|
|Files|`find / -name filename`|Locate files|
|Files|`stat file`|File metadata|
|Permissions|`ls -l`|Ownership/permissions|
|Permissions|`chmod`|Change permissions|
|Permissions|`chown`|Change ownership|
|Debugging|`strace -p PID`|Trace syscalls|
|Debugging|`lsof -p PID`|Open files by process|
|Debugging|`dmesg`|Kernel messages|
|Performance|`iostat -x 1`|Disk I/O bottlenecks|
|Performance|`sar -n DEV 1`|Network statistics|
|Security|`last`|Login history|

---

# The 15 Commands I'd Run First During a 2 AM Production Incident

```
uptimetopfree -hdf -hlsblkps aux --sort=-%cpups aux --sort=-%memss -tulpnip addrip routesystemctl status <service>journalctl -xetail -100 <logfile>curl localhost:<port>dig <domain>
```

---

# Mental Flow During Troubleshooting

```
Service Down
│
├── Is server alive?
│  ├── uptime
│  └── top
│
├── Resource issue?
│   ├── free -h
│   ├── df -h
│   └── ps aux
│
├── Service running?
│   ├── systemctl status
│   └── ps -ef
│
├── Listening on port?
│   └── ss -tulpn
│
├── Network issue?
│   ├── ping
│   ├── curl
│   └── traceroute
│
├── DNS issue?
│   └── dig
│
└── Logs
    ├── journalctl    
    └── tail -f
```

Memorize this flow, not the commands. The commands are easy to Google. The sequence of investigation is what distinguishes a production engineer from someone who simply knows Linux.p