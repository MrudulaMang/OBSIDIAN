ok the other vpc is not mine they planbned their own , but the cidr range is same then how to connect both

Then you need a translation layer or an intermediate network design. Direct VPC peering will not work.

Common solutions in Amazon Web Services:

1. Renumber one VPC (best long-term solution)

- Change one VPC CIDR to non-overlapping range.
- Painful initially.
- Cleanest architecture later.

Example:

```
Your VPC     -> 10.0.0.0/16Their VPC    -> 10.1.0.0/16
```

Then peering works normally.

Senior architects usually prefer this if possible because every workaround adds operational complexity forever.

---

2. Use NAT between networks  
    You translate source/destination IPs.

Example:

```
Your real subnet:      10.0.1.0/24Translated as:         172.16.1.0/24
```

To the other VPC, your traffic appears from translated CIDR.

This is similar to how home routers work:

- internal private IP
- translated to another IP outside

Possible using:

- NAT instances
- firewalls
- third-party appliances
- Transit Gateway + NAT designs

But:

- more complexity
- debugging harder
- asymmetric routing risks
- logging confusion

---

3. Use PrivateLink instead of full network connectivity  
    Very common modern approach.

Instead of:

```
entire network ↔ entire network
```

Expose only a service.

Example:

- Their application exposes HTTPS service.
- You consume it privately through endpoint.

No full routing required.  
No CIDR conflict issue.

This is often the smartest solution when:

- only application access needed
- not full bidirectional infrastructure access

---

4. VPN with NAT rules  
    Site-to-site VPN appliances can perform translation.

Example:

```
Your side:10.0.0.0/16Presented to remote:172.20.0.0/16
```

Works, but operationally heavier.

---

Important mental model:

VPC peering is essentially route-table-based networking.

Routes require unique destination ranges.

If two networks claim ownership of same CIDR:

```
10.0.0.0/16
```

routing logic collapses.

That is the real issue — not AWS limitation alone, but fundamental IP routing ambiguity.

This is why network design decisions made early become architecture constraints later.