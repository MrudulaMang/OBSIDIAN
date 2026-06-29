
Terms like **t2**, **t3**, and **m5** refer to **EC2 instance families**, while **micro**, **large**, and **medium** refer to the **size** within that family.

Think of it like buying a car:

- **Family** = Model (Toyota Corolla, Camry)
- **Size/Variant** = Base, Sport, Premium

For EC2:

```
Instance Type = Family + Size
t2.micro│ 
│
	│ 
	└── Size
└──── Family
```

Examples:

|Instance Type|Family|Size|
|---|---|---|
|t2.micro|T2|micro|
|t3.micro|T3|micro|
|t3.medium|T3|medium|
|m5.large|M5|large|

### What does the family mean?

The family indicates the purpose and underlying hardware characteristics.

- **T2** → Burstable general-purpose instances (older generation).
- **T3** → Newer burstable general-purpose instances with better price/performance than T2.
- **M5** → General-purpose instances for sustained workloads; they do not rely on CPU credits like T2/T3.

### What does the size mean?

The size determines the amount of resources.

For example:

|Size|vCPUs|Memory|
|---|---|---|
|micro|Small|Small|
|medium|More than micro|More RAM|
|large|Larger|More RAM|
|xlarge|Even larger|Even more RAM|

Within the same family, larger sizes provide more CPU and memory.

### Example

```
t3.micro
```

- Family: **T3**
- Size: **micro**
- Small amount of CPU and memory

```
t3.medium
```

- Same **T3** family
- Same burstable behavior
- More CPU and memory than `t3.micro`

```
m5.large
```

- Different family (**M5**)
- Different workload characteristics
- More CPU and memory than the smaller T-series instances, intended for sustained usage

### Easy way to remember

```
EC2 Instance TypeFamily      Size------      -----t2          microt3          mediumm5          largec5          xlarger6g         2xlarge
```

**Family** tells you **what kind of machine it is** (burstable, general purpose, compute optimized, memory optimized, etc.).

**Size** tells you **how powerful that machine is** (how much CPU, RAM, and networking resources it has).

------------
**Burstable** means the instance can **temporarily use more CPU than its normal performance** when needed.

Think of it like this.

Imagine you're driving a car.

- Normally, you drive at **40 km/h**.
- When you need to overtake another car, you press the accelerator and drive at **100 km/h** for a short time.
- After that, you go back to **40 km/h**.

That's exactly how a burstable EC2 instance works.

### How AWS does this

AWS uses something called **CPU credits**.

When your instance is mostly idle, it **earns CPU credits**.

Example:

```
Idle for 1 hour      ↓Earn 60 CPU credits
```

Later, if your application suddenly needs more CPU:

```
Normal CPU: 20%      ↓Traffic increases      ↓CPU bursts to 100%      ↓Uses stored CPU credits
```

When the credits are used up, the instance goes back to its baseline performance.

### Example

Suppose you have a `t3.micro`.

At night:

```
CPU Usage = 5%
```

Since it's doing almost nothing, it accumulates CPU credits.

The next morning:

```
100 users visit your website.
```

The CPU can jump to:

```
100%
```

using those saved credits.

After the traffic drops, it starts earning credits again.

### Analogy: Mobile data

Imagine your mobile plan gives you:

- Normal speed all the time.
- A bonus of **10 GB high-speed data**.

You can use that bonus whenever you need it. Once it's exhausted, you're back to the normal speed.

CPU credits work in a similar way.

### Burstable vs Non-burstable

|Burstable (T2, T3, T4g)|Non-burstable (M5, C5, R5)|
|---|---|
|Uses CPU credits|No CPU credits|
|Can burst to high CPU temporarily|Can sustain high CPU continuously|
|Lower cost|Higher cost|
|Best for variable workloads|Best for constant workloads|

### When to use burstable instances

Good for:

- Small websites
- Development servers
- Jenkins server with occasional builds
- Bastion host
- Test environments
- Low-traffic applications

Not good for:

- Kubernetes worker nodes with constant load
- Databases under heavy traffic
- Video encoding
- Machine learning training
- High-traffic production applications

### Interview answer

> A burstable instance is an EC2 instance that provides a baseline level of CPU performance but can temporarily burst to higher CPU usage by consuming accumulated CPU credits. It is suitable for workloads with occasional spikes in CPU demand but is not intended for applications that require sustained high CPU 
> 
> usage.