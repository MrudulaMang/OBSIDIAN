Instance tenancy determines **whether your EC2 instances run on hardware shared with other AWS customers or on hardware dedicated to your account.**

There are three tenancy options:

|Tenancy|Description|
|---|---|
|Default|Shared AWS hardware (most common)|
|Dedicated Instance|Dedicated hardware for your account, but AWS manages placement|
|Dedicated Host|Entire physical server allocated to your account|

Visualize it like an apartment building:

```
Default Tenancy----------------Server A├─ Customer X├─ Customer Y├─ You└─ Customer Z
```

```
Dedicated Instance----------------Server B├─ You├─ You├─ You└─ You
```

No other AWS customers share that hardware.

```
Dedicated Host----------------Physical Server├─ Your EC2├─ Your EC2├─ Your EC2└─ Full control of placement
```

You get visibility into the host and can place instances on specific hosts.

### Default Tenancy

This is what almost everyone uses.

Benefits:

- Cheapest
- Fully managed
- Suitable for most workloads

### Dedicated Instance

Used when:

- Compliance requires hardware isolation.
- Regulatory requirements prohibit shared hardware.

AWS guarantees that no other customer shares the underlying host.

### Dedicated Host

Used when:

- You have software licenses tied to physical CPUs or sockets.
- Examples include certain licensing models for:
    - Oracle Database
    - Microsoft Windows Server
    - SQL Server

Benefits:

- Visibility into physical host.
- Host-level placement control.
- License compliance.

### Where is tenancy configured?

At the VPC level:

```
DefaultDedicated
```

and also during EC2 launch:

```
DefaultDedicated InstanceDedicated Host
```

### Interview Question

**Q: Does Dedicated Instance mean a dedicated EC2 instance?**

No.

It means the **underlying physical host is dedicated to your AWS account**. You may still have multiple EC2 instances from your account sharing that host.

### Cost Perspective

```
Default Tenancy           Lowest Cost
Dedicated Instance        Higher Cost
Dedicated Host            Highest Cost
```

For most cloud-native applications, Kubernetes clusters, DevOps projects, and general AWS workloads, **Default Tenancy** is the standard choice. Dedicated options are usually driven by compliance, security policies, or software licensing requirements rather than technical necessity.