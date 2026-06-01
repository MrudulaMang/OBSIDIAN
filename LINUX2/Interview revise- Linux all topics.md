LINUX
│
├── 1. LINUX FUNDAMENTALS
│   ├── Kernel
│   ├── Shell
│   ├── Distribution
│   ├── Filesystem Hierarchy
│   └── Boot Process
│
├── 2. FILES & DIRECTORIES
│   ├── pwd
│   ├── ls
│   ├── cd
│   ├── mkdir
│   ├── rm
│   ├── cp
│   ├── mv
│   ├── touch
│   └── find
│
├── 3. FILE VIEWING & TEXT PROCESSING
│   ├── cat
│   ├── less
│   ├── head
│   ├── tail
│   ├── grep
│   ├── awk
│   ├── sed
│   ├── cut
│   ├── sort
│   ├── uniq
│   └── wc
│
├── 4. USERS & GROUPS
│   ├── useradd
│   ├── usermod
│   ├── passwd
│   ├── groups
│   ├── sudo
│   ├── /etc/passwd
│   ├── /etc/shadow
│   └── /etc/group
│
├── 5. PERMISSIONS
│   ├── chmod
│   ├── chown
│   ├── chgrp
│   ├── rwx
│   ├── Numeric Permissions
│   ├── SUID
│   ├── SGID
│   └── Sticky Bit
│
├── 6. PROCESS MANAGEMENT
│   ├── ps
│   ├── top
│   ├── htop
│   ├── pgrep
│   ├── pidof
│   ├── kill
│   ├── killall
│   ├── nice
│   └── renice
│
├── 7. SERVICES & SYSTEMD
│   ├── systemctl
│   ├── start
│   ├── stop
│   ├── restart
│   ├── enable
│   ├── disable
│   ├── status
│   └── journalctl
│
├── 8. NETWORKING
│   ├── ip addr
│   ├── ip route
│   ├── ping
│   ├── traceroute
│   ├── nslookup
│   ├── dig
│   ├── netstat
│   ├── ss
│   ├── curl
│   ├── wget
│   └── tcpdump
│
├── 9. STORAGE & FILESYSTEMS
│   ├── df
│   ├── du
│   ├── lsblk
│   ├── blkid
│   ├── mount
│   ├── umount
│   ├── fdisk
│   ├── parted
│   └── Filesystems
│       ├── XFS
│       ├── EXT4
│       └── TMPFS
│
├── 10. LVM
│   ├── PV
│   ├── VG
│   ├── LV
│   ├── pvcreate
│   ├── vgcreate
│   ├── lvcreate
│   ├── lvextend
│   └── Filesystem Expansion
│
├── 11. PACKAGE MANAGEMENT
│   ├── yum
│   ├── dnf
│   ├── rpm
│   ├── apt
│   ├── dpkg
│   └── Repository Management
│
├── 12. LOGGING
│   ├── /var/log
│   ├── messages
│   ├── secure
│   ├── syslog
│   ├── journalctl
│   └── Application Logs
│
├── 13. BOOT PROCESS
│   ├── BIOS/UEFI
│   ├── GRUB
│   ├── Kernel
│   ├── initramfs
│   └── systemd
│
├── 14. SCHEDULING
│   ├── cron
│   ├── crontab
│   ├── at
│   └── systemd timers
│
├── 15. ARCHIVES & COMPRESSION
│   ├── tar
│   ├── gzip
│   ├── gunzip
│   ├── zip
│   └── unzip
│
├── 16. SSH
│   ├── ssh
│   ├── scp
│   ├── sftp
│   ├── ssh-keygen
│   ├── authorized_keys
│   └── SSH Troubleshooting
│
├── 17. SECURITY
│   ├── SELinux
│   ├── Firewall
│   ├── sudoers
│   ├── PAM
│   └── Hardening Basics
│
├── 18. PERFORMANCE & TROUBLESHOOTING
│   ├── CPU Issues
│   ├── Memory Issues
│   ├── Disk Issues
│   ├── Network Issues
│   ├── iostat
│   ├── vmstat
│   ├── free
│   ├── sar
│   ├── lsof
│   └── strace
│
└── 19. REAL-WORLD TROUBLESHOOTING
    ├── Disk Full
    ├── Service Down
    ├── High CPU
    ├── High Memory
    ├── Port Not Listening
    ├── DNS Failure
    ├── SSH Failure
    ├── Filesystem Full
    ├── Log Explosion
    └── Application Slow

--------------------------------------------
LINUX TROUBLESHOOTING
│
├── CPU ISSUES
│   ├── Server CPU at 100%
│   ├── Load Average Increasing
│   ├── One Process Consuming CPU
│   ├── Runaway Java Process
│   ├── Fork Bomb
│   ├── Zombie Processes
│   ├── High System CPU
│   └── High IOWait
│
├── MEMORY ISSUES
│   ├── Server Out Of Memory
│   ├── OOM Killer Triggered
│   ├── Memory Leak
│   ├── Swap Usage Increasing
│   ├── Java Heap Full
│   ├── Cache Consuming RAM
│   └── Process Memory Growth
│
├── DISK ISSUES
│   ├── Root Filesystem Full
│   ├── /var Full
│   ├── Log Explosion
│   ├── Deleted File Still Holding Space
│   ├── Inode Exhaustion
│   ├── Disk Read Latency High
│   ├── Disk Write Latency High
│   └── Filesystem Corruption
│
├── NETWORK ISSUES
│   ├── Cannot Reach Internet
│   ├── Cannot Reach Internal Server
│   ├── Packet Loss
│   ├── High Latency
│   ├── Routing Issue
│   ├── MTU Mismatch
│   ├── Firewall Blocking Traffic
│   └── Interface Down
│
├── DNS ISSUES
│   ├── DNS Lookup Failure
│   ├── Slow DNS Resolution
│   ├── Wrong DNS Record
│   ├── Internal DNS Failure
│   ├── Resolver Misconfiguration
│   └── Intermittent DNS Failure
│
├── SSH ISSUES
│   ├── SSH Connection Refused
│   ├── SSH Timeout
│   ├── Permission Denied
│   ├── Key Authentication Failure
│   ├── Bastion Connectivity Issue
│   ├── Security Group Blocking
│   └── SSH Service Down
│
├── PROCESS ISSUES
│   ├── Process Not Starting
│   ├── Process Keeps Crashing
│   ├── Process Hung
│   ├── High CPU Process
│   ├── High Memory Process
│   ├── Defunct Process
│   └── Too Many Processes
│
├── SYSTEMD / SERVICE ISSUES
│   ├── Service Failed To Start
│   ├── Service Restart Loop
│   ├── Service Dependency Failure
│   ├── Port Already In Use
│   ├── Wrong Startup Order
│   └── Service Starts Manually But Not At Boot
│
├── STORAGE & LVM
│   ├── Need To Extend Filesystem
│   ├── New Disk Not Visible
│   ├── VG Full
│   ├── LV Full
│   ├── Mount Failure
│   ├── Wrong fstab Entry
│   └── Filesystem Resize Failure
│
├── SECURITY ISSUES
│   ├── Permission Denied Error
│   ├── Sudo Not Working
│   ├── SELinux Blocking Access
│   ├── Incorrect Ownership
│   ├── File Access Failure
│   ├── User Locked Out
│   └── Privilege Escalation Issue
│
├── PACKAGE ISSUES
│   ├── Package Install Failure
│   ├── Dependency Conflict
│   ├── Repository Unreachable
│   ├── GPG Key Error
│   ├── Package Downgrade
│   └── Version Mismatch
│
├── LOGGING ISSUES
│   ├── Logs Missing
│   ├── Logs Growing Too Fast
│   ├── Log Rotation Failure
│   ├── Journalctl Full
│   ├── Application Logs Missing
│   └── Log Permission Issue
│
├── BOOT ISSUES
│   ├── Server Not Booting
│   ├── Kernel Panic
│   ├── GRUB Corruption
│   ├── Emergency Mode
│   ├── Filesystem Check Failure
│   └── Boot Loop
│
├── APPLICATION ISSUES
│   ├── Application Slow
│   ├── Application Down
│   ├── Port Not Listening
│   ├── Database Connectivity Failure
│   ├── File Permission Error
│   ├── Dependency Service Down
│   └── Configuration Error
│
└── REAL PRODUCTION INCIDENTS
    ├── Website Down
    ├── API Returning 500 Errors
    ├── EC2 Reachable But App Unreachable
    ├── Disk Filled Overnight
    ├── Login Failures Across Servers
    ├── Batch Job Suddenly Slow
    ├── High CPU After Deployment
    ├── High Memory After Release
    ├── DNS Outage
    ├── NFS Mount Failure
    ├── Service Not Starting After Reboot
    ├── Certificate Expired
    ├── Cron Job Not Running
    ├── Server Reachable But Port Closed
    ├── Database Server Full
    ├── Unexpected Reboots
    ├── Network Latency Spike
    ├── Application Timeout
    ├── Load Balancer Health Check Failure
    └── Complete Production Outage
