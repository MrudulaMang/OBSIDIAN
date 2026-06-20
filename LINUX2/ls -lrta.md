For this line:

```
-rw-r--r--.  1 ec2-user ec2-user  492 Nov 24  2022 .bashrc
```

`ls -la` output columns are:

|Column|Value|Meaning|
|---|---|---|
|1|`-rw-r--r--.`|File type and permissions|
|2|`1`|Number of hard links|
|3|`ec2-user`|Owner of the file|
|4|`ec2-user`|Group of the file|
|5|`492`|File size in bytes|
|6|`Nov`|Month modified|
|7|`24`|Day modified|
|8|`2022`|Year modified (or time if recent)|
|9|`.bashrc`|File/directory name|

Breaking down the first column:

```
-rw-r--r--.
```

### First character = File Type

|Character|Meaning|
|---|---|
|`-`|Regular file|
|`d`|Directory|
|`l`|Symbolic link|
|`c`|Character device|
|`b`|Block device|

Examples:

```
drwx------.   .ssh
```

`d` = directory

```
-rw-r--r--.   .bashrc
```

`-` = regular file

---

### Remaining 9 characters = Permissions

```
rw- r-- r--
```

Split into 3 groups:

```
Owner  Group  Others rw-    r--    r--
```

|Symbol|Meaning|
|---|---|
|r|Read|
|w|Write|
|x|Execute|
|-|Permission absent|

For `.bashrc`:

|User Type|Permission|
|---|---|
|Owner|Read + Write|
|Group|Read only|
|Others|Read only|

---

### What is the dot (`.`) at the end?

```
-rw-r--r--.
```

The trailing `.` indicates **SELinux context exists**.

You may also see:

```
-rw-r--r--+
```

The `+` means **ACLs (Access Control Lists)** are configured.

Check details:

```
ls -Z
```

or

```
getfacl filename
```

---

Example:

```
drwx------. 2 ec2-user ec2-user 29 Aug 31 2024 .ssh
```

Interpretation:

- `d` → directory
- `rwx------` → owner has full control
- nobody else has access
- owner = ec2-user
- group = ec2-user
- size = 29 bytes
- modified = Aug 31 2024
- name = `.ssh`

This directory is locked down because SSH private keys must not be accessible by other users.