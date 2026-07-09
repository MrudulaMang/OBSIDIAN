
Client sends request
(example: browser → google.com:443)
        │
        ▼
Packet travels through Internet
        │
        ▼
Server Network Interface Card (NIC) receives packet
        │
        ▼
NIC triggers interrupt to OS kernel
        │
        ▼
Kernel Network Stack processes packet
(Ethernet → IP → TCP layer)
        │
        ▼
Kernel reads TCP header
Destination Port = 443
        │
        ▼
Kernel checks socket table
        │
        ▼
Is any process listening on port 443?
        │
   ┌────┴─────┐
   │          │
  YES         NO
   │          │
   ▼          ▼
Find socket   Packet dropped
mapped to     or rejected
port 443
   │
   ▼
Example mapping in kernel:

Port 443 → nginx process
Port 22  → sshd
Port 3306 → mysql
   │
   ▼
Packet placed in socket receive buffer
   │
   ▼
Kernel wakes the application
(nginx / web server)
   │
   ▼
Application reads request
read() / recv()
   │
   ▼
Application processes request
   │
   ▼
Response sent back to client

Here is the **flowchart for how the response goes back from the server to the client** after the application processes the request.
Application prepares response

(example: nginx generates HTTP response)
        │
        ▼
Application writes data to socket
send() / write()
        │
        ▼
Data enters kernel socket send buffer
        │
        ▼
Kernel TCP stack processes data
        │
        ▼
TCP layer creates TCP segments
(Source Port = 443
Destination Port = client port)
        │
        ▼
IP layer adds IP header
(Source IP = server IP
Destination IP = client IP)
        │
        ▼
Ethernet layer adds MAC addresses
        │
        ▼
Packet placed in NIC transmit buffer
        │
        ▼
Network Interface Card sends packet
onto the network
        │
        ▼
Packet travels through Internet routers
        │
        ▼
Client network card receives packet
        │
        ▼
Client OS kernel processes packet
(Ethernet → IP → TCP)
        │
        ▼
Kernel checks socket table
(match using connection tuple)
        │
        ▼
Packet placed in client socket buffer
        │
        ▼
Client application wakes up
(browser process)
        │
        ▼
Browser reads response
recv() / read()
        │
        ▼
Browser renders page for user