give me 100 toughest secanrio based terraform questions , collect them from interenet, act like a terraform expert 

Here is a comprehensive, expert-level compilation of 100 scenario-based Terraform questions. I’ve structured them into five critical domains to reflect the core challenges faced by Site Reliability Engineers and Cloud Architects in enterprise environments.

### **1-20: State Management & Concurrency**

**1. Q: A developer accidentally committed a `.tfstate` file containing plaintext secrets to a public Git repository. How do you mitigate this immediately?**

**A:** Invalidate and rotate the exposed secrets immediately. Delete the file from the repository, rewrite the Git history using `git filter-repo`, and migrate the state to a secure remote backend (e.g., S3 + DynamoDB or Terraform Cloud) with at-rest encryption.

**2. Q: Two CI pipelines ran `terraform apply` concurrently. The state is now locked, but both pipelines failed. How do you recover?**

**A:** Identify the stale lock ID using your backend's locking table (e.g., DynamoDB). Verify no processes are actively running against it. Use the CLI command `terraform force-unlock <LOCK_ID>` to release it, then safely re-run the plan.

**3. Q: You need to migrate an existing local state containing 500 resources to Terraform Cloud. A disruption would cause downtime. How do you proceed?**

**A:** Add the `cloud` block to your configuration and run `terraform init`. Terraform will detect the existing local state and prompt to securely migrate it to the remote workspace without altering any actual infrastructure.

**4. Q: You inherited a massive monolithic Terraform state file managing networking, databases, and apps. `terraform plan` takes 20 minutes. How do you safely split it?**

**A:** Refactor the code into separate directories. Pull the state locally using `terraform state pull`. Use `terraform state mv` to move specific resource addresses from the monolithic state to the new, smaller state files. Update configurations to use `data.terraform_remote_state` for cross-dependencies.

**5. Q: A resource was deleted manually via the AWS console. Your `terraform plan` wants to recreate it, but you want Terraform to simply "forget" it was ever managed. What do you do?**

**A:** Run `terraform state rm <resource_address>`. This removes the resource mapping from the state file without attempting to modify the actual cloud infrastructure.

**6. Q: Your S3 remote state bucket was accidentally deleted. You have versioning enabled, but a delete marker was placed on the `.tfstate`. How do you recover?**

**A:** Remove the delete marker via the AWS CLI or console to restore the previous `.tfstate` version. Once restored, run `terraform refresh` to ensure the state matches the current reality.

**7. Q: You want to update a resource name in your code from `aws_instance.web` to `aws_instance.frontend` without causing a destroy and recreate. How?**

**A:** Update the `.tf` code to the new name. Before running an apply, execute `terraform state mv aws_instance.web aws_instance.frontend` to align the state file with the code.

**8. Q: You are using `count` to create 5 instances. You remove the 3rd instance in the list. What happens, and how do you prevent the 4th and 5th from recreating?**

**A:** Removing a middle index shifts the list, causing subsequent resources to recreate. Refactor the code to use `for_each` with a map or set of strings, which identifies resources by unique keys instead of numeric index positions.

**9. Q: A `terraform plan` throws a "state lock error," but the DynamoDB table shows no lock. What else could cause this?**

**A:** Check for lingering `.terraform.tfstate.lock.info` files if someone was testing locally, or verify IAM permissions to ensure the execution role has `dynamodb:DeleteItem` and `dynamodb:PutItem` rights.

**10. Q: You need to import a massive AWS VPC with hundreds of subnets and route tables. Doing this via CLI one-by-one is too slow. What is the modern approach?**

**A:** In Terraform 1.5+, use an `import` block in your code (`import { to = aws_vpc.main; id = "vpc-xxx" }`) and run `terraform plan -generate-config-out=generated.tf` to auto-generate the configuration.

**11. Q: An apply times out while creating an RDS instance, leaving it "tainted." What happens next apply, and how do you stop it if the DB is actually healthy?**

**A:** Terraform will attempt to destroy and recreate the tainted resource. If verified healthy, use `terraform untaint <resource_address>` before applying.

**12. Q: You are working in an air-gapped environment. How do you initialize Terraform without internet access to the Registry?**

**A:** Download the required provider binaries externally. Transfer them to the air-gapped network and configure a `provider_installation` block in the `.terraformrc` CLI file to point to a local filesystem mirror.

**13. Q: You want to test a destructive change locally without affecting the shared remote state. How do you do this safely?**

**A:** Pull the state locally (`terraform state pull > local.tfstate`). Run plans explicitly pointing to it: `terraform plan -state=local.tfstate`.

**14. Q: An API change broke your provider version, but upgrading requires major refactoring you can't do right now. How do you stabilize?**

**A:** Pin the provider to the last known working version in the `required_providers` block (e.g., `version = "= 4.67.0"`).

**15. Q: You are managing infrastructure for 50 clients. They share the same architecture but require strict data isolation. Do you use Workspaces or separate directories?**

**A:** Separate directories/state files. CLI workspaces share the same backend file and are not suitable for strict security isolation.

**16. Q: A developer bypassed Terraform and manually attached a secondary ENI to an EC2 instance. How do you tell Terraform to ignore this specific change?**

**A:** Add `ignore_changes = [network_interface]` within the `lifecycle` block of the `aws_instance` resource.

**17. Q: You need to pass an output from an AWS networking module (State A) to an Azure compute module (State B). How?**

**A:** State B should use the `terraform_remote_state` data source configured to read State A's backend, then extract the value using `data.terraform_remote_state.network.outputs.vpc_id`.

**18. Q: Terraform complains about a circular dependency between an IAM role and an S3 bucket policy. How do you resolve this?**

**A:** Create the S3 bucket and IAM role first. Then, attach the bucket policy via a separate `aws_s3_bucket_policy` resource rather than inline within the bucket resource.

**19. Q: You are migrating an S3 bucket to a different AWS account within an Org. Can you just move the state?**

**A:** No. You must create the new bucket, copy the data, update the Terraform code, `terraform state rm` the old bucket, and `import` the new one.

**20. Q: A zero-day requires patching an AMI ID across 500 EC2 instances. How do you force replacement smoothly without dropping traffic?**

**A:** Update the AMI variable. Ensure instances are behind a Load Balancer and use `lifecycle { create_before_destroy = true }` so new instances provision before old ones terminate.

### **21-40: Modules, Refactoring & Logic**

**21. Q: Your company has 50 microservices using the same custom module. You need to make a breaking change. How do you avoid breaking all services?**

**A:** Implement versioning. Tag the Git repository (e.g., `v2.0.0`). Have services reference the tag via the `?ref=v1.0.0` query parameter and upgrade them individually.

**22. Q: How do you conditionally create a resource only if a specific variable is `true`?**

**A:** Use the `count` meta-argument: `count = var.create_resource ? 1 : 0`.

**23. Q: A module outputs a list of subnet IDs, but you need them as a comma-separated string. How do you transform this?**

**A:** Use the `join(",", module.network.subnet_ids)` function.

**24. Q: How do you enforce strict validation on a complex variable input to prevent bad configurations?**

**A:** Use custom `validation` blocks inside the `variable` declaration, utilizing regex to check conditions and return error messages.

**25. Q: You want to write a reusable module that provisions resources in _two_ AWS regions simultaneously (e.g., DR). How?**

**A:** Require the caller to pass multiple provider aliases into the module using the `providers = { aws.primary = aws.useast1, aws.dr = aws.uswest2 }` argument.

**26. Q: The app code must be downloaded via a `local-exec` provisioner _after_ the DB is up. How do you enforce this timing?**

**A:** Use `depends_on = [aws_db_instance.main]` inside the `null_resource` block handling the `local-exec`.

**27. Q: You need to iterate over a map of users to create IAM users, but skip those with status "inactive". How?**

**A:** Use a `for` expression with an `if` clause: `for_each = { for k, v in var.users : k => v if v.status == "active" }`.

**28. Q: Why are `provisioners` generally discouraged in modern Terraform?**

**A:** They break idempotency, bypass state tracking (if they fail mid-way, Terraform loses track), and require network access (SSH/WinRM). Cloud-init/user-data is preferred.

**29. Q: You need to fetch the latest Amazon Linux AMI dynamically. How?**

**A:** Use the `aws_ami` data source, filtering by name/owner, and setting `most_recent = true`.

**30. Q: A developer wants to use `terraform workspace new dev` to spin up a replica of production with different VPC CIDRs. Why is this an anti-pattern?**

**A:** CLI Workspaces are best for identical environments. For distinct configurations (different variables, sizes), directory separation or distinct modules is safer.

**31. Q: How do you dynamically generate an IAM policy JSON document within Terraform safely?**

**A:** Use the `data "aws_iam_policy_document"` data source. It catches syntax errors during `plan` and allows safe variable interpolation.

**32. Q: A module creates a Kubernetes cluster, and you want to use the Kubernetes provider to deploy pods into it in the same apply. Why does this fail?**

**A:** The cluster doesn't exist during the `plan` phase, so the Kubernetes provider cannot authenticate, causing a "bootstrap" error. Split into two states.

**33. Q: How do you provision resources in a private subnet with no public internet access?**

**A:** Terraform communicates with Cloud Provider APIs (which are public or via VPC endpoints), not the actual resources. It can provision private resources fine.

**34. Q: You need to generate a unique random password, but don't want it regenerating on every apply.**

**A:** Use the `random_password` resource. It saves the result to state and only regenerates if its `keepers` map changes.

**35. Q: You need to inject a multi-line Bash script into an EC2 `user_data` field, passing in Terraform variables. How do you keep it clean?**

**A:** Use `templatefile("${path.module}/script.sh", { var1 = val1 })` to render an external file.

**36. Q: How do you verify an official module from the registry hasn't been maliciously altered?**

**A:** Use the `.terraform.lock.hcl` file to lock provider hashes, or fork the module to a private registry.

**37. Q: You have a list of IP addresses and need to chunk them into sub-lists of 3 for a load balancer. How?**

**A:** Use the `chunklist(var.ip_list, 3)` function.

**38. Q: How do you handle deleting a GCP project via Terraform if it contains active lien restrictions?**

**A:** Terraform cannot bypass liens natively. Script the removal of liens using a `null_resource` or handle it manually before destroying.

**39. Q: A colleague suggests using `terraform push`. What do you tell them?**

**A:** `terraform push` is deprecated and removed. Integration should be done via CI/CD pipelines or VCS integrations.

**40. Q: You need to output the private IPs of all instances created via `for_each` as a simple list. How?**

**A:** Use a `for` expression: `value = [for instance in aws_instance.web : instance.private_ip]`.

### **41-60: Security & Compliance**

**41. Q: You must inject a DB password, but policy forbids storing it in state. Solution?**

**A:** Terraform _always_ stores configured properties in state. Generate the secret in AWS Secrets Manager, pass the Secret ARN (not the password) via Terraform, and have the app fetch it at runtime.

**42. Q: A developer hardcoded an API key. You removed it, but how do you prevent this systemically?**

**A:** Implement pre-commit hooks (`git-secrets`) and enforce infrastructure code scanning (Checkov, tfsec) in CI before merging.

**43. Q: How do you enforce that all S3 buckets MUST have versioning enabled, failing the build if they don't?**

**A:** Implement Sentinel policies (Terraform Cloud) or Open Policy Agent (OPA) integration in CI to evaluate the plan JSON.

**44. Q: How does the AWS provider authenticate if you use HashiCorp Vault for dynamic short-lived credentials?**

**A:** The provider block remains empty. It relies on environment variables (`AWS_ACCESS_KEY_ID`, etc.) dynamically injected by the Vault agent before `terraform init`.

**45. Q: How do you ensure state data transmitted over the network is secure?**

**A:** Terraform uses TLS/HTTPS by default for all backend/API communications.

**46. Q: A third-party module requires sensitive data. How do you hide it from the CLI output?**

**A:** Define the input variable with `sensitive = true`.

**47. Q: An attacker compromises your CI pipeline. How do you limit where they can deploy infrastructure?**

**A:** Use Cloud Provider IAM policies on the execution role to strictly limit regions (`aws:RequestedRegion`), overriding any Terraform config.

**48. Q: When migrating state to a new KMS-encrypted S3 backend, does Terraform natively encrypt it at rest?**

**A:** No, Terraform encrypts inflight. At-rest encryption relies entirely on the S3 bucket's configuration.

**49. Q: How do you audit who ran `terraform apply` in a large team?**

**A:** Use a managed service like Terraform Cloud/Enterprise which maintains complete run audit trails, or query CloudTrail for S3 backend API access.

**50. Q: Can Terraform natively prevent `0.0.0.0/0` in security groups?**

**A:** No. You need policy-as-code tools (Sentinel/OPA) or custom validation in modules (which can't prevent root-level misconfigurations).

**51. Q: You need to export a `sensitive = true` output to an external bash script. How do you bypass CLI masking?**

**A:** Run `terraform output -raw <output_name>`.

**52. Q: Secure authentication to Azure without using long-lived Client Secrets?**

**A:** Use OIDC (OpenID Connect) federation between your CI/CD provider and Azure Entra ID.

**53. Q: Can an external data source (`data "external"`) introduce a security risk?**

**A:** Yes. It executes arbitrary local scripts, potentially creating a remote code execution (RCE) vulnerability if inputs are manipulated.

**54. Q: How do you provision resources in AWS Account B when the CI pipeline runs in Account A?**

**A:** Create an IAM Role in B that trusts A. Configure the AWS provider with an `assume_role` block pointing to B's role.

**55. Q: What is the risk of `terraform apply -auto-approve` in production?**

**A:** It bypasses human review. If drift or a bad commit causes destructive changes, it executes immediately.

**56. Q: A PR alters a `null_resource` to exfiltrate env vars. How do you prevent execution during PR validation?**

**A:** Ensure PR validation _only_ runs `validate` and `plan`. Never run `apply`, and use scoped down IAM roles for PR plans.

**57. Q: You are writing a DB module. How do you prevent users from checking the password into Git?**

**A:** Generate the password inside Terraform using `random_password`, save it to a secure parameter store, and do not expose it as an input variable.

**58. Q: Terraform throws a TLS verification failure when downloading from a private registry. Fix?**

**A:** Install the internal Root CA certificate onto the CI runner so it natively trusts the internal registry.

**59. Q: Why is "least privilege" difficult for Terraform execution roles?**

**A:** Terraform requires broad Read/List permissions across many services to calculate drift and build dependency graphs.

**60. Q: A security scan flags your state file for containing an SSH key generated by `tls_private_key`. Resolution?**

**A:** Migrate to generating keys externally (KMS/Vault) and injecting them, as the `tls` provider stores keys locally in plaintext.

### **61-80: CI/CD, Drift & Automation**

**61. Q: Manual changes were made to an ASG capacity. You want Terraform to adopt them, not revert. How?**

**A:** Update the `.tf` code to match the new manual capacity, then run `apply`.

**62. Q: In Atlantis, two devs open PRs targeting the same directory. What happens?**

**A:** Atlantis locks the workspace on the first PR. The second dev cannot run a plan until the first is merged/closed or the lock is manually released.

**63. Q: A plan in CI fails randomly due to AWS API rate limits. Mitigation?**

**A:** Increase `max_retries` in the provider block, or reduce concurrency with the `-parallelism` CLI flag.

**64. Q: Using GitHub Actions, how do you pass the plan from the 'Plan' job to the 'Apply' job securely?**

**A:** Run `terraform plan -out=tfplan`. Upload the binary file as an artifact, download it in the Apply job, and run `terraform apply tfplan`.

**65. Q: What happens if a resource drifts, but the attribute is marked with `ignore_changes`?**

**A:** Terraform detects it internally but will not highlight it in the plan or attempt to correct it.

**66. Q: Your CI runner fails with "out of memory" on a 10,000 resource state file. Immediate fix?**

**A:** Increase the runner's memory allocation. Long-term, split the state file.

**67. Q: You must apply a hotfix locally because CI is down. SOP?**

**A:** Pull the remote state, run apply locally, document it. Once CI is restored, run a dummy pipeline to ensure code and state are synced.

**68. Q: How do you implement "Blue/Green" deployments with Terraform?**

**A:** Deploy a second stack (Green) via a new workspace. Validate it. Update the DNS/LB resource to point to Green. Run `destroy` on the Blue workspace.

**69. Q: How do you guarantee ephemeral PR environments are destroyed when the PR closes?**

**A:** Configure a pipeline triggered by the `pull_request` `closed` event that runs `destroy -auto-approve` targeting that specific PR's workspace.

**70. Q: A teammate suggests running `terraform refresh` in CI before planning. Is this necessary?**

**A:** No. In modern Terraform (0.15+), `plan` automatically performs a refresh phase. Explicit refresh is obsolete and modifies state directly.

**71. Q: Pipeline is stuck destroying an EC2 instance that was already manually deleted. Fix?**

**A:** Cancel the pipeline. Run `terraform state rm aws_instance.name` to clear the blockage.

**72. Q: Can you deploy to GCP and AWS simultaneously in the same CI job?**

**A:** Yes. Define multiple providers in the config; Terraform calculates the graph and provisions concurrently.

**73. Q: How do you dynamically inject a Git commit hash into a resource tag?**

**A:** Pass it as an environment variable (`TF_VAR_commit_hash=$GIT_COMMIT`), define the variable in code, and apply it to tags.

**74. Q: What tool estimates cloud costs for a PR before applying?**

**A:** Infracost. It parses the plan JSON and comments on the PR.

**75. Q: In a monorepo, how do you ensure CI only runs Terraform for the changed directory?**

**A:** Use path-filtering logic in the pipeline (e.g., `paths: ['serviceA/infra/']`) or tools like Terragrunt `run-all`.

**76. Q: Should you use `local-exec` to run a Python script _before_ Terraform initializes?**

**A:** No. `local-exec` runs during apply. Handle pre-init scripts in the CI pipeline bash wrapper.

**77. Q: Security requires all applies to be logged to a SIEM. How?**

**A:** Use Terraform Cloud audit webhooks, or wrap the open-source CLI command in a script that pipes stdout to the SIEM via API.

**78. Q: How do you test Terraform logic locally without hitting cloud APIs?**

**A:** Use `terraform test` (v1.6.0+) or Terratest.

**79. Q: Pipeline shows a successful apply, but a cloud-init script fails inside the VM. Why?**

**A:** Terraform provisions the infrastructure. It does not natively monitor internal OS execution states unless signal wait conditions are coded.

**80. Q: How do you handle Terraform binary version mismatches between dev laptops and CI?**

**A:** Use `tfenv` with a `.terraform-version` file to enforce binary consistency.

### **81-100: Edge Cases & Multi-Cloud**

**81. Q: You need to manage an internal API, but no provider exists. Options?**

**A:** 1) Write a custom Go provider. 2) Use the `restapi` community provider. 3) Use `local-exec` to curl (least preferred).

**82. Q: An Azure RG destruction fails because it contains untracked manual resources. Fix?**

**A:** Manually delete or import the untracked resources. Terraform prioritizes safety and won't delete what it doesn't own.

**83. Q: A GCP instance needs an AWS instance's public IP. How does Terraform handle the graph?**

**A:** Reference the AWS output in the GCP input. Terraform provisions AWS first, resolves the IP, then provisions GCP.

**84. Q: A legacy app requires a specific dynamic IP (`10.0.0.50`) to be locked. How?**

**A:** Define `private_ip = "10.0.0.50"`. If running, convert to static via the cloud console first, then apply.

**85. Q: What is the risk of using `dynamic` blocks based on frequently changing external data sources?**

**A:** Constant drift detection. Terraform will apply changes and recreate nested rules unexpectedly during routine runs.

**86. Q: You deleted a `.tf` file, but the state still has the resource. You run apply. What happens?**

**A:** Terraform executes a `destroy` action to align reality (state) with the configuration (empty).

**87. Q: How do you map a nested JSON string inside a Secrets Manager secret to Terraform variables?**

**A:** Retrieve it via data source, then use `jsondecode()` to parse the string into a map.

**88. Q: Terraform shows a massive diff for an IAM policy just because keys are reordered. Fix?**

**A:** Use `jsonencode()` or the `aws_iam_policy_document` data source to normalize the JSON and suppress semantic diffs.

**89. Q: What primary problem does Terragrunt solve?**

**A:** It keeps configurations DRY by allowing you to define backend/provider configs once and inherit them across directories.

**90. Q: A resource requires a base64 string, but your input is standard text. Inline fix?**

**A:** Use `base64encode(var.my_string)`.

**91. Q: You need the index of an item while using `for_each` on a set. Problem?**

**A:** Sets have no guaranteed order. Convert to a list `tolist(my_set)` and use `count`, or derive a unique key.

**92. Q: AWS releases a new resource property that the provider doesn't support yet. Can you manage it?**

**A:** Not directly. Use an escape hatch (like `aws_cloudformation_stack`) or wait for the provider update.

**93. Q: How do you prevent developers from accidentally upgrading state with a newer CLI?**

**A:** Define `required_version = "~> 1.5.0"` in the `terraform` block.

**94. Q: Can you mask only the sensitive parts of a single output map?**

**A:** No. If any part of a data structure is derived from a sensitive value, the entire structure is masked.

**95. Q: How do you reference the ARN of the role currently executing Terraform?**

**A:** Use the `aws_caller_identity` data source.

**96. Q: Terraform hangs indefinitely creating a DNS record. Why?**

**A:** The API is waiting for an asynchronous verification (like DNS propagation). It will hang until the internal timeout is reached.

**97. Q: Why is tagging an EC2 instance with `timestamp()` a bad idea?**

**A:** It evaluates on every run, causing constant drift and modifying tags on every single apply.

**98. Q: An AWS region might not support an instance type. Can Terraform handle `try/catch`?**

**A:** Yes, Terraform 0.15+ supports the `try()` function to evaluate expressions and return the first one without an error.

**99. Q: The DynamoDB locking table is deleted. What happens to locked sessions?**

**A:** Locks are lost. Concurrent pipelines will execute simultaneously, risking severe state corruption.

**100. Q: You inherit a 5,000-line `main.tf`. What is your refactoring plan?**

**A:** 30 days: Implement remote state/CI. 60 days: Group logic into `network.tf`, `compute.tf`, extract variables. 90 days: Abstract patterns into versioned modules.