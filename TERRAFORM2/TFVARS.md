`terraform.tfvars` (often pronounced "TF vars") is a file used to provide values to Terraform input variables.

Think of it this way:

**variables.tf** = declares the variables

```
variable "instance_type" {  type = string}variable "environment" {  type = string}
```

**terraform.tfvars** = supplies the values

```
instance_type = "t3.micro"environment   = "dev"
```

Then in your code:

```
resource "aws_instance" "web" {  instance_type = var.instance_type  tags = {    Environment = var.environment  }}
```

Terraform automatically loads:

```
terraform.tfvars*.auto.tfvars
```

So if these files exist, you don't need to pass values manually.

Without tfvars:

```
terraform apply -var="instance_type=t3.micro"
```

With tfvars:

```
terraform apply
```

Terraform reads the values automatically.

A common project structure:

```
project/│├── main.tf├── variables.tf├── outputs.tf├── providers.tf│├── terraform.tfvars│├── dev.tfvars├── qa.tfvars└── prod.tfvars
```

For multiple environments:

```
terraform apply -var-file=dev.tfvars
```

```
terraform apply -var-file=qa.tfvars
```

```
terraform apply -var-file=prod.tfvars
```

Example:

**variables.tf**

```
variable "instance_type" {}variable "instance_count" {}
```

**dev.tfvars**

```
instance_type  = "t3.micro"instance_count = 1
```

**prod.tfvars**

```
instance_type  = "m5.large"instance_count = 5
```

Same code, different infrastructure.

A deeper point many beginners miss:

Terraform code should describe **structure**.

`tfvars` should contain **environment-specific values**.

Bad:

```
resource "aws_instance" "dev_server" {  instance_type = "t3.micro"}
```

Better:

```
resource "aws_instance" "server" {  instance_type = var.instance_type}
```

Now the code is reusable across dev, QA, prod, and even different customers.

For interviews, remember:

```
variables.tf     → Declare variablesterraform.tfvars → Assign valuesvar.name         → Use variable values
```

This pattern is one of the foundations of writing reusable Terraform modules.

if there is one tfvar file in the code terraform automatticlay loads those values if there are more than one tfvars then we mention at command line with var-file , right?

Yes, with a small nuance.

If you have a file named exactly:

```
terraform.tfvars
```

Terraform loads it automatically.

Also, files ending with:

```
*.auto.tfvars
```

are automatically loaded.

Examples:

```
terraform.tfvarsdev.auto.tfvarsprod.auto.tfvars
```

Terraform reads all of them automatically.

---

If you have files like:

```
dev.tfvarsqa.tfvarsprod.tfvars
```

Terraform does **not** load them automatically.

You must specify:

```
terraform apply -var-file=dev.tfvars
```

or

```
terraform apply -var-file=prod.tfvars
```

---

One thing to be careful about:

If you have both:

```
terraform.tfvarsdev.tfvars
```

and run:

```
terraform apply -var-file=dev.tfvars
```

Terraform loads **both** files.

Variable precedence applies, and values from `dev.tfvars` override values from `terraform.tfvars` when the same variable exists.

Example:

**terraform.tfvars**

```
instance_type = "t3.micro"
```

**dev.tfvars**

```
instance_type = "t3.small"
```

Command:

```
terraform apply -var-file=dev.tfvars
```

Result:

```
instance_type = t3.small
```

because the explicitly specified file has higher precedence.

For real projects, a common pattern is:

```
variables.tfmain.tfdev.tfvarsqa.tfvarsprod.tfvars
```

and then:

```
terraform plan  -var-file=dev.tfvarsterraform apply -var-file=dev.tfvars
```

This avoids accidentally deploying production values because of an automatically loaded `terraform.tfvars`. Many teams skip `terraform.tfvars` entirely and use explicit environment files.

terraform.tfvars dev.auto.tfvars prod.auto.tfvars is this not ambigious?

Exactly. That's why teams are careful with `*.auto.tfvars`.

If you have:

```
terraform.tfvarsdev.auto.tfvarsprod.auto.tfvars
```

Terraform loads **all three automatically**.

Now imagine:

**terraform.tfvars**

```
instance_type = "t3.micro"
```

**dev.auto.tfvars**

```
instance_type = "t3.small"
```

**prod.auto.tfvars**

```
instance_type = "m5.large"
```

Terraform now sees:

```
instance_type = ?
```

Three different values.

Terraform resolves this using precedence rules, but when multiple auto-loaded files define the same variable, the result depends on loading order. This becomes confusing and dangerous.

That's why you almost never see:

```
dev.auto.tfvarsprod.auto.tfvars
```

living together in the same working directory.

Instead, teams usually choose one of these patterns:

**Pattern 1 (Most Common)**

```
main.tfvariables.tfdev.tfvarsqa.tfvarsprod.tfvars
```

and run:

```
terraform apply -var-file=dev.tfvars
```

or

```
terraform apply -var-file=prod.tfvars
```

Very explicit. No ambiguity.

---

**Pattern 2**

Separate folders:

```
environments/├── dev/│   └── terraform.tfvars├── qa/│   └── terraform.tfvars└── prod/    └── terraform.tfvars
```

Each environment has its own directory and state.

---

**Pattern 3**

Terraform Cloud / CI/CD injects variables.

No tfvars files are stored locally at all.

---

The deeper lesson is:

`terraform.tfvars` is intended as the **default values for the current workspace/project**.

`dev.tfvars`, `prod.tfvars`, etc. are intended as **mutually exclusive environment files**.

If you find yourself with:

```
dev.auto.tfvarsqa.auto.tfvarsprod.auto.tfvars
```

in the same directory, that's usually a design smell. You're relying on automatic loading when you should probably be explicitly selecting the environment.