ls /tmp/*.zip | tail -n 7 | xargs -I {} cp {} /c/devops/app/
copy only zip files fromone folder to another

unzip
  unzip catalogue.zip

root to ec2 user 
	su - ec2-user
ec2-user to root
	sudo su
ifconfig
   eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  
        inet 192.168.1.10  
        netmask 255.255.255.0  
        ether 08:00:27:4e:66:a1

	- **eth0** → Interface name
	- **inet** → IP address
	- **netmask** → Subnet mask
	- **ether** → MAC address
	- **UP/RUNNING** → Interface is active
	

	In real production systems:

	- You’ll rarely use `ifconfig`
	- You’ll use:
	    - `ip addr`
	    - `ip route`
	    - `ss` / `netstat`
	    - Cloud networking (VPC, ENI, SGs)
	
	👉 Interview tip:
	
> 	If you still say `ifconfig`, it signals **old-school Linux usage**  
> 	If you say `ip`, it signals **modern systems understanding**
	
	---
	
	## ⚡ Quick Mapping
	
	|Old (`ifconfig`)|New (`ip`)|
	|---|---|
	|`ifconfig`|`ip addr`|
	|`ifconfig eth0 up`|`ip link set eth0 up`|
	|`ifconfig eth0 down`|`ip link set eth0 down`|

---

If you want, I can give you a **real production debugging scenario** where checking IP + routes actually saves an outage (this is exactly your target skillset).