![[ChatGPT Image May 27, 2026, 09_27_34 PM.png]]ROOT
│
├── VPC LAYER
│   │
│   ├── aws_vpc.main
│   │   ├── CIDR → var.vpc_cidr
│   │   ├── tenancy → default
│   │   ├── DNS hostnames → enabled
│   │   └── Tags → local.vpc_final_tags
│   │
│   └── aws_internet_gateway.main
│       ├── Attached to → aws_vpc.main
│       └── Tags → local.igw_final_tags
│
├── SUBNET LAYER
│   │
│   ├── PUBLIC SUBNETS
│   │   │
│   │   ├── aws_subnet.public[0]
│   │   │   ├── CIDR → var.public_subnet_cidrs[0]
│   │   │   ├── AZ → local.az_names[0]
│   │   │   ├── Public IP → true
│   │   │   └── Route → Internet Gateway
│   │   │
│   │   ├── aws_subnet.public[1]
│   │   │   ├── CIDR → var.public_subnet_cidrs[1]
│   │   │   ├── AZ → local.az_names[1]
│   │   │   ├── Public IP → true
│   │   │   └── Route → Internet Gateway
│   │   │
│   │   └── count based creation
│   │
│   ├── PRIVATE SUBNETS
│   │   │
│   │   ├── aws_subnet.private[0]
│   │   │   ├── CIDR → var.private_subnet_cidrs[0]
│   │   │   ├── AZ → local.az_names[0]
│   │   │   └── Route → NAT Gateway
│   │   │
│   │   ├── aws_subnet.private[1]
│   │   │   ├── CIDR → var.private_subnet_cidrs[1]
│   │   │   ├── AZ → local.az_names[1]
│   │   │   └── Route → NAT Gateway
│   │   │
│   │   └── count based creation
│   │
│   └── DATABASE SUBNETS
│       │
│       ├── aws_subnet.database[0]
│       │   ├── CIDR → var.database_subnet_cidrs[0]
│       │   ├── AZ → local.az_names[0]
│       │   └── Route → NAT Gateway
│       │
│       ├── aws_subnet.database[1]
│       │   ├── CIDR → var.database_subnet_cidrs[1]
│       │   ├── AZ → local.az_names[1]
│       │   └── Route → NAT Gateway
│       │
│       └── count based creation
│
├── ROUTING LAYER
│   │
│   ├── PUBLIC ROUTE TABLE
│   │   │
│   │   ├── aws_route_table.public
│   │   ├── aws_route.public
│   │   │   ├── Destination → 0.0.0.0/0
│   │   │   └── Target → Internet Gateway
│   │   │
│   │   └── Associations
│   │       ├── public subnet 0
│   │       └── public subnet 1
│   │
│   ├── PRIVATE ROUTE TABLE
│   │   │
│   │   ├── aws_route_table.private
│   │   ├── aws_route.private
│   │   │   ├── Destination → 0.0.0.0/0
│   │   │   └── Target → NAT Gateway
│   │   │
│   │   └── Associations
│   │       ├── private subnet 0
│   │       └── private subnet 1
│   │
│   └── DATABASE ROUTE TABLE
│       │
│       ├── aws_route_table.database
│       ├── aws_route.database
│       │   ├── Destination → 0.0.0.0/0
│       │   └── Target → NAT Gateway
│       │
│       └── Associations
│           ├── database subnet 0
│           └── database subnet 1
│
├── INTERNET ACCESS LAYER
│   │
│   ├── aws_eip.main
│   │   └── Elastic IP for NAT
│   │
│   └── aws_nat_gateway.main
│       ├── Uses → aws_eip.main
│       ├── Lives in → public subnet[0]
│       ├── Depends on → Internet Gateway
│       └── Provides outbound internet for:
│           ├── private subnets
│           └── database subnets
│
├── DATA FLOW
│   │
│   ├── Public Subnet Traffic
│   │   └── Subnet → Route Table → IGW → Internet
│   │
│   ├── Private Subnet Traffic
│   │   └── Subnet → Route Table → NAT → IGW → Internet
│   │
│   └── Database Subnet Traffic
│       └── Subnet → Route Table → NAT → IGW → Internet
│
├── TERRAFORM CONCEPTS USED
│   │
│   ├── count
│   │   └── Dynamic subnet creation
│   │
│   ├── count.index
│   │   └── Picks corresponding CIDR and AZ
│   │
│   ├── locals
│   │   └── Centralized naming/tag logic
│   │
│   ├── merge()
│   │   └── Combines common tags + dynamic Name tag
│   │
│   ├── dependency graph
│   │   └── Terraform auto-orders resources
│   │
│   └── depends_on
│       └── Explicit dependency for NAT Gateway
│
└── HCL DATATYPES USED
    │
    ├── string
    │   └── "default"
    │
    ├── bool
    │   └── true
    │
    ├── list(string)
    │   ├── var.public_subnet_cidrs
    │   ├── var.private_subnet_cidrs
    │   └── local.az_names
    │
    ├── map(string)
        └── tags
    
 