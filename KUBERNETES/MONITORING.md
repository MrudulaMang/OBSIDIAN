DEFAULT monitoring is CLOUDWATCH , should be enabled in eks.yml if needed
   -> eksctl utils update-cluster-logging --enable-types={ specify yuor log types here e.g. all} --region=us-east-1 --cluster=roboshop
external is prometheus

default addon vpc-cni, kube-proxy, coredns, metrics-server , to be specified if needed

