# Navigate to runner diagnostics folder
cd /home/ec2-user/actions-runner/_diag

# Delete old log files
rm -f *.log

# Or delete logs older than 7 days
find /home/ec2-user/actions-runner/_diag -name "*.log" -mtime +7 -delete

  122  15/05/26 09:03:34 cd /home/ec2-user/actions-runner/_diag
  123  15/05/26 09:03:51 rm -f *.log

  126  15/05/26 09:08:20 df -h
  127  15/05/26 09:09:16 du -sh /home/ec2-user/*  | sort -rh | head -10
            686M    /home/ec2-user/actions-runner

  129  15/05/26 09:11:20 sudo du -sh /var/* | sort -rh | head -10
            405M    /var/cache
            232M    /var/log
            144M    /var/lib
            16K     /var/spool
            4.0K    /var/tmp
            0       /var/yp
            0       /var/run
            0       /var/preserve
            0       /var/opt
            0       /var/nis


  130  15/05/26 09:11:44 du -sh /home/ec2-user/actions-runner/* | sort -rh | head -10
            584M    /home/ec2-user/actions-runner/externals
            80M     /home/ec2-user/actions-runner/bin
            23M     /home/ec2-user/actions-runner/_work
            208K    /home/ec2-user/actions-runner/_diag
            8.0K    /home/ec2-user/actions-runner/svc.sh
            4.0K    /home/ec2-user/actions-runner/safe_sleep.sh
            4.0K    /home/ec2-user/actions-runner/run.sh
            4.0K    /home/ec2-user/actions-runner/run-helper.sh.template
            4.0K    /home/ec2-user/actions-runner/run-helper.sh
            4.0K    /home/ec2-user/actions-runner/run-helper.cmd.template
  131  15/05/26 09:13:28 du -h
  132  15/05/26 09:17:24 rm -f /home/ec2-user/actions-runner/actions-runner-linux-x64-2.334.0.tar.gz
            # removed to get some space ,no use of installer 
            # after installation all the actual runner binaries are already extracted into the bin/ and externals/ folders.
  133  15/05/26 09:17:35 df -h
  134  15/05/26 09:18:10 sudo du -sh /var/* | sort -rh | head -10
  135  15/05/26 09:18:28 du -sh /home/ec2-user/actions-runner/* | sort -rh | head -10
  136  15/05/26 09:19:36 du -h
  -----------------------------DISK 

CREATE FOLDER
    sudo mkdir /runner-data
MOUNT NEW DISK
    sudo mkdir /runner-data
    sudo mount /dev/nvme1n1 /runner-data
lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
    nvme1n1              259:0    0   50G  0 disk /runner-data
    nvme0n1              259:1    0   20G  0 disk
    ├─nvme0n1p1          259:2    0    1M  0 part
    ├─nvme0n1p2          259:3    0  122M  0 part /boot/efi
    ├─nvme0n1p3          259:4    0  488M  0 part /boot
    └─nvme0n1p4          259:5    0 19.4G  0 part
    ├─RootVG-rootVol   253:0    0    6G  0 lvm  /
    ├─RootVG-swapVol   253:1    0    2G  0 lvm  [SWAP]
    ├─RootVG-homeVol   253:2    0    1G  0 lvm  /home
    ├─RootVG-varVol    253:3    0    2G  0 lvm  /var
    ├─RootVG-varTmpVol 253:4    0    2G  0 lvm  /var/tmp
    ├─RootVG-logVol    253:5    0    2G  0 lvm  /var/log
    └─RootVG-auditVol  253:6    0  4.4G  0 lvm  /var/log/audit
Stop runner service
    cd /home/ec2-user/actions-runner
    sudo systemctl stop runner
MOVE RUNNER DIRECTORY
    cd ~
    cd /home/ec2-user
    sudo mv /home/ec2-user/actions-runner /runner-data/
    Now runner lives here:
        /runner-data/actions-runner    
CREATE SYMBOLIC LINK
    This avoids reconfiguration pain.
        sudo ln -s /runner-data/actions-runner /home/ec2-user/actions-runner
        Now old path still works.(When someone accesses:
                                     /home/ec2-user/actions-runner
                                  actually use:
                                     /runner-data/actions-runner)
        check
            ls -l /home/ec2-user
                total 0
            lrwxrwxrwx 1 root root 27 May 15 11:17 actions-runner -> /runner-data/actions-runner
START RUNNER AGAIN
    cd /runner-data/actions-runner
    sudo systemctl start runner    #./svc.sh start    
MAKE MOUNT PERMANENT
    Very important.
    Otherwise reboot breaks everything.
    Use:
        sudo blkid ------gives UUID of nvme1n1
        sudo vi /etc/fstab
         ------ in the last line enter this 
            UUID=c6729169-9198-46bd-9e75-384e7d0e77a1 /runner-data xfs defaults,nofail 0 2
        sudo mount -a  -> if no error then success
        df -h
            You should see:
            /dev/nvme1n1   50G   ...   /runner-data    
    Add UUID entry.                

-----------
Why this is better than LVM expansion

Because:

lower risk
faster
cleaner rollback
avoids touching root system partitions
solves actual CI/CD problem directly
Bad instinct

“/home is full → resize whole OS”

Better instinct

“What is consuming /home, and can I isolate that workload?”

That is the systems mindset you want.
------------------------
WHAT I CAN i call this whole process as

Call it what it actually is:

Migrating GitHub self-hosted runner storage to a new EBS volume

or more simply:

Moving the self-hosted runner to a separate mounted volume

What you are doing is not “partitioning” and not really “extending /home.”

You are:

attaching a new EBS volume
formatting it with XFS
mounting it
moving runner data there
optionally using a symlink to preserve the old path

That is a storage migration, not an LVM resize.

More precise names:

Runner storage migration
GitHub Actions runner disk migration
Moving runner workload off root volume
Offloading runner data to dedicated EBS storage

Bad description:

I increased disk space

Too vague.

Better description:

I moved GitHub self-hosted runner data from a full /home volume to a dedicated 50GB mounted EBS volume using XFS and symlinked the original path for compatibility.

That sounds like someone who understands systems, not someone clicking AWS buttons.

Language matters—especially in interviews.

-----------------

fstab means file system table in Linux.

It is the system file that tells Linux:

Which disks should be mounted
Where they should be mounted
How they should be mounted

Its location is:

/etc/fstab

Think of it as the boot-time storage instruction sheet.

Example
UUID=c6729169-9198-46bd-9e75-384e7d0e77a1 /runner-data xfs defaults,nofail 0 2

This tells Linux:

“When system starts, mount this disk at /runner-data using XFS.”

Without this, your manual mount disappears after reboot.

Why it matters

If you only do:

sudo mount /dev/nvme1n1 /runner-data

it works only for current session.

After reboot:

mount is gone
runner breaks
pipeline fails

because Linux forgets temporary mounts.

fstab makes it permanent.

Simple analogy
mount

temporary instruction

fstab

permanent startup rule

Common contents

Example:

UUID=xxx / xfs defaults 0 1
UUID=yyy /home xfs defaults 0 2
UUID=zzz /runner-data xfs defaults,nofail 0 2

Each line = one filesystem rule

Dangerous part

If you break /etc/fstab, the server may fail to boot properly.

That is why:

sudo mount -a

must always be tested before reboot.

Never trust.
Always verify.

In your case

You added:

/dev/nvme1n1 → /runner-data

because your GitHub runner needs persistent storage.

That is a proper infrastructure fix, not temporary cleanup.



