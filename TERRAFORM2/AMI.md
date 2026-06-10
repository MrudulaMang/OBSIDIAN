**What does the AMI contain?**

When you create:

```
resource "aws_ami_from_instance" "catalogue"
```

the AMI captures:

```
OS (RHEL)├── Installed packages├── Catalogue code├── Config files├── Systemd services├── Environment settings├── Application dependencies└── Everything present on disk
```

It does **NOT** contain:

```
Instance TypeSecurity GroupsSubnetPrivate IPPublic IPIAM RoleAuto Scaling settings
```

That's why in the Launch Template you still specify:

```
instance_type = "t3.micro"vpc_security_group_ids = [...]
```

Because AMI answers:

> "What disk image should I boot from?"

Launch Template answers:

> "How should this instance be created?"

So:

```
AMI│├── OS├── App├── Packages└── ConfigurationLaunch Template│├── Instance Type├── Security Groups├── IAM Role├── User Data├── Shutdown behavior└── TagsAuto Scaling Group│├── Min├── Max├── Desired└── Scaling rules
```

A useful interview question is:

> If AMI already has the application, why create a Launch Template?

Answer:

> AMI only defines the machine image. Auto Scaling needs additional information such as instance type, security groups, IAM role, tags, and launch configuration. Launch Template combines the AMI with those runtime settings so ASG can launch identical servers repeatedly.