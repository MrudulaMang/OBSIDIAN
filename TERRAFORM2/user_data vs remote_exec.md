### Within a user-data script

Commands execute sequentially.

Example:

```
#!/bin/bashyum install -y nginxsystemctl start nginxecho "done"
```

Order is:

```
yum install -y nginx   ↓systemctl start nginx   ↓echo "done"
```

The second command waits for the first to finish.

---

### Difference from remote-exec

With `remote-exec`:

```
Terraform   ↓SSH into instance   ↓Run script   ↓Wait until script finishes   ↓Continue
```

Terraform knows whether the script succeeded or failed.

---

With user-data:

```
Terraform   ↓Launch EC2   ↓EC2 boots   ↓Cloud-init starts user-data
```

Terraform does **not** wait for user-data to complete.

As soon as AWS reports the EC2 instance is created, Terraform considers its job done.

So this can happen:

```
Terraform apply finished
```

while user-data is still:

```
Installing packages...Downloading dependencies...Configuring MongoDB...
```

for another 5–10 minutes.

---

### Common pitfall

Suppose:

```
resource "aws_instance" "db" {}resource "aws_route53_record" "mongo" {}
```

Terraform creates:

```
EC2 created ✔Route53 record created ✔Apply finished ✔
```

But MongoDB inside user-data may still be installing.

Terraform has no visibility into that.

---

### Another pitfall

If user-data fails:

```
yum install somethingbad_command_heresystemctl start service
```

Terraform still reports:

```
EC2 created successfully
```

because from AWS's perspective the instance exists.

To discover the failure you must inspect:

```
/var/log/cloud-init-output.log
```

or

```
journalctl -u cloud-init
```

on the instance.

---

So:

- Commands inside user-data run one after another.
- Terraform does **not** wait for user-data completion.
- Terraform does **not** automatically know if user-data failed.
- `remote-exec` is synchronous from Terraform's perspective; user-data is asynchronous from Terraform's perspective.

This distinction is one reason many teams prefer user-data for bootstrapping and reserve `remote-exec` for cases where Terraform must wait for configuration to finish before proceeding.