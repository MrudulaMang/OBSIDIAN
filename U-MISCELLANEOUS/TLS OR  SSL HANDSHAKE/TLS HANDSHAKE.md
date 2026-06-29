fter decrypting the secret, the server sends TLS handshake messages encrypted using keys derived from that secret. exdplain in detail

This is exactly the part that proves the server successfully decrypted the browser's secret.

Let's use the old RSA TLS handshake.

### Step 1: Browser generates secret

Browser creates:

```
Pre-Master Secret = ABC123
```

Browser encrypts it with server's public key:

```
Encrypted(ABC123)
```

and sends it to the server.

---

### Step 2: Server decrypts

Server uses its private key:

```
Encrypted(ABC123)      ↓Private Key      ↓ABC123
```

Now both sides know:

```
ABC123
```

but an attacker does not.

---

### Step 3: Both derive session keys

Neither side directly uses ABC123 for encryption.

Instead they run it through a key derivation process.

Simplified:

```
ABC123+Random_from_browser+Random_from_server↓Key Derivation Function↓Session Keys
```

Both independently calculate:

```
Encryption KeyMAC KeyIV
```

The results are identical because both have the same inputs.

Imagine both arrive at:

```
Session Key = SECRET999
```

---

### Step 4: Server sends "Finished" message

Now the server must prove:

> I successfully decrypted your secret.

How?

By sending a message encrypted with the session key.

Something like:

```
Finished
```

encrypted using:

```
SECRET999
```

becomes:

```
X7F9K2A8...
```

and gets sent to the browser.

---

### Step 5: Browser receives it

Browser already calculated:

```
SECRET999
```

from the same Pre-Master Secret.

So browser tries:

```
X7F9K2A8...↓Decrypt with SECRET999↓Finished
```

It works.

---

### Why is this proof?

Suppose the server could not decrypt the browser's secret.

Then it would not know:

```
ABC123
```

Without ABC123 it cannot derive:

```
SECRET999
```

Without SECRET999 it cannot correctly encrypt the Finished message.

Therefore if the browser successfully decrypts the Finished message, it knows:

```
Server knew ABC123
```

and the only way to know ABC123 was:

```
Possess the private key↓Decrypt browser's message
```

So the browser concludes:

> This server really owns the private key corresponding to the certificate I validated.

---

Think of it like a challenge-response test.

Browser:

```
Here's a locked box containing a secret.Only the real server can open it.
```

Server opens the box and learns:

```
ABC123
```

Browser then silently thinks:

```
If you really opened the box,send me a message encrypted using ABC123.
```

Server does.

Browser successfully decrypts it.

Proof complete.

---

One subtle point: the server does **not** literally send "I decrypted your secret."

Instead it sends a cryptographic checksum of the entire handshake encrypted/protected using keys derived from that secret.

That's what the TLS **Finished** message actually is.

This prevents tampering with any part of the handshake and proves both sides arrived at the same cryptographic keys. This "Finished" message is one of the most important messages in the entire TLS protocol.