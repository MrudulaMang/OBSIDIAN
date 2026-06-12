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

------------------------------------------------------------------------

what will be the outbound rule in nacl for catlagoue to mongo

Assume:

```
Catalogue EC2  ---> MongoDB EC2MongoDB Port = 27017
```

When Catalogue initiates the connection:

```
Source IP   = CatalogueSource Port = 49152 (ephemeral)Dest IP     = MongoDBDest Port   = 27017
```

For the Catalogue subnet NACL:

Outbound rule must allow:

```
Destination: MongoDB subnet CIDRProtocol: TCPPort: 27017ALLOW
```

Because Catalogue is sending traffic to MongoDB's listening port 27017.

Now look at the return traffic:

```
Source IP   = MongoDBSource Port = 27017Dest IP     = CatalogueDest Port   = 49152
```

Since NACLs are stateless, the Catalogue subnet must also allow inbound return traffic:

```
Source: MongoDB subnet CIDRProtocol: TCPPort: 1024-65535 (ephemeral ports)ALLOW
```

And the MongoDB subnet NACL must allow:

Inbound:

```
Source: Catalogue subnet CIDRTCP 27017ALLOW
```

Outbound (return traffic):

```
Destination: Catalogue subnet CIDRTCP 1024-65535ALLOW
```

This is the part many people miss:

Security Groups are stateful, so only allowing 27017 inbound on MongoDB SG is usually enough.

NACLs are stateless, so you must explicitly allow:

- Request traffic (to 27017)
- Response traffic (to ephemeral ports 1024–65535)

For an interview, the concise answer is:

> Catalogue subnet outbound NACL: allow TCP 27017 to MongoDB subnet. Since NACLs are stateless, the corresponding inbound rule on the Catalogue subnet must allow ephemeral ports (1024–65535) for the return traffic from MongoDB.