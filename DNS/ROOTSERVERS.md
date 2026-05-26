Root servers mainly store one thing:

```
Where Top-Level Domain (TLD) servers are
```

That’s it.

They do NOT store:

- all websites
- all domain → IP mappings
- full internet DNS data

They only know:

```
Who handles:.com.org.in.net.io...
```

Think of root servers as:

```
Directory of directories
```

Example lookup:

You type:

```
openai.com
```

Recursive resolver asks root server:

```
"Who knows about .com?"
```

Root server responds:

```
"Ask these .com TLD servers"
```

It returns NS records + IP addresses for `.com` TLD servers.

Then resolver asks `.com` servers:

```
"Who knows openai.com?"
```

Then `.com` says:

```
"Ask OpenAI authoritative servers"
```

Then authoritative server gives final answer:

```
openai.com → IP address
```

So root server data internally looks conceptually like:

```
.com  → nameserver list.org  → nameserver list.in   → nameserver list.net  → nameserver list
```

Mostly:

- NS records
- glue A/AAAA records

Example simplified root zone:

```
com.   NS   a.gtld-servers.net.com.   NS   b.gtld-servers.net.a.gtld-servers.net. A 192.x.x.x
```

Important term:  
“glue records”

These are IPs included so resolvers can actually reach the next DNS server.

Without glue records:  
you get circular dependency problems.

---

Mental compression:

```
Root servers know:"where TLDs live"TLD servers know:"where domains live"Authoritative servers know:"actual DNS records"
```

This hierarchy is what allows DNS to scale globally instead of becoming one giant impossible database.

Critical systems insight:  
Root servers almost never change compared to lower DNS layers.

That stability is intentional:

- extremely cached
- globally replicated
- heavily protected
- foundational internet infrastructure

If root DNS becomes unstable, large parts of the internet resolution chain degrade.