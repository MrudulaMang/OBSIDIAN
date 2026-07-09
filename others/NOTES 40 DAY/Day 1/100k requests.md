100,000 Users open google.com
          │
          ▼
Each client performs DNS lookup
          │
          ▼
DNS returns nearest Google edge IP
(Anycast routing)
          │
          ▼
Requests reach Google Edge Network
          │
          ▼
Global Load Balancer receives connections
          │
          ▼
Load balancer distributes traffic
across many servers
          │
          ▼
Example distribution

Server A → 10,000 connections
Server B → 12,000 connections
Server C → 8,000 connections
Server D → 11,000 connections
Server E → 9,000 connections
...
Total ≈ 100,000
          │
          ▼
Each server OS kernel receives packets
          │
          ▼
Kernel checks destination port
(443)
          │
          ▼
Kernel finds listening socket
(port 443 → web server)
          │
          ▼
Connections accepted

accept()
creates new socket for each client
          │
          ▼
Server now holds thousands of sockets

Example:

Client1 → 1.2.3.4:53021 → Server:443
Client2 → 8.9.1.3:53110 → Server:443
Client3 → 4.5.6.7:60211 → Server:443
...
          │
          ▼
Event-driven server loop

epoll_wait()
          │
          ▼
Kernel notifies when:
- data arrives
- connection closes
- socket writable
          │
          ▼
Server processes requests
          │
          ▼
Responses sent back to clients