
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