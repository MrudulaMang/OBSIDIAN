SERVICE - ATTACHED TO
SG -         EC2 ENI, ALB, RDS, Lambda ENI, etc.
,NACL -    SUBNET
, WAF -     ALB, API Gateway, CloudFront, AppSync
AWS NETWORK FIREWALL -    Subnets inside a VPC (via firewall endpoints and routing)
, AWS SHEILD-    Automatically protects AWS infrastructure; enhanced protection can be associated with Elastic IPs, ALBs, CloudFront, Route 53, Global Accelerator


AWS creates a default NACL because every subnet must be associated with a Network ACL. AWS cannot leave subnets without one.

Think of it like this:

**VPC**  
→ **Subnet**  
→ **Network ACL (mandatory)**

A subnet cannot exist without an associated NACL.

The default NACL is created with very permissive rules:

- Allows all inbound traffic
- Allows all outbound traffic

So initially it doesn't block anything.

Why does AWS create it automatically?

1. Every subnet needs a NACL.
2. AWS wants new users to launch resources immediately without networking issues.
3. It provides a place where you can later add subnet-level traffic filtering.

Remember the difference:

|Security Group|NACL|
|---|---|
|Attached to EC2/ENI|Attached to Subnet|
|Stateful|Stateless|
|Allow rules only|Allow and Deny rules|
|Most commonly used|Less commonly modified|

For example:

- Security Group controls traffic to a specific EC2 instance.
- NACL controls traffic entering or leaving the entire subnet.

In real-world AWS environments, many teams leave the default NACL mostly unchanged and rely heavily on Security Groups. NACLs become useful when you want subnet-wide controls, such as blocking a specific IP range for every resource in that subnet.

So the short answer is:

**AWS creates a default NACL because every subnet must have one, and AWS wants the default network to work immediately after account creation.**

what about firewalls

AWS does not create a traditional firewall appliance by default, but it does create security controls that act as firewalls.

When you create an AWS account and use the default VPC, you get:

- Default Security Group
- Default Network ACL (NACL)

These are AWS's built-in firewall mechanisms.

**Security Group (instance-level firewall)**

- Attached to EC2 instances and network interfaces.
- Controls what traffic can reach the instance.
- Stateful.

**Network ACL (subnet-level firewall)**

- Attached to subnets.
- Controls traffic entering and leaving the subnet.
- Stateless.

Architecture:

```
Internet    |Internet Gateway    |   VPC    |  Subnet    |  NACL      <-- Subnet firewall    |   EC2    |Security Group   <-- Instance firewall
```

AWS also provides dedicated firewall services, but they are **not created automatically**:

- AWS Network Firewall
- AWS WAF
- AWS Shield

Typical usage:

- Security Group → first line of defense (used almost everywhere).
- NACL → subnet-wide filtering when needed.
- AWS WAF → protects web applications from attacks such as SQL injection and XSS.
- AWS Network Firewall → enterprise-grade network inspection and filtering.
- AWS Shield → DDoS protection.

For interviews, if someone asks, "What firewall does AWS create by default?" the most accurate answer is:

**AWS does not automatically create a dedicated firewall appliance. Instead, it provides a default Security Group and a default Network ACL in the default VPC, which serve as the primary built-in firewall controls.**

i can attache, sg for ec2, nacl for subnet but whree do i attach waf, sheild ntw firewall

Good question. These services operate at different layers.

|Service|Attached To|
|---|---|
|Security Group|EC2 ENI, ALB, RDS, Lambda ENI, etc.|
|NACL|Subnet|
|WAF|ALB, API Gateway, CloudFront, AppSync|
|Shield|Automatically protects AWS infrastructure; enhanced protection can be associated with Elastic IPs, ALBs, CloudFront, Route 53, Global Accelerator|
|Network Firewall|Subnets inside a VPC (via firewall endpoints and routing)|

For **AWS WAF**:

```
Internet   | CloudFront   |   WAF   |   ALB   |  EC2
```

or

```
Internet   |   WAF   | API Gateway
```

You associate a Web ACL with an ALB, CloudFront distribution, API Gateway, etc. You do **not** attach WAF directly to an EC2 instance or subnet.

For **AWS Shield**:

```
Internet   | AWS Shield   | CloudFront / ALB / Elastic IP
```

Shield sits in front of AWS edge infrastructure and protects against DDoS attacks. You don't deploy or attach it like a Security Group. Standard Shield is automatically active for AWS customers. Advanced Shield is enabled on specific protected resources.

For **AWS Network Firewall**:

```
Internet   | IGW   | Firewall Subnet   | Network Firewall Endpoint   | Application Subnet   | EC2
```

You create dedicated firewall subnets, deploy Network Firewall there, and then modify route tables so traffic passes through the firewall endpoints before reaching your application subnets.

A useful mental model:

```
EC2 Level        -> Security GroupSubnet Level     -> NACLVPC Traffic Path -> Network FirewallWeb Requests     -> WAFDDoS Protection  -> Shield
```

If you're learning AWS architecture, think of them as protecting different layers:

```
Internet   |Shield   |WAF   |ALB   |Network Firewall   |Subnet (NACL)   |EC2 (Security Group)
```

That's not always the exact packet path, but it's a good conceptual stack for remembering where each service fits.