when u want the cmds to be executing even when the window/terminal is closed

### `nohup` (No Hang Up)

Runs a command even after you log out or close the terminal.

```
nohup terraform apply > output.log 2>&1 &
```

- Survives SSH disconnect
- Output goes to `nohup.out` (or specified file)
- Best for simple long-running jobs

Check:

```
ps -ef | grep terraform
```

---

### `screen`

Creates a detachable terminal session.

Start:

```
screen
```

Run your command:

```
terraform apply
```

Detach:

```
Ctrl+A D
```

Reattach later:

```
screen -r
```

- Multiple sessions possible
- Session keeps running after logout
- Older but still widely used

List sessions:

```
screen -ls
```

---

### `tmux`

Modern alternative to `screen`.

Start:

```
tmux
```

Run command:

```
terraform apply
```

Detach:

```
Ctrl+B D
```

Reattach:

```
tmux attach
```

List sessions:

```
tmux ls
```

Advantages:

- Multiple windows
- Split panes
- Better session management
- Preferred by many DevOps engineers

---

### Quick Comparison

|Tool|Keeps Process Running After Logout|Reattach Later|Multiple Windows|
|---|---|---|---|
|`nohup`|✅|❌|❌|
|`screen`|✅|✅|✅|
|`tmux`|✅|✅|✅|

For a one-off long command:

```
nohup terraform apply &
```

For daily DevOps work on servers:

```
tmux
```

is usually the most flexible choice.