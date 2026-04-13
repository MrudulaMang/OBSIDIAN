
--nc -zv <mongodb-private-ip> 27017
	### 🔹 `nc`
	- Stands for **netcat**
	- Used to **test connectivity between machines**
	outputs
	  Connection to 10.0.2.15 27017 port [tcp/*] succeeded!
	  Connection timed out
		👉 Means:
		- Traffic NOT reaching destination
		- Blocked by:
		    - Security Group
		    - NACL
		    - routing
	  Connection refused
		  👉 Means:
		- Reached the machine ✅
		- BUT nothing listening on port ❌
		(→ MongoDB down or misconfigured)
	------------------
	cat /etc/mongod.conf | grep bindIp
	-------------
	cat /etc/my.cnf | grep bind
	-----------------------
	# PROCESS LEVEL DEBUG (ADVANCED)
	ps -ef | grep mongo  
	ps -ef | grep mysql
	---------------------
	# WHO IS USING PORT?
	lsof -i :27017  
	lsof -i :3306
	-------------------------
	# REAL NETWORK DEBUG (RARE BUT POWERFUL)
	tcpdump -i any port 27017
	 👉 If packets not coming → network issue  
	👉 If coming but no response → service issue