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