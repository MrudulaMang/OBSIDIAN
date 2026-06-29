A **keyring** is a secure place where your computer stores **cryptographic keys, passwords, certificates, or authentication tokens** so you don't have to enter them repeatedly.

Think of it as a **digital keychain**.

### Real-life analogy

Imagine you have a keychain.

```
🔑 House key🔑 Car key🔑 Office key🔑 Locker key
```

Instead of carrying them separately, you keep them on one keyring.

Similarly, your computer has a keyring that stores:

```
SSH KeysAWS CredentialsGPG KeysPasswordsCertificatesAPI Tokens
```

---

## Example 1: SSH Keys

Suppose you have:

```
id_rsaid_rsa.pub
```

Normally, every SSH connection may ask for the passphrase.

If you add the key to the SSH agent (a type of keyring):

```
ssh-add ~/.ssh/id_rsa
```
### Breakdown

- `ssh-add` → Adds an SSH key to the SSH Agent.
- `~/.ssh/` → Your SSH keys directory (`~` means your home directory).
- `id_rsa` → Your private SSH key.
Now you can do:

```
ssh ubuntu@server
```

without entering the passphrase each time during that session.

`ssh-add ~/.ssh/id_rsa` loads the private SSH key `id_rsa` into the SSH Agent. The agent keeps the decrypted key in memory, allowing SSH-based tools to authenticate using that key without repeatedly asking for its passphrase.