

Service type load balancer vs Ingress lb
only one pro: easy t configure ,change sesrvice type to load balancer.
1. configuration is not declarative, like making https, i will add hcm and do it from console not from manifet file, aws created the lb here, all the configuration of lb is changed or updated from ui of aws , and difficult to keep track this is called lack of declarative approach
2. other, Lb have 1000's of properties, uca n configure many thigns like lb algorithm, https by adding tls....
3. not cost effective for every service a load balancer is created , eg fro 10 services 10 lb are created and hey are costly. nginx,f5 type lb solves this one lb many services.
4. u can get only ALB, I CANNOT change to another lb. ccm can onky create alb.
5. cannot support a cluster that cannot have ccm like minicube or any any other cluster

ingree
1. declarative, using annotations or labels can modify many properties
2. cost effective, using path or host based routing can create one LB and create target grps, so that one lb can rout to many services 
3. can create f5 controller or envoy controller or ..
4. even tought the ccm is not supported by cluster ingress can create external IP may be by using reverse proxy or something else
