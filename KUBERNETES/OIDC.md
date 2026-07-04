> export cluster_name=myeksctluster
> oidc= $(aws eks describe-cluster --name $cluster_name --query "cluster,identity,oidc.issuer" --output text | cut -d '/' -f 5)
>    ----gives oicd id
> eksctl utils asscociate-iam-oidc-provider --cluster $cluster_name --approve
>   --oidc is associated to my cluster
> create a policy which should have permission related to elb, createa iam role and attach it to alb controller  
>  ---- curl.... github ,  iam_policy dowload for aws lb controller
>    ---- create policy in aws: > aws iam create-policy.... with dowloaded policy.json
>    assign iam role to service account
>      --- eksctl create iamserviceaccount
> 		     -- with aws acct id, cluster name, iam role name, policy name
> totally cloud formation is created under the hood, incase u already have servie acct, use --override	
> 
------dowlaod ALB CONTROLLER
	install helm
	ADD HELM REPO EKS
	 helm install aws load baln controller with
		 -namespcae vpc id, region where u hav the cluster, cluster name
 
 chekc alb pods are running, u should see 2 pods in running state, 1/1 1 containre by one contaier
 kubectl logs -n kube-system
 kubectl logs  alb podname -n kube-system
>    