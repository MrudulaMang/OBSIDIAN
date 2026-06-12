The packet itself contains the IP addresses and ports.
The packet arriving at MongoDB already contains:

```
Source IP   = CatalogueSource Port = 49152Dest IP     = MongoDBDest Port   = 27017
```

MongoDB receives the packet and its TCP stack knows:

> "This request came from Catalogue:49152"

So MongoDB can build a response:

```
MongoDB:27017 ---> Catalogue:49152
```

Now comes the NACL part.

Before that response packet leaves the MongoDB subnet, AWS checks the subnet's outbound NACL rules.

```
Response packet       ↓Outbound NACL check       ↓Allow ? --> SendDeny  ? --> Drop
```

********If you don't have an outbound rule allowing the destination port range (typically ephemeral ports), MongoDB still knows where to send the response, but the NACL blocks it.

Think of it this way:

```
TCP/IP stack:"I know exactly where to send the reply."NACL:"I don't care. Show me an outbound rule first."
```

So the correct statement is:

> MongoDB knows the source IP and source port from the incoming packet and can construct the response. However, because NACLs are stateless, AWS will not allow that response to leave the subnet unless an outbound NACL rule explicitly permits it.

That's why NACLs often feel like a security guard at a gate rather than part of the networking conversation itself. The hosts know where to send traffic; the NACL simply decides whether the packet is allowed to pass.

