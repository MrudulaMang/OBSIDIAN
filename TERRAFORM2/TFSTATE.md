tfstate file will be in .Terraform folder
tfstate is created when init, with empty attrib values

The `terraform.tfstate` file is Terraform's **database of reality**. It records what Terraform believes it has created and how those resources map to your configuration.

Yes. Terraform **always reads the state file before planning or applying**, so if you manually change the state file, Terraform will use that modified information AND compoares that to in aws and detects the DRIFT, WHEN U TERRA PLAN

Yes. If you change AWS **and then manually modify the state file to match that change**, Terraform may not detect any drift.

-----------------------

For example, if you create a VPC:

```
resource "aws_vpc" "main" {  cidr_block = "10.0.0.0/16"}
```

Terraform may store something like:

```
{  "resources": [    {      "type": "aws_vpc",      "name": "main",      "instances": [        {          "attributes": {            "id": "vpc-0abc123",            "cidr_block": "10.0.0.0/16"          }        }      ]    }  ]}
```
The state file contains:

1. Resource IDs
    - VPC IDs (`vpc-xxxx`)
    - Subnet IDs (`subnet-xxxx`)
    - Security Group IDs (`sg-xxxx`)
    - EC2 IDs (`i-xxxx`)
2. Resource Attributes
    - CIDRs
    - Tags
    - ARNs
    - IP addresses
    - DNS names
3. Resource Mapping

```
aws_vpc.main  --->  vpc-0abc123aws_instance.web ---> i-012345
```

This mapping lets Terraform know which real AWS resource belongs to which Terraform resource block.

4. Outputs

```
output "vpc_id" {  value = aws_vpc.main.id}
```

Output values are stored in state.

5. Metadata

- Provider versions
- Terraform version
- Dependencies
- Resource relationshipsThe state file contains:

1. Resource IDs
    - VPC IDs (`vpc-xxxx`)
    - Subnet IDs (`subnet-xxxx`)
    - Security Group IDs (`sg-xxxx`)
    - EC2 IDs (`i-xxxx`)
2. Resource Attributes
    - CIDRs
    - Tags
    - ARNs
    - IP addresses
    - DNS names
3. Resource Mapping

```
aws_vpc.main  --->  vpc-0abc123aws_instance.web ---> i-012345
```

This mapping lets Terraform know which real AWS resource belongs to which Terraform resource block.

4. Outputs

```
output "vpc_id" {  value = aws_vpc.main.id}
```

Output values are stored in state.

5. Metadata

- Provider versions
- Terraform version
- Dependencies
- Resource relationships

