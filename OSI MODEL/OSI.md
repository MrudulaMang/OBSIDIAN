Osi model

The **OSI (Open Systems Interconnection) Model** is a framework that explains how data travels from one computer to another through a network. It consists of **7 layers**, each with a specific responsibility.

|Layer|Name|Examples|What it does|
|---|---|---|---|
|7|Application|HTTP, HTTPS, DNS, FTP|User interacts with network|
|6|Presentation|SSL/TLS, Encryption|Formats, encrypts, compresses data|
|5|Session|NetBIOS, RPC|Creates and manages sessions|
|4|Transport|TCP, UDP|Reliable delivery, ports|
|3|Network|IP, ICMP|Routing and IP addressing|
|2|Data Link|Ethernet, MAC|Frame delivery on local network|
|1|Physical|Cables, Fiber, Wi-Fi signals|Sends raw bits (0s and 1s)|

**Easy way to remember (Top → Bottom):**

**A**ll  
**P**eople  
**S**eem  
**T**o  
**N**eed  
**D**ata  
**P**rocessing

(Application → Presentation → Session → Transport → Network → Data Link → Physical)

For DevOps interviews, focus heavily on:

- **Layer 7:** HTTP, HTTPS, DNS
- **Layer 4:** TCP, UDP, Ports (80, 443, 22, 3306, 27017)
- **Layer 3:** IP addresses, Routing, Subnets
- **Layer 2:** MAC addresses, ARP
- **Layer 1:** Cable, NIC, Link status

**Production troubleshooting example**

Website not opening:

1. Layer 1 → Is the server reachable? Cable/NIC up?
2. Layer 2 → ARP working?
3. Layer 3 → Can you ping the IP?
4. Layer 4 → Is port 443 listening? (`netstat -tulnp`)
5. Layer 7 → Is Nginx/Apache application running?

This is why experienced engineers often troubleshoot from **Layer 1 upward**.

For your DevOps work, remember this mapping:

- Docker container → Mostly Layer 4–7
- Kubernetes Service → Layer 4
- Ingress / ALB → Layer 7
- VPC Routing → Layer 3
- Security Groups → Layer 3/4
- Network cables, NICs → Layer 1

A common interview question is:

**When you open `https://google.com`, explain what happens at each OSI layer.**

If you can answer that end-to-end, your OSI understanding is strong enough for most DevOps and cloud interviews.