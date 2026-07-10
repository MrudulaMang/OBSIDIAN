### LVM and Filesystem Summary

#### Storage hierarchy

```
Disk
│
└── Physical Volume (PV)
    │
    └── Volume Group (VG) - RootVG
        │
        ├── Logical Volume (LV) - rootVol
        ├── Logical Volume (LV) - homeVol
        └── Logical Volume (LV) - varVol
```

Each **Logical Volume (LV)** usually contains **one filesystem**.

Example:

```
/dev/mapper/RootVG-homeVol
        │
        ▼
   XFS Filesystem
        │
        ▼
 Mounted at /home
```

---

### Difference between the commands

#### 1. Extend the Logical Volume

```
lvextend -L+30G /dev/mapper/RootVG-homeVol
```

- Operates on the **Logical Volume (LV)**.
- `/dev/mapper/RootVG-homeVol` is the **block device**.
- Increases the storage size of the LV.
- Does **not** automatically expand the filesystem (unless `-r` is used).

---

#### 2. Extend the Filesystem (XFS)

```
xfs_growfs /home
```

- Operates on the **filesystem**.
- `/home` is the **mount point**.
- Expands the XFS filesystem to use the newly available space.
- XFS uses the **mounted filesystem**, so you provide the mount point rather than the device.

---

### What does `-r` do?

```
lvextend -r -L+30G /dev/mapper/RootVG-homeVol
```

`-r` means **resize the filesystem automatically** after extending the LV.

Internally it performs:

```
lvextend -L+30G /dev/mapper/RootVG-homeVol
xfs_growfs /home
```

So if you use `-r`, you **do not need** to run `xfs_growfs` separately.

---

### How many filesystems are in `/dev/mapper/RootVG-homeVol`?

**One.**

```
/dev/mapper/RootVG-homeVol
        │
        ▼
     One XFS Filesystem
        │
        ▼
      Mounted at /home
```

Inside that filesystem, there can be many directories and files:

```
/home
├── user1
├── user2
├── Documents
└── Downloads
```

These are **directories**, **not** separate filesystems.

---

### Example with multiple Logical Volumes

```
RootVG
├── rootVol  → XFS → /
├── homeVol  → XFS → /home
├── varVol   → XFS → /var
└── optVol   → XFS → /opt
```

- **4 Logical Volumes**
- **4 Filesystems**
- **4 Mount Points**

---

### Key points to remember

- **PV (Physical Volume):** Created from a disk or partition.
- **VG (Volume Group):** Pool of storage created from one or more PVs.
- **LV (Logical Volume):** Virtual partition created from the VG.
- **Filesystem (XFS/ext4):** Created on an LV.
- **Mount Point:** Directory where the filesystem is accessible (e.g., `/home`, `/var`, `/`).

**Rule of thumb:**

> **One Logical Volume → One Filesystem → One Mount Point**

This is the standard layout used in most Linux systems.

-------------------------------
growpart /dev/nvme0n1 4
lvextend -r -L+30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

Why these:

1. `/` (`rootVol`)

Holds:

- OS binaries
- system libraries
- configs
- package manager metadata
- boot-critical files

If `/` fills:

- yum/apt breaks
- services fail
- system updates fail
- sometimes boot/recovery becomes painful

This is operationally dangerous.

---

2. `/var` (`varVol`)
		The **contents** of `/var` often have **varying volume** (for example, log files grow and shrink), but the **name** `/var` is an abbreviation of **variable**, not **varying volum**
		or 
		**`/var` = Variable data** → data that changes over time, and therefore its **volume (size)** often changes as well.
    
    `/var/log` → Log files **vary in size**.
- `/var/cache` → Cache files **vary** as applications run.
- `/var/spool` → Print/mail queues **vary** as jobs are added and removed.

Holds:

- logs (`/var/log`)
- Docker data (sometimes)
- package cache
- application temp data
- databases in some setups
- spool files

This is the most common “disk full” culprit.

Especially in DevOps:

- Jenkins logs
- container layers
- SonarQube data
- CI artifacts

Usually `/var` dies first.

---

3. `/home` (`homeVol`)

Holds:

- user files
- developer workspace
- scripts
- SSH configs
- project files

Less critical than `/var`, but can still block work.

---

Why not extend everything?

Because:

### Storage is finite

Blindly extending all LVs is lazy engineering.

Ask first:

```
df -hvgslvs
```

Which filesystem is actually full?

Then extend only that.

---

Bad engineer:

“Add 100GB everywhere.”

Good engineer:

“Which mount is the bottleneck and why?”

---

Even sharper question:

Why is `/var` full?

Logs?  
Docker?  
Jenkins?  
Artifacts?  
Bad rotation?

If you only extend and never ask that, you are hiding a production problem, not solving it.

--------------------------
Think of it in Windows terms:

|Linux Command|Windows Equivalent|What it does|
|---|---|---|
|`growpart /dev/nvme0n1 4`|**Disk Management → Extend Partition**|Makes the disk partition larger by using unallocated space.|
|`lvextend -r -L+30G /dev/mapper/RootVG-homeVol`|**Extend a Windows Volume (C:, D:)**|Increases the size of the logical volume by **30 GB**. The `-r` option also resizes the filesystem automatically.|
|`xfs_growfs /home`|**NTFS automatically using new partition space** (or a filesystem resize tool)|Makes the XFS filesystem use the newly added space.|

A simple analogy:

```
Disk (SSD)
└── Partition (growpart)      ← Like making the partition bigger in Disk Management.
    └── Logical Volume (lvextend)  ← Like extending a Windows volume.
        └── Filesystem (xfs_growfs) ← Like NTFS recognizing and using the extra space.
```

In short:

1. **`growpart`** → Increase the **partition**.
2. **`lvextend`** → Increase the **logical drive/volume**.
3. **`xfs_growfs`** → Let the **filesystem use the new space**.

why dev and home

This is a common point of confusion. `/dev` and `/home` are completely different things.

### `/dev`

- `/dev` is a **directory that contains device files**.
- Think of it like **Device Manager** in Windows—it represents disks, partitions, USB drives, etc.
- Example:
    
    ```
    /dev/nvme0n1
    ```
    
    = the physical NVMe SSD.
    
    ```
    /dev/nvme0n1p4
    ```
    
    (or `growpart /dev/nvme0n1 4`)  
    = partition 4 on that SSD.
    
    ```
    /dev/mapper/RootVG-homeVol
    ```
    
    = an LVM logical volume (similar to a virtual partition).
    

### `/home`

- `/home` is a **directory (folder)** where users' personal files are stored.
- Similar to:
    
    ```
    C:\Users
    ```
    
    in Windows.
    
    For example:
    
    ```
    /home/alice
    /home/bob
    ```
    

### Why are both used?

Because they refer to different layers:

```
Physical Disk
    ↓
/dev/nvme0n1
    ↓
Partition 4
    ↓
LVM Volume (/dev/mapper/RootVG-homeVol)
    ↓
XFS Filesystem
    ↓
Mounted at /home
```

So:

- `growpart /dev/nvme0n1 4` → Work on the **disk partition**.
- `lvextend ... /dev/mapper/RootVG-homeVol` → Work on the **logical volume**.
- `xfs_growfs /home` → Work on the **mounted filesystem** (the folder where that filesystem is accessible).

A Windows analogy:

```
Physical SSD
   ↓
Disk 0, Partition 4
   ↓
Volume D:
   ↓
Accessible as D:\
```

Linux separates these concepts more explicitly:

- **`/dev/...`** = the storage device or volume.
- **`/home`** = the location where that storage is mounted and accessed by users.

why partition 4

`4` refers to the **partition number** on the disk.

For example, imagine your SSD is divided into four sections:

```
Disk: /dev/nvme0n1

Partition 1 → EFI System Partition
Partition 2 → /boot
Partition 3 → Swap
Partition 4 → LVM (contains /home, /, etc.)
```

Here, **partition 4** is the one that contains your LVM volume, so you expand **that** partition:

```
growpart /dev/nvme0n1 4
```

This means:

- `/dev/nvme0n1` = the disk
- `4` = the **4th partition** on that disk

It's equivalent to saying:

> "Extend **Partition 4** on Disk 0."

### How do you know it's partition 4?

You don't guess. You check using commands like:

```
lsblk
```

or

```
fdisk -l
```

Example output:

```
NAME         SIZE
nvme0n1      100G
├─nvme0n1p1    1G
├─nvme0n1p2    2G
├─nvme0n1p3    8G
└─nvme0n1p4   89G
```

Since the partition you want is `nvme0n1p4`, you run:

```
growpart /dev/nvme0n1 4
```

Notice that `growpart` takes:

- the **disk name** (`/dev/nvme0n1`)
- the **partition number** (`4`)

instead of the full partition name (`/dev/nvme0n1p4`).