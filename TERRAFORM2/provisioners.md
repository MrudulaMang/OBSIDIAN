7. Provisioners Are Not Idempotent

If apply runs again:

- commands may rerun
- package install repeats
- scripts may behave inconsistently

Terraform provisioners are weaker for configuration management than:

- Ansible
- cloud-init
- baked AMIs

8. SSH Dependency Problem

This approach depends on:

- SSH connectivity
- keys
- runtime shell execution

In enterprise systems, userdata/cloud-init is usually preferred because:

- executes at boot
- no SSH required
- more reproducible

Example alternative:

```
user_data = <<-EOF#!/bin/bashyum install -y nginxsystemctl enable nginxsystemctl start nginxEOF
```

This is often cleaner than `remote-exec`.

So the code is valid for learning/demo purposes, but operationally it has several hidden dependencies:

- OS type
- SSH access
- networking
- timing
- package manager
- boot state
- key management

Those are the real things engineers debug in production.![[{15DCADBA-8797-4E64-B951-12C46D8D3BC1}.png]]

![[{680EAC8A-F97F-4241-A6C6-C65938FE029D}.png]]

![[{92B7E8FC-44C6-43F5-908F-134FBE328F8A}.png]]![[{E85C01DF-F845-4DB1-8F92-489ADEA51382}.png]]