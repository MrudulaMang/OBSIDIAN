


VPC: 10.0.0.0/16
│
├── Public Subnets (one per AZ)
│   ├── 10.0.1.0/24  (us-east-1a) ← ALB, NAT Gateway
│   └── 10.0.2.0/24  (us-east-1b) ← ALB, NAT Gateway
│
├── App Subnets (one per AZ)
│   ├── 10.0.11.0/24 (us-east-1a) ← EC2 / ECS / Lambda
│   └── 10.0.12.0/24 (us-east-1b) ← EC2 / ECS / Lambda
│
└── Data Subnets (one per AZ)
    ├── 10.0.21.0/24 (us-east-1a) ← RDS primary
    └── 10.0.22.0/24 (us-east-1b) ← RDS standby
## CIDR Sizing Guide for AWS

|Use Case|Recommended CIDR|Usable IPs|
|---|---|---|
|Large enterprise VPC|`/16`|~65,000|
|Standard VPC|`/20`|~4,000|
|Small VPC|`/24`|251|
|Public subnet (load balancers)|`/28`|11|
|Private subnet (app servers)|`/24`|251|
|DB subnet|`/28` or `/27`|11–27|
## Step 6 — Security: NACLs vs Security Groups

Two layers of security on top of subnets:

|Feature|Security Group|Network ACL (NACL)|
|---|---|---|
|Level|Instance level|Subnet level|
|State|**Stateful** (return traffic auto-allowed)|**Stateless** (must allow both directions)|
|Rules|Allow only|Allow + Deny|
|Default|Deny all inbound|Allow all|
|Use for|Fine-grained per-resource control|Broad subnet-level blocking| 
--------------------------------------------------------------
/23
---
------------------------------------

## Full Combination Table for `/23`

---------------------------------------------------
|bit17-22|bit23|bit24|Third Octet|Fourth Octet|IP Range|
|---|---|---|---|---|---|
|000000|0|0|00000000 = 0|00000000 to 11111111|10.0.0.0 → 10.0.0.255|
|000000|0|1|00000001 = 1|00000000 to 11111111|10.0.1.0 → 10.0.1.255|


-------------------------------------
## Complete CIDR Table for IPv4

| Prefix | Locked bits | Free bits | Floor bits | Room bits | Floors | Rooms | Total IPs |
| ------ | ----------- | --------- | ---------- | --------- | ------ | ----- | --------- |
| /16    | 16          | 16        | 8          | 8         | 256    | 256   | 65,536    |
| /17    | 17          | 15        | 7          | 8         | 128    | 256   | 32,768    |
| /18    | 18          | 14        | 6          | 8         | 64     | 256   | 16,384    |
| /19    | 19          | 13        | 5          | 8         | 32     | 256   | 8,192     |
| /20    | 20          | 12        | 4          | 8         | 16     | 256   | 4,096     |
| /21    | 21          | 11        | 3          | 8         | 8      | 256   | 2,048     |
| /22    | 22          | 10        | 2          | 8         | 4      | 256   | 1,024     |
| /23    | 23          | 9         | 1          | 8         | 2      | 256   | 512       |
| /24    | 24          | 8         | 0          | 8         | 1      | 256   | 256       |
| /25    | 25          | 7         | 0          | 7         | 1      | 128   | 128       |
| /26    | 26          | 6         | 0          | 6         | 1      | 64    | 64        |
| /27    | 27          | 5         | 0          | 5         | 1      | 32    | 32        |
| /28    | 28          | 4         | 0          | 4         | 1      | 16    | 16        |
| /29    | 29          | 3         | 0          | 3         | 1      | 8     | 8         |
| /30    | 30          | 2         | 0          | 2         | 1      | 4     | 4         |
| /31    | 31          | 1         | 0          | 1         | 1      | 2     | 2         |
| /32    | 32          | 0         | 0          | 0         | 1      | 1     | 1         |
|/32|32|0|0|0|1|1|1|
-----------------------------------------------------------------------------

We’ll use the example:

172.31.18.45/20

# 1. What does `/20` mean?

IPv4 addresses have **32 bits** total.

IP address = 32 bits

`/20` means:

20 bits = network  
12 bits = host

---

# 2. Why subnet mask becomes 255.255.240.0

Each octet = **8 bits**

8 + 8 + 8 + 8 = 32 bits

Now distribute the **20 network bits**.

### First octet

8 bits → 255

### Second octet

8 bits → 255

Now we used:

8 + 8 = 16 bits

We still need **4 more bits**.

### Third octet

11110000

Binary → decimal:

128 + 64 + 32 + 16 = 240

So subnet mask becomes:

255.255.240.0

---

# 3. Why the **3rd octet matters**

Because the **partial network bits stop in the 3rd octet**.

172 . 31 . 18 . 45  
 ↑     ↑    ↑  
255   255  240

So subnet calculations happen in the **third octet**.

---

# 4. Find the subnet jump

Formula engineers use:

256 − subnet value

Third octet mask = **240**

256 − 240 = 16

So networks increase by **16**.

---

# 5. Possible subnet starts

172.31.0.0  
172.31.16.0  
172.31.32.0  
172.31.48.0

---

# 6. Where does the IP fall?

Your IP:

172.31.18.45

18 falls between:

16 and 31

So network =

172.31.16.0/20

---

# 7. Easy visual

172.31.0.0  
172.31.16.0  ← our network  
172.31.32.0

Since **18 is between 16 and 31**, the subnet is:

172.31.16.0/20

---

# DevOps Tip

When working with **VPC in AWS**, this becomes easier because most subnets are:

/24

Example:

172.31.1.0/24

No complicated math.