In AWS, a NACL essentially **is** the subnet-level firewall.

People often say:

- Security Group = instance firewall
- NACL = subnet firewall

A more accurate view:

|Feature|Security Group|NACL|
|---|---|---|
|Attached to|ENI/EC2|Subnet|
|Stateful|Yes|No|
|Allow rules|Yes|Yes|
|Deny rules|No|Yes|
|Evaluated|All rules|Rule number order|
|Return traffic|Automatically allowed|Must be explicitly allowed|

Example:

```
Internet    |    |NACL (Subnet Boundary)    |Public Subnet    |Security Group    |EC2
```

Suppose you want to block:

```
203.0.113.50
```

With NACL:

```
Rule 100: DENY 203.0.113.50Rule 200: ALLOW 0.0.0.0/0
```

The packet is dropped before it even reaches the EC2 instance.

Security Groups cannot do this because they don't support explicit deny rules.

In practice, many AWS environments use:

- Security Groups heavily
- NACLs minimally

because Security Groups are stateful and easier to manage.

A common interview question:

**"When would you use a NACL instead of a Security Group?"**

Answers:

- Need explicit deny rules.
- Want protection at subnet level.
- Want to block a known malicious IP range before traffic reaches instances.
- Need an additional layer of defense.

Another important point:

A subnet can have only **one NACL associated at a time**, but a Security Group can be attached to many resources.

So when someone says "subnet firewall" in AWS, they are usually referring to the **Network ACL (NACL)**. There is no separate AWS service called "Subnet Firewall." The NACL fills that role.

For deeper understanding:

```
Security Group = Who can talk to this resource?NACL = What traffic is allowed into or out of this subnet?
```

That mental model works well in both interviews and troubleshooting.