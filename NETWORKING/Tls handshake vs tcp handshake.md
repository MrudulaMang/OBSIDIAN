tls handshake vs tcp handshake

They happen at different layers and for different purposes.

TCP handshake comes first. TLS handshake happens after TCP is established.

Sequence:

```
Client                           ServerTCP SYN ------------------------>           <-------------------- TCP SYN-ACKTCP ACK ------------------------>TCP connection establishedClientHello -------------------->           <-------------------- ServerHello + CertificateKey Exchange ------------------->           <-------------------- FinishedTLS session establishedHTTPS data <===================> HTTPS data
```

TCP 3-way handshake (Layer 4)

Purpose: Establish a reliable connection between two IP:Port endpoints.

```
SYNSYN-ACKACK
```

What gets established?

- Sequence numbers
- A reliable communication channel
- Connection state on both sides

What it does NOT do:

- Doesn't verify identity
- Doesn't encrypt data
- Doesn't exchange certificates

Think of TCP as:

> "Can we talk reliably?"

---

TLS handshake (Layer 5/6 above TCP)

Purpose:

- Authenticate the server
- Negotiate encryption algorithms
- Generate shared encryption keys

During TLS handshake:

- Client sends supported cipher suites
- Server sends certificate
- Client verifies certificate
- Both derive session keys
- Future traffic becomes encrypted

Think of TLS as:

> "Who are you, and how do we securely talk?"

---

Real HTTPS example

Suppose you visit:

```
https://amazon.com
```

Step 1: TCP handshake

```
Your PC:49152  ---> Amazon:443
```

```
SYNSYN-ACKACK
```

Connection exists but is still unencrypted.

Step 2: TLS handshake

```
ClientHelloServerHelloCertificateKey ExchangeFinished
```

Now both sides have symmetric keys.

Step 3: HTTPS traffic

```
GET /products
```

is encrypted before being sent.

---

A useful interview answer:

|TCP Handshake|TLS Handshake|
|---|---|
|Layer 4|Above Layer 4|
|Creates connection|Creates secure connection|
|SYN, SYN-ACK, ACK|ClientHello, ServerHello, Certificate, Key Exchange|
|No encryption|Establishes encryption|
|No identity verification|Verifies server identity|
|Mandatory for TCP communication|Optional; only when security is needed|

A common misconception is that TLS replaces TCP. It doesn't. For HTTPS, TLS runs on top of an already established TCP connection:

```
Application (HTTP)        ↓TLS        ↓TCP        ↓IP
```

So when you open an HTTPS website, the TCP handshake is completed first, then the TLS handshake begins. Without the TCP connection, TLS messages have nowhere to travel.