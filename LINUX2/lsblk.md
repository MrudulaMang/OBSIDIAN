`lsblk` stands for:

- **ls** → List
- **blk** → Block devices

So, `lsblk` means **List Block Devices**.

A **block device** is a storage device that stores data in fixed-size blocks, such as:

- Hard disks (HDD)
- SSDs
- NVMe drives
- USB drives
- Partitions

### Syntax

```
lsblk
```

### Example output

```
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTxvda      202:0  0   20G  0 disk├─xvda1   202:1  0    1G  0 part /boot└─xvda2   202:2  0   19G  0 part /
```

### Understanding the output

|Column|Meaning|
|---|---|
|**NAME**|Disk or partition name|
|**SIZE**|Size of the disk/partition|
|**TYPE**|`disk`, `part` (partition), `lvm`, etc.|
|**MOUNTPOINT**|Where it is mounted in the filesystem|

In the example:

- `xvda` → The entire disk (20 GB)
- `xvda1` → First partition, mounted at `/boot`
- `xvda2` → Second partition, mounted at `/`

### Why DevOps engineers use `lsblk`

- Check whether a new EBS volume is attached.
- Identify disk and partition names before formatting or mounting.
- Verify disk layout during troubleshooting.
- Confirm storage changes after resizing an EC2 volume.

### Common options

Show filesystem information:

```
lsblk -f
```

Example output:

```
NAME    FSTYPE LABEL UUID                                 MOUNTPOINTxvda1   xfs          a1b2-c3d4                            /bootxvda2   xfs          e5f6-g7h8                            /
```

Show disk sizes in bytes:

```
lsblk -b
```

Show only specific columns:

```
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
```

### Interview answer

> `lsblk` is a Linux command used to list all block storage devices, such as disks, partitions, and LVM volumes. It helps identify storage devices, their sizes, types, and mount points, and is commonly used when attaching or managing disks on Linux servers.