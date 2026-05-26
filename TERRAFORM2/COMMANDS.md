
------------
[
 Remove-Item -Recurse -Force .terraform
	 OR 
 rm -rf .terraform
 terraform init
]

Remove-Item -Recurse -Force .terraform
Remove-Item -Force .terraform.lock.hcl
terraform init

For just refreshing downloaded modules without deleting manually:

```
terraform init -upgrade
```

Use deletion + `terraform init` when troubleshooting stubborn module issues.
# terraform fmt -check
# terraform validate



----terraform init -migrate-state
	Use this if you intentionally changed backend location and want Terraform to move the existing state there.

	Example:
	Old:
	```
	bucket = "old-bucket"
	```
	New:
	```
	bucket = "new-bucket"
	```
	Then use:
	```
	terraform init -migrate-state
	```
	Terraform attempts to move the state.


----`terraform init -reconfigure
		Use this if:
		
		- there is no important old state to migrate
		- you want Terraform to forget old backend settings
		- this is a fresh setup
		- previous backend config was wrong
		
		Example:
		
		```
		terraform init -reconfigure
		```
		
		This does NOT move state.  
		It just accepts the new backend config.
		

-----------------------------
Core Terraform commands are not the important part. The important part is understanding which phase of the infrastructure lifecycle each command belongs to.

Most beginners memorize commands. Strong engineers think in terms of:

- authoring
- validating
- planning
- provisioning
- operating
- recovering
- destroying

Here’s the structured map.

Initialization & Setup

```
terraform init
```

Initialize working directory.

```
terraform init -upgrade
```

Upgrade providers/modules.

```
terraform get
```

Download modules.

```
terraform get -update
```

Update modules.

Validation & Formatting

```
terraform fmt
```

Format files.

```
terraform fmt -recursive
```

Format recursively.

```
terraform validate
```

Validate configuration syntax and internal consistency.

Planning & Execution

```
terraform plan
```

Preview changes.

```
terraform plan -out=tfplan
```

Save execution plan.

```
terraform apply
```

Apply infrastructure changes.

```
terraform apply tfplan
```

Apply saved plan.

```
terraform apply -auto-approve
```

Skip confirmation.

```
terraform destroy
```

Destroy infrastructure.

```
terraform destroy -target=aws_instance.web
```

Destroy specific resource.

Targeting & Refresh

```
terraform plan -target=module.vpc
```

Target specific resource/module.

```
terraform refresh
```

Refresh state from real infrastructure.  
(Largely deprecated in newer workflows.)

State Management

This is where real Terraform maturity starts.

```
terraform state list
```

List tracked resources.

```
terraform state show aws_instance.web
```

Show state details.

```
terraform state mv
```

Move resource inside state.

```
terraform state rm
```

Remove resource from state.

```
terraform state pull
```

Download remote state.

```
terraform state push
```

Upload state manually.

```
terraform state replace-provider
```

Replace provider references in state.

Importing Existing Infrastructure

```
terraform import aws_instance.web i-1234567890
```

Bring existing infrastructure under Terraform management.

Workspace Management

```
terraform workspace list
```

List workspaces.

```
terraform workspace new dev
```

Create workspace.

```
terraform workspace select prod
```

Switch workspace.

```
terraform workspace delete dev
```

Delete workspace.

Output & Console

```
terraform output
```

Show outputs.

```
terraform output vpc_id
```

Specific output.

```
terraform console
```

Interactive Terraform expression shell.

Providers & Dependencies

```
terraform providers
```

Show provider dependencies.

```
terraform providers lock
```

Create provider lock file.

Graph & Visualization

```
terraform graph
```

Generate dependency graph.

Advanced / Recovery

```
terraform force-unlock LOCK_ID
```

Remove stuck state lock.

```
terraform taint aws_instance.web
```

Mark resource for recreation.  
(Deprecated directionally; replaced by `-replace`.)

```
terraform apply -replace=aws_instance.web
```

Force recreate resource.

Testing & Inspection

```
terraform show
```

Show state or plan details.

```
terraform show tfplan
```

Inspect saved plan.

```
terraform version
```

Terraform version info.

```
terraform login
```

Authenticate with Terraform Cloud.

terraform apply -var-file=dev.tfvars (values in tfvars override the variable deafault values)

Mental model you should build:

Terraform commands map to operational phases:

| Phase         | Important Commands          |
| ------------- | --------------------------- |
| Bootstrap     | init, workspace             |
| Authoring     | fmt, validate               |
| Change Review | plan, show                  |
| Deployment    | apply                       |
| Operations    | output, console             |
| Recovery      | state, import, force-unlock |
| Refactoring   | state mv, replace-provider  |
| Destruction   | destroy                     |

Most junior engineers stop at:

- init
- plan
- apply

Senior Terraform work starts at:

- state surgery
- imports
- dependency graph reasoning
- safe migrations
- blast radius control
- drift recovery
- module version governance
- multi-environment architecture

That distinction matters in interviews and real outages.