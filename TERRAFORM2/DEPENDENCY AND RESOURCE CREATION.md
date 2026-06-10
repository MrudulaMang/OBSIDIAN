Yes. That's the core Terraform model.

Terraform does **not wait for something to "trigger" a resource** like Ansible handlers or event-driven systems.

If a resource exists in the configuration and is not already in state, Terraform plans to create it.

Example:

```
resource "aws_iam_role" "mysql" {}resource "aws_iam_policy" "mysql" {}resource "aws_iam_role_policy_attachment" "mysql" {  role       = aws_iam_role.mysql.name  policy_arn = aws_iam_policy.mysql.arn}resource "aws_iam_instance_profile" "mysql" {  role = aws_iam_role.mysql.name}resource "aws_instance" "mysql" {  iam_instance_profile = aws_iam_instance_profile.mysql.name}
```

Terraform builds a graph:

```
Role --------\              \               -> Policy Attachment              /Policy ------/Role  |  vInstance Profile  |  vEC2
```

Then creates **all resources**, respecting dependencies.

It is not thinking:

```
EC2 needs instance profiletherefore create only role/profileignore policy
```

Instead it thinks:

```
Desired State =RolePolicyPolicy AttachmentInstance ProfileEC2Need to create all of them.
```

The dependency graph only answers:

```
WHAT ORDER?
```

not

```
SHOULD I CREATE IT?
```

---

A good mental model:

### Step 1: Collect resources

Terraform scans:

```
resource Aresource Bresource Cresource D
```

Desired state:

```
ABCD
```

---

### Step 2: Build graph

Terraform looks for references:

```
B uses A.idC uses B.idD uses A.id
```

Graph:

```
A|\| \v  vB  D|vC
```

---

### Step 3: Execute graph

Terraform creates:

```
A firstthenB and D in parallelthenC
```

---

Now let's connect this to your Roboshop example.

Even if you remove:

```
iam_instance_profile = aws_iam_instance_profile.mysql.name
```

from EC2, Terraform would still create:

```
RolePolicyPolicy AttachmentInstance ProfileEC2
```

because all 5 resources exist in the configuration.

The dependency graph only affects the order.

---

The exception is when you use:

```
count = 0
```

or

```
for_each = {}
```

or

```
terraform destroy
```

or conditional expressions that prevent a resource from existing.

Example:

```
resource "aws_iam_policy" "mysql" {  count = var.create_policy ? 1 : 0}
```

If:

```
create_policy = false
```

then Terraform doesn't even put that resource in the graph.

---

For interviews, remember this sentence:

> Terraform first determines the desired resources from configuration, then builds a dependency graph to determine creation order. Dependencies affect ordering, not whether a resource is created.