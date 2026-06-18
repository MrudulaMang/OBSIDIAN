cat /etc/passwd - list all the usrs and details
cut -d: -f1 /etc/passwd ---- shows only the user names
    cut -d: -f5 /etc/passwd
awk -F: '$3 >= 1000 {print $1}' /etc/passwd ------------shows human users
id -shows the current user groups and gid
		uid=1001(ec2-user) gid=1001(ec2-user) groups=1001(ec2-user),989(docker)
id ec2-user

cat /etc/group or getent group -------list of all groups
groups  -shows just groups of current users
groups ec2-user - for specific user
### See members of a particular group
getent group docker
	Example:
	docker:x:993:ec2-user,john
For troubleshooting Docker permission issues, these are the commands I typically run:
	id ec2-user
	groups ec2-user
	getent group docker
	ls -l /var/run/docker.sock
