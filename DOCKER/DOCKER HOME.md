/var/lib/docker

expand /var
docker run -d niginx
	-d detacched mode, run image in the bakgrnd
ps -ef shows processing running
 container is just another process running
    eg 3311- parent id whichis contaierd -docker 
port forwarding - to expose container to outside world
 docker run -d -p f 8080:80 nginx (from 8080 of instacne to container port 80
 docker exec -it <contianerid> bash/sh ----log into docker container
docker inspect <container id>---- get all details of docekr container, ip,...host port...etc
docker stats--------- shows all containers memory usage 
docker rm -f <cntrids list>
docker build -t from:1.0.0 . --- . take dockerfile from current folder to create image with versio 1.0.0
docker login
docker push <img:version> --- will reject , hav to mention url/uname/img:ver, url bydefault docker.io
	docker tag <img:version> <username>/<img:version>
		docker push <username>/<img:version>
	 
 container port cant be find in documentation ... eg: nginx 80
 using dockerfile we can create images
	 from - mentioned base os
	 run - instal packs in base os and other configs
	 
	 
 