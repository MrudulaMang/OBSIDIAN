## 🧠 Level 1 — Strong foundations (but non-basic angle)

1. **“Terraform is not provisioning… it’s state management”**
    - Talk about state file as the _real source of truth_
2. **“Why `terraform apply` is actually dangerous”**
    - Unintended changes, drift, blind applies
3. **“What ‘idempotency’ really means in Terraform”**
    - Not just repeatable → predictable infra
4. **“Why beginners misunderstand variables in Terraform”**
    - It’s not just input → it’s _design control_

---

## ⚙️ Level 2 — Real-world behavior (this is your zone)

5. **“What actually happens during `terraform plan`”**
    - Diff engine, desired vs current state
6. **“Why Terraform sometimes ‘wants to destroy everything’”**
    - State mismatch, resource recreation
7. **“Remote state is not optional in teams”**
    - Locking, consistency, race conditions
8. **“Provisioners are a trap (and when they are okay)”**
    - You already touched this with remote-exec

---

## 💣 Level 3 — Debugging & failure mindset (your strength)

9. **“Terraform failed. Now what?”**
    - Partial infra, broken state, recovery thinking
10. **“State file got corrupted—what would you do?”**

- Real SRE thinking

11. **“Drift in infrastructure: silent production risk”**

- Manual changes vs Terraform control

12. **“Why infra bugs are harder than code bugs”**

- Visibility, rollback complexity

---

## 🧱 Level 4 — Architecture thinking (this is elite content)

13. **“Terraform modules are not just reuse—they are boundaries”**

- Like services in system design

14. **“Where should logic live: Terraform vs Ansible vs App?”**

- You already had this confusion → GOLD topic

15. **“Designing infra for change, not just creation”**

- Future-proofing