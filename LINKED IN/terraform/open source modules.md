Most people don’t have a Terraform problem.  
They have a **visibility problem**.

I learned this the hard way…

You use a popular module.  
Everything looks clean. Minimal code.  
You feel productive.

Then suddenly:  
💸 3 NAT Gateways created  
💸 Cost spikes  
😐 You didn’t even write that anywhere

So what happened?

👉 It _was_ written — just not in your code.

Inside the module:

- Defaults
    
- Conditional logic
    
- Derived values based on inputs (like number of AZs)
    

That’s when it hit me:

👉 Modules don’t remove complexity  
👉 They **move complexity somewhere else**

---

### 🔍 Real shift in thinking

Before:  
“I wrote less code = simpler system”

After:  
“I must understand what this abstraction is hiding”

---

### 💡 What strong engineers actually do

✔️ Read module internals (`variables.tf`, `main.tf`)  
✔️ Override defaults explicitly  
✔️ Treat `terraform plan` like a debugger  
✔️ Use modules for speed, not blind trust

---

### ⚖️ Modules vs Writing Your Own?

It’s not either/or.

👉 Use open-source modules for standard infra  
👉 Write your own when you need control  
👉 Combine both → that’s real engineering

---

### 🔥 One line that changed my approach:

**“If you don’t understand the abstraction, you don’t control the system.”**

---

Curious — have you ever had a Terraform surprise (cost / infra / behavior) because of a module?