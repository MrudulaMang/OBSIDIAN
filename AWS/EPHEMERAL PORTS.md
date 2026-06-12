An ephemeral port is a temporary source port dynamically assigned by the operating system when a host initiates a TCP or UDP connection. The server responds to that port so the operating system can deliver the response to the correct process.

PORT RANGE 

Typical ephemeral port ranges:

| OS                                    | Default Ephemeral Range          |
| ------------------------------------- | -------------------------------- |
| Modern Linux                          | 32768–60999 (often configurable) |
| Modern Windows                        | 49152–65535                      |
| AWS documentation (for NACL examples) | 1024–65535                       |

You can check on Linux:

```
cat /proc/sys/net/ipv4/ip_local_port_range
```

Example output:

```
32768 60999
```

---------------------------------------------------------------------
Yes, the same TCP behavior happens whether you're using Security Groups or NACLs.

The packet itself always contains:

```
Source IPSource Port (ephemeral)Destination IPDestination Port (service port)
```

What differs is how AWS filters the traffic.

With Security Groups (stateful):

```
Catalogue:49152 ---> MongoDB:27017
```

You only need:

MongoDB SG:

```
Inbound TCP 27017 from Catalogue SG
```

That's it.

When MongoDB responds:

```
MongoDB:27017 ---> Catalogue:49152
```

AWS automatically allows the return traffic because Security Groups are stateful.

You do NOT need a rule for:

```
Outbound 1024-65535
```

or

```
Inbound 1024-65535
```

for the return path.

---

With NACLs (stateless):

AWS does not remember that the request was allowed.

So you must explicitly allow:

```
Catalogue -> MongoDB:27017MongoDB -> Catalogue:49152
```

which means configuring both the service port and the ephemeral port ranges.

---

A good interview statement:

> Ephemeral source ports exist regardless of Security Groups or NACLs because they are part of TCP/IP communication. The difference is that Security Groups are stateful and automatically allow return traffic, whereas NACLs are stateless and require explicit rules for both the service port and the ephemeral return ports.

	This is exactly why in AWS architectures people often keep NACLs simple and do most filtering with Security Groups. Security Groups understand connection state; NACLs do not.