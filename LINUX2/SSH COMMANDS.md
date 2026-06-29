ssh command to connect to remote server, list all the ways

There are multiple ways to connect to a remote Linux server using SSH, depending on how authentication is configured.

## 1. Username + Password (Interactive)

```
ssh username@server_ip
```

Example:

```
ssh ubuntu@54.210.10.20
```

SSH prompts:

```
ubuntu@54.210.10.20's password:
```

---

## 2. Username + Private Key (Most Common)

```
ssh -i private-key.pem username@server_ip
```

Example:

```
ssh -i mykey.pem ec2-user@3.85.20.10
```

AWS example:

```
ssh -i terraform.pem ec2-user@44.201.100.25
```

---

## 3. Specify a Different Port

Default SSH port is **22**.

```
ssh -p 2222 username@server_ip
```

Example:

```
ssh -p 2200 ubuntu@192.168.1.100
```

---

## 4. Private Key + Custom Port

```
ssh -i mykey.pem -p 2222 ubuntu@server_ip
```

---

## 5. Using a Hostname

Instead of an IP address:

```
ssh user@example.com
```

Example:

```
ssh ubuntu@myserver.example.com
```

---

## 6. Login Using SSH Config File

Configure `~/.ssh/config`:

```
Host prod    HostName 54.210.10.20    User ubuntu    IdentityFile ~/.ssh/prod.pem
```

Connect with:

```
ssh prod
```

Very useful when managing multiple servers.

---

## 7. Using an SSH Agent

Load the key once:

```
ssh-add ~/.ssh/id_rsa
```

Then connect without `-i`:

```
ssh ubuntu@server_ip
```

---

## 8. Execute a Single Remote Command

```
ssh ubuntu@server_ip "hostname"
```

Example:

```
ssh ubuntu@54.210.10.20 "df -h"
```

No interactive shell is opened.

---

## 9. Connect Through a Bastion (Jump) Host

```
ssh -J jumpuser@jump_host targetuser@target_host
```

Example:

```
ssh -J ec2-user@3.20.10.10 ec2-user@10.0.2.15
```

Useful when the target server is in a private subnet.

---

## 10. Using Verbose Mode (Debugging)

```
ssh -v user@server
```

More detail:

```
ssh -vv user@server
```

Maximum detail:

```
ssh -vvv user@server
```

Useful for diagnosing connection or authentication problems.

---

## 11. Disable Strict Host Key Checking

```
ssh -o StrictHostKeyChecking=no user@server
```

Often used in automation:

```
ssh -o StrictHostKeyChecking=no ubuntu@server
```

---

## 12. Specify an Alternate Identity File

```
ssh -o IdentityFile=mykey.pem ubuntu@server
```

Equivalent to:

```
ssh -i mykey.pem ubuntu@server
```

---

## 13. Specify Preferred Authentication Method

Password only:

```
ssh -o PreferredAuthentications=password user@server
```

Public key only:

```
ssh -o PreferredAuthentications=publickey user@server
```

---

## 14. Local Port Forwarding

Forward a local port to a remote service:

```
ssh -L 8080:localhost:80 ubuntu@server
```

Access the remote web server locally at:

```
http://localhost:8080
```

---

## 15. Remote Port Forwarding

Expose a local service to the remote server:

```
ssh -R 8080:localhost:3000 ubuntu@server
```

---

## 16. Dynamic Port Forwarding (SOCKS Proxy)

```
ssh -D 1080 ubuntu@server
```

Creates a SOCKS proxy on port 1080.

---

## 17. Background SSH Tunnel

```
ssh -fN -L 8080:localhost:80 ubuntu@server
```

Options:

- `-f`: Run in the background after authentication.
- `-N`: Do not execute a remote command.

---

## 18. Force Pseudo-Terminal Allocation

```
ssh -t ubuntu@server
```

Useful for running commands like `sudo` remotely.

Example:

```
ssh -t ubuntu@server "sudo systemctl restart nginx"
```

---

## 19. IPv4 or IPv6 Only

IPv4:

```
ssh -4 user@server
```

IPv6:

```
ssh -6 user@server
```

---

## 20. Connect with Compression

```
ssh -C user@server
```

Useful on slower network links.

---

### Common SSH options

|Option|Purpose|
|---|---|
|`-i key.pem`|Specify private key|
|`-p 2222`|Specify SSH port|
|`-J host`|Connect through a jump host|
|`-v`, `-vv`, `-vvv`|Enable verbose debugging|
|`-L`|Local port forwarding|
|`-R`|Remote port forwarding|
|`-D`|Dynamic (SOCKS) proxy|
|`-t`|Allocate a pseudo-terminal|
|`-C`|Enable compression|
|`-N`|Do not execute a remote command|
|`-f`|Run SSH in the background|
|`-o`|Pass additional SSH configuration options|

For DevOps interviews, the commands you'll use most often are:

```
ssh user@hostssh -i key.pem user@hostssh -p 2222 user@hostssh -J bastion_user@bastion_host target_user@target_hostssh -v user@hostssh user@host "command"ssh -L 8080:localhost:80 user@hostssh -R 8080:localhost:3000 user@hostssh -D 1080 user@hostssh -t user@host "sudo command"
```

These cover the majority of real-world administration, troubleshooting, and automation scenarios.