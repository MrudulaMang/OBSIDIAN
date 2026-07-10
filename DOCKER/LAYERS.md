DOCKER_BUILDKIT=0  docker build -rm=flase -t user:1.0.0 --no-cache .
	will get
		    classic docker ouptut
			real intermediate containers
			  not delte intermediate containers
			  create a container for each layer
			full layer logs
LIST INTERMEDITE CONTAINERS AFTER BUILD

docker create intermediate container for every instructions 
it will run next instructions in this container- and create image out of it
the it creates another intermediate contaienr nd builds image ou-t of i
so for every intruction new layers are created, docker exports all these layers into hub whle pushing the image

always keep frequently changing instructions in the bottom of the docker file to make the build process fasst and storage
	