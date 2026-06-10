  [60-CATALAOGUE]
wheen there are three steps, instance creation, instance stopping and ami creation what order does terra follow, note: there is depblock ends on declared in stop instance which is on instance creation

  

Terraform builds a dependency graph and executes resources based on that graph, not based on the order they appear in the file.

Suppose you have:

1. EC2 instance creation
    
2. Stop instance (`terraform_data` or `null_resource`)
    
3. AMI creation
    

And:

- Stop instance has `depends_on = [aws_instance.myserver]`
    
- AMI creation depends on stop instance
    

Then the execution order will be:

```
aws_instance.myserver        ↓terraform_data.stop_instance        ↓aws_ami_from_instance.myami
```

Terraform will:

1. Create EC2 instance
    
2. Wait until instance creation is complete
    
3. Execute stop script/resource
    
4. Wait until stop operation completes
    
5. Create AMI from the stopped instance
    

Example:

```
resource "aws_instance" "app" {  ...}resource "terraform_data" "stop_instance" {  depends_on = [aws_instance.app]  provisioner "local-exec" {    command = "aws ec2 stop-instances --instance-ids ${aws_instance.app.id}"  }}resource "aws_ami_from_instance" "app_ami" {  name               = "app-ami"  source_instance_id = aws_instance.app.id  depends_on = [terraform_data.stop_instance]}
```

Execution:

```
terraform apply↓Create EC2↓Run stop command↓Wait for terraform_data to finish↓Create AMI
```

One subtle issue: Terraform only knows that the stop command finished, not that the instance is actually in the `stopped` state.

For example:

```
aws ec2 stop-instances --instance-ids i-123
```

returns almost immediately while AWS may take 30–90 seconds to fully stop the instance.

In that case AMI creation might start too early.

Production-grade approach:

```
aws ec2 stop-instances --instance-ids i-123aws ec2 wait instance-stopped --instance-ids i-123
```

or use a data/resource that explicitly waits for the instance state before creating the AMI.

If you paste your actual Terraform resources (instance, stop block, and AMI block), I can trace the exact dependency graph Terraform will build.

  

In your case, Terraform will build this dependency chain:

```
aws_instance.catalogue        ↓terraform_data.catalogue        ↓aws_ec2_instance_state.catalogue        ↓aws_ami_from_instance.catalogue
```

Why?

### Step 1: Instance Creation

```
resource "aws_instance" "catalogue"
```

Terraform creates the EC2 first because other resources reference:

```
aws_instance.catalogue.idaws_instance.catalogue.private_ip
```

---

### Step 2: Bootstrap

```
resource "terraform_data" "catalogue"
```

This implicitly depends on the instance because:

```
host = aws_instance.catalogue.private_iptriggers_replace = [  aws_instance.catalogue.id]
```

Terraform cannot execute the provisioners until the instance exists.

So:

```
Create EC2↓Copy bootstrap.sh↓Run bootstrap.sh
```

---

### Step 3: Stop Instance

```
resource "aws_ec2_instance_state" "catalogue"
```

You explicitly added:

```
depends_on = [terraform_data.catalogue]
```

Therefore Terraform waits for all provisioners to finish before stopping the instance.

```
Bootstrap Complete↓Stop EC2
```

---

### Step 4: Create AMI

```
resource "aws_ami_from_instance" "catalogue"
```

You added:

```
depends_on = [aws_ec2_instance_state.catalogue]
```

So Terraform waits for the stop operation.

```
Instance Stopped↓Create AMI
```

---

The important detail is that you are using:

```
resource "aws_ec2_instance_state"
```

not a `local-exec` command.

`aws_ec2_instance_state` is managed by the AWS provider and waits until the instance actually reaches the target state (`stopped`).

So unlike:

```
aws ec2 stop-instances
```

which returns immediately,

this resource effectively does:

```
Stop Instance↓Wait until stopped↓Resource complete
```

Therefore your AMI creation should not race ahead before the instance is fully stopped.

Final execution flow:

```
aws_instance.catalogue        ↓terraform_data.catalogue        ↓aws_ec2_instance_state.catalogue        ↓aws_ami_from_instance.catalogue
```

One thing to think about as a DevOps engineer: do you actually need to stop the instance before creating the AMI?

For many applications AWS can create crash-consistent AMIs from a running instance. Stopping gives cleaner filesystem consistency but increases build time and causes downtime. The trade-off depends on whether this is a bake pipeline, a production server, or an ephemeral image-builder instance. That's the architectural question worth asking rather than just whether the dependencies work.

  

even thouh i use depends on ec2 instanc creation in stop blocck, will it wait will terraform data completes its job i mean the configuration, it takes time right

  

Yes, in your current code it **will wait**.

Let's separate two possibilities.

### Case 1: Your current code

```
resource "aws_ec2_instance_state" "catalogue" {  instance_id = aws_instance.catalogue.id  state       = "stopped"  depends_on = [terraform_data.catalogue]}
```

Here Terraform sees:

```
terraform_data.catalogue        ↓aws_ec2_instance_state.catalogue
```

A resource is not considered complete until **all its provisioners finish successfully**.

So Terraform does:

```
Create EC2↓Copy bootstrap.sh↓Execute bootstrap.sh↓Wait for bootstrap.sh to finish↓terraform_data.catalogue complete↓Stop instance
```

Even if your bootstrap script takes:

```
5 min10 min30 min
```

Terraform waits.

---

### Case 2: If you had written

```
resource "aws_ec2_instance_state" "catalogue" {  instance_id = aws_instance.catalogue.id  state       = "stopped"  depends_on = [aws_instance.catalogue]}
```

instead of:

```
depends_on = [terraform_data.catalogue]
```

Then the graph becomes:

```
aws_instance.catalogue       ↙       ↘terraform_data   aws_ec2_instance_state
```

Now both resources depend only on the EC2.

Terraform is free to run them in parallel.

Possible outcome:

```
Create EC2↓Start bootstrap↓Stop instance
```

Your SSH session could get killed while provisioning.

---

### Rule of thumb

If Resource B must wait for Resource A's provisioners:

```
depends_on = [resource_A]
```

not

```
depends_on = [resource_A's dependencies]
```

In your code:

```
aws_instance    ↓terraform_data    ↓aws_ec2_instance_state    ↓aws_ami_from_instance
```

The stop operation cannot start until the entire bootstrap process has completed successfully. Terraform treats the `terraform_data` resource as unfinished until every `file` and `remote-exec` provisioner has finished.

  

so i can use this depends_on = [terraform_data.catalogue] or depends_on = [aws_ec2_instance_state.catalogue]

  

Yes, and they mean different things.

For the AMI resource:

```
resource "aws_ami_from_instance" "catalogue" {  ...  depends_on = [aws_ec2_instance_state.catalogue]}
```

This is the correct dependency because you want:

```
Instance Created    ↓Bootstrap Complete    ↓Instance Stopped    ↓AMI Created
```

The graph is:

```
aws_instance.catalogue        ↓terraform_data.catalogue        ↓aws_ec2_instance_state.catalogue        ↓aws_ami_from_instance.catalogue
```

If instead you wrote:

```
depends_on = [terraform_data.catalogue]
```

for the AMI resource, then Terraform only knows:

```
Bootstrap Complete    ↓AMI Creation
```

and separately:

```
Bootstrap Complete    ↓Stop Instance
```

So Terraform may do:

```
Bootstrap Complete      ↓   /     \Stop     AMI
```

in parallel.

You would lose the guarantee that the instance is stopped before the AMI is created.

---

A useful principle:

Depend on the **last thing that must happen before me**, not on some earlier step.

For:

- Stop instance → depends on `terraform_data.catalogue`
    
- Create AMI → depends on `aws_ec2_instance_state.catalogue`
    

That's exactly how your code is written now, and it's the cleanest dependency chain.