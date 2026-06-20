
|Category|Commands|
|---|---|
|User Management|`whoami`, `id`, `who`, `w`, `last`, `passwd`, `su`, `sudo`, `groups`, `useradd`, `usermod`, `userdel`, `groupadd`, `groupdel`, `chage`|
|File & Directory|`pwd`, `ls`, `cd`, `mkdir`, `rmdir`, `touch`, `cp`, `mv`, `rm`, `find`, `locate`, `tree`, `stat`, `file`|
|File Viewing|`cat`, `less`, `more`, `head`, `tail`, `tail -f`, `nl`|
|Text Processing|`grep`, `egrep`, `awk`, `sed`, `sort`, `uniq`, `cut`, `tr`, `wc`, `xargs`|
|Permissions|`chmod`, `chown`, `chgrp`, `umask`, `getfacl`, `setfacl`|
|Process Management|`ps`, `top`, `htop`, `pgrep`, `pidof`, `pstree`, `kill`, `killall`, `pkill`, `nice`, `renice`, `jobs`, `bg`, `fg`, `nohup`|
|Service Management|`systemctl`, `service`, `journalctl`|
|Memory Analysis|`free`, `vmstat`, `top`, `cat /proc/meminfo`|
|CPU Analysis|`top`, `htop`, `uptime`, `mpstat`, `sar`, `vmstat`|
|Disk Usage|`df`, `du`, `lsblk`, `blkid`, `mount`, `umount`|
|Disk Partitioning|`fdisk`, `parted`, `growpart`, `mkfs`, `fsck`, `resize2fs`, `xfs_growfs`|
|Networking|`ip`, `ifconfig`, `ping`, `traceroute`, `tracepath`, `arp`, `route`|
|Port Investigation|`ss`, `netstat`, `lsof`, `fuser`|
|DNS Troubleshooting|`dig`, `nslookup`, `host`, `resolvectl`|
|Packet Capture|`tcpdump`, `tshark`|
|Log Analysis|`journalctl`, `grep`, `tail`, `less`, `awk`, `sed`|
|Package Management (RHEL/Amazon Linux)|`yum`, `dnf`, `rpm`|
|Package Management (Ubuntu)|`apt`, `apt-get`, `dpkg`|
|Archives & Compression|`tar`, `gzip`, `gunzip`, `zip`, `unzip`, `xz`|
|SSH & Remote Access|`ssh`, `scp`, `sftp`, `ssh-keygen`, `ssh-copy-id`|
|Scheduling|`crontab`, `at`, `systemctl list-timers`|
|Environment Variables|`env`, `printenv`, `export`, `unset`|
|Storage & Filesystems|`mount`, `umount`, `lsblk`, `blkid`, `df`, `du`, `tune2fs`|
|Security & Audit|`sudo -l`, `last`, `lastlog`, `faillog`, `getenforce`, `sestatus`, `auditctl`, `ausearch`|
|Performance Analysis|`vmstat`, `iostat`, `sar`, `mpstat`, `pidstat`|
|Deep Debugging|`strace`, `lsof`, `dmesg`, `gdb`|
|Docker|`docker ps`, `docker images`, `docker logs`, `docker exec`, `docker inspect`, `docker stats`, `docker build`, `docker pull`, `docker push`|
|Kubernetes|`kubectl get`, `kubectl describe`, `kubectl logs`, `kubectl exec`, `kubectl top`, `kubectl apply`, `kubectl delete`|
|AWS CLI (Common)|`aws ec2`, `aws s3`, `aws iam`, `aws sts`, `aws eks`, `aws cloudformation`|
|Incident Response (First Commands)|`uptime`, `top`, `free -h`, `df -h`, `lsblk`, `ps aux`, `ss -tulpn`, `systemctl status`, `journalctl -xe`, `curl`, `dig`|

If you want a **true Production/SRE one-sheet**, I'd shrink the entire list to the **50 commands that solve 90% of real incidents**. That's the sheet senior engineers actually keep in their heads.

 *️lsof - Find which process is holding a port or file  
*️⃣ss - Inspect active network connections and listening ports  
*️⃣strace - See what a process is doing under the hood  
*️⃣tcpdump - Capture and analyze network traffic in real time  
*️⃣vmstat - Quickly identify CPU, memory, and system bottlenecks  
*️⃣ iostat - Detect storage and disk I/O issues  
*️⃣ journalctl - Investigate service failures and system events