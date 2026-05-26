

![[ChatGPT Image May 26, 2026, 01_56_07 PM.png]]
difference between du and df

`df` and `du` both relate to disk usage, but they answer different questions.

Core difference:

```
df → Filesystem space usagedu → Directory/file space usage
```

Think:

```
df = "How full is the disk?"du = "What is consuming space?"
```

1. df (disk free)

Shows:

- total filesystem size
- used space
- available space
- mount points

Example:

```
df -h
```

Sample output:

```
Filesystem      Size  Used Avail Use%/dev/xvda1       20G   15G    5G  75%
```

Meaning:

- whole disk/partition information
- filesystem-level view

Used when:

- checking server disk fullness
- monitoring storage
- troubleshooting “disk full”

2. du (disk usage)

Shows:

- size consumed by files/directories

Example:

```
du -sh /var/log
```

Output:

```
2.1G /var/log
```

Meaning:

- `/var/log` directory alone uses 2.1 GB

Used when:

- identifying large directories
- cleanup analysis
- finding storage-heavy files

Very common command:

```
du -sh *
```

Shows directory-wise usage in current path.

Mental Model

```
df│└── whole filesystem capacitydu│└── specific file/directory consumption
```

Real Production Example

Problem:

```
Server alert: Disk usage 95%
```

First step:

```
df -h
```

Find which filesystem is full.

Then:

```
du -sh /*
```

Find what is consuming space.

Typical debugging flow:

```
df → identify full partitiondu → identify culprit directories/files
```

Another important nuance:

`df` can show disk full even when `du` looks smaller.

Why?

- deleted files still opened by processes
- filesystem reserved blocks
- inode exhaustion

Example:

```
Application deleted logsBut process still holds file handle
```

Disk space not freed until process restarts.

That is a classic Linux debugging scenario.
