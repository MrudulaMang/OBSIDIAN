JWT = **JSON Web Token**.

It's just a way of packing identity information into a signed string, so a system can prove "this is who I am" without needing a database lookup every time.

**Structure:** three parts separated by dots —

```
HEADER.PAYLOAD.SIGNATURE
```

- **Header** — says what type of token it is and how it's signed
- **Payload** — the actual data (who you are, what you're allowed, when it expires)
- **Signature** — proves the token wasn't tampered with

In the IRSA case, the payload is what matters. When you decode it, you see fields like:

json

```json
{
  "iss": "https://oidc.eks.ap-south-1.amazonaws.com/id/XXXX",
  "sub": "system:serviceaccount:default:s3-reader",
  "aud": "sts.amazonaws.com",
  "exp": 1710000000
}
```

Kubernetes generates this token and mounts it inside your pod. AWS IAM then reads it, checks the `sub`, `aud`, and `iss` fields against your trust policy, and decides whether to trust it — that's the whole mechanism behind IRSA.

It's not encrypted, by the way — anyone can decode and read a JWT's payload (that's why you can just `base64 -d` it). It's signed, not hidden. The security comes from the signature proving it's genuine, not from secrecy.