  


How do i rollback tfstate file , need exact steps

  

Rolling back a Terraform state file is a serious operation because you are changing Terraform's source of truth. Before doing it, determine whether you need to:

1. Restore a previous state version (state got corrupted/deleted).
    
2. Undo infrastructure changes (resources were modified/destroyed).
    
3. Recover from an accidental `terraform apply`.
    

The steps differ.

### If you use S3 Backend with Versioning Enabled (most common)

Check available versions:

```
aws s3api list-object-versions \  --bucket <bucket-name> \  --prefix <state-file-key>
```

Example:

```
aws s3api list-object-versions \  --bucket my-tf-state \  --prefix prod/vpc/terraform.tfstate
```

You'll see VersionIds.

Download the older version:

```
aws s3api get-object \  --bucket my-tf-state \  --key prod/vpc/terraform.tfstate \  --version-id <VERSION_ID> \  old.tfstate
```

Take a backup of current state:

```
terraform state pull > current-backup.tfstate
```

Push the old state:

```
terraform state push old.tfstate
```

Verify:

```
terraform state listterraform plan
```

### If using Local State

Check backups:

```
ls -ltr
```

Terraform usually creates:

```
terraform.tfstateterraform.tfstate.backup
```

Restore:

```
cp terraform.tfstate.backup terraform.tfstate
```

Then:

```
terraform plan
```

### If Infrastructure Changed But State Was Rolled Back

Suppose:

- Current infrastructure = EC2 exists
    
- Old state = EC2 not present
    

After rollback:

```
terraform plan
```

Terraform may try to create resources that already exist.

In such cases:

```
terraform import
```

or

```
terraform refresh
```

may be needed to realign state.

### If You Want to Undo a Bad Apply

State rollback alone is not enough.

Example:

- State version N = 2 EC2s
    
- Apply creates 3rd EC2
    
- Roll back state to version N
    

Now Terraform forgets the 3rd EC2 exists, but the EC2 is still running and billing.

Instead:

```
git checkout <previous-working-code>terraform apply
```

or

```
terraform destroy -target <resource>
```

depending on what changed.

### Interview Point

"Terraform state rollback only restores Terraform's metadata. It does not roll back actual infrastructure. After restoring a previous state version, always run `terraform plan` to identify drift between the restored state and real infrastructure."

One question: are you using **local state**, **S3 backend with versioning**, or **Terraform Cloud**? The exact recovery procedure depends on that.