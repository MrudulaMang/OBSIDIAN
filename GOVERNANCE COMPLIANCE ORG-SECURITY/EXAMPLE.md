Understand them through a simple sequence:

### 1. Security → "Can this hurt us?"

Examples:

- Public S3 bucket
- Unencrypted EBS
- Open database port

Question:

> Is this infrastructure safe?

---

### 2. Operational → "Can we manage this?"

Examples:

- Missing tags
- Bad naming convention
- No approval process
- Wrong Terraform workflow

Question:

> Can the organization operate and maintain this properly?

---

### 3. Compliance → "Are we allowed to do this?"

Examples:

- GDPR
- HIPAA
- PCI-DSS
- Data residency

Question:

> Do laws, regulations, or contracts allow this?

---

Use this one resource and classify it:

**S3 Bucket**

|Rule|Category|
|---|---|
|Must be encrypted|Security|
|Must have Owner tag|Operational|
|Customer data cannot leave India|Compliance|

Another example:

**EC2 Instance**

|Rule|Category|
|---|---|
|SSH not open to internet|Security|
|Name must follow standard|Operational|
|Must run only in approved region|Compliance|

My challenge for you:

Don't try to remember the definitions.

Whenever you see a rule, ask:

1. Is it protecting us? → **Security**
2. Is it helping us manage things? → **Operational**
3. Is it required by law/audit/customer contract? → **Compliance**

If you practice with 20 examples, you'll never forget it.

Try these:

1. "Every resource must have CostCenter tag."
2. "Credit card data must be encrypted."
3. "Production changes require manager approval."
4. "European customer data must stay in EU."

Classify each one before looking at the answers.

Answers:

1. Operational
2. Security (also helps compliance, but primarily security)
3. Operational
4. Compliance

That's the mental model interviewers use. The labels become obvious once you start classifying real examples.