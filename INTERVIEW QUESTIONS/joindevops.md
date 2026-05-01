1. what is terraform explain how it will work  
2. what is terraform providers  
3. how you integrate ansible with terraform  
4. write a terraform code to create a multiple Ec2 instances with for_each and count function.  
5. diff b/w for_each and count  
6. how many AWS Services you have worked on ?  
7. terraform modules  
8. which mechanism are you using in ansible and why  
9. how may servers did you configure  
10. Diff b/w Jenkins, GitHub Action, Azure Devops  
11. write a pipeline in declarative syntax  
12. why you are using Jenkins instead of codedeploy and azure devops  
13. what are ansible components  
14. write ansible push mechanism command to configure the application on remote servers  
15. write a query to create a table  
16. diff b/w delete , drop, truncate  
17. get top 10 record from the table (edited)
----------------
AWS RDS Interview Questions (DevOps Engineer).  
  
What is RDS in AWS and why is it used?  
What are different database engines supported by RDS?  
What is the difference between RDS and EC2-hosted database?  
What is Multi-AZ deployment in RDS?  
What is the difference between Multi-AZ and Read Replica?  
How does failover work in RDS?  
What are Read Replicas and when should you use them?  
How do you scale RDS vertically and horizontally?  
What is automated backup in RDS?  
What is the difference between snapshot and automated backup?  
How do you restore an RDS database?  
What is storage autoscaling in RDS?  
How do you secure RDS instances?  
What is parameter group in RDS?  
What is option group in RDS?  
How do you monitor RDS performance?  
What is Performance Insights in RDS?  
How do you troubleshoot RDS connectivity issues?  
What are common causes of RDS latency?  
What are best practices for RDS in production?
----------------------
Join DevOps  [10:18 AM]  

**Azure DevOps – Interview Questions (5+ Years Experience)**  
![:one:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/0031-fe0f-20e3@2x.png) **Microsoft**  
●Explain your end-to-end CI/CD pipeline design in Azure DevOps.  
●How do you manage multi-stage YAML pipelines across environments?  
●Difference between self-hosted and Microsoft-hosted agents? When to use each?  
●How do you secure secrets in Azure DevOps pipelines?  
●How do you handle rollback strategies in production?  
  
![:two:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/0032-fe0f-20e3@2x.png) **TCS**  
●Explain classic pipelines vs YAML pipelines.  
●How do you manage multiple projects and repositories in Azure DevOps?  
●What is a service connection and how do you secure it?  
●How do you automate deployments for IIS / Azure Web Apps?  
●How do you reduce pipeline execution time?  
  
![:three:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/0033-fe0f-20e3@2x.png) **Infosys**  
●How do you integrate SonarQube and security scans in Azure pipelines?  
●Explain artifact management in Azure DevOps.  
●How do you manage environment-specific variables?  
●What monitoring and alerting strategy do you follow post-deployment?  
●How do you handle failed deployments?  
  
![:four:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/0034-fe0f-20e3@2x.png) **Wipro**  
●Azure DevOps vs Jenkins – real project comparison.  
●How do you manage containerized deployments using Azure DevOps?  
●Explain blue-green or canary deployment approach.  
●How do you implement RBAC in Azure DevOps?  
●How do you handle hotfix deployments?  
  
![:five:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/0035-fe0f-20e3@2x.png) **Capgemini**  
●How do you design pipelines for microservices architecture?  
●How do you manage secrets using Azure Key Vault?  
●Explain pipeline triggers (CI, PR, scheduled).  
●How do you troubleshoot pipeline failures?  
●What DevOps KPIs do you track?
-------------------------------------------
1. Why is Docker networking important when running multiple containers in real projects?
2. What is the difference between the default bridge network and a custom bridge network in Docker?
3. How can one container be connected to multiple Docker networks, and why would you do that?
4. What is Amazon ECR, and why would a team use it instead of Docker Hub for storing images?
5. What are the main steps to push an existing Docker image to AWS ECR from a Linux server?
--------------------------------------------------
1.GitHub Actions Secrets  
2.Webhooks  
3.git Commands  
4.Jenkins stages  
5.if SonarQube code quality gateway failed, then how to send notification to developer  
6. Kubernetes deployment strategy and how do you rollout  
7. Write few Kubernetes commands whatever you used regularly  
8. what is NameSpace, Services  
9. Pods communicate each other within different NameSpaces  
10. Our client want to access our Kubernetes QA environment. He is is different network and different VPN. Then how can you give the specific environment with in specific NameSpace (RBAC)  
11. Terraform structure with different environment s. They want Terraform setup for communicate with different clouds as Aws, gcp and Azure  
12. what is SSL and how do you configure this, Then i shown my S3 static webpage cloud front Invalidations and ACM certificate to her.  
13. What is the most difficult scenarios in your work and how do you achieved (CloudFront Invalidations cache issue & Mysql Load issue)  
14. Write ans explain about CD part in your CICD pipeline  
15. I want to update Replicas count as 6, Write command for that specific deployment
----------------------------------
Join DevOps  [9:49 AM]  

@channel  
![:pushpin:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f4cc@2x.png) **Interview Experience – Questions Asked (Shared by a Student)**  
  
![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png) Infrastructure & Architecture  
1. From scratch, how would you create infrastructure for an application?  
2. Difference between **API Gateway** and **Load Balancer**  
3. Infrastructure design for a **monolithic application**  
4. Terraform project structure – how do you organize `.tf` files?  
![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png) Networking Concepts  
5. What is **VPC Peering**?  
6. What is a **Transitive Gateway** and how does it work?  
7. How does the **internet connect to a Kubernetes cluster**?  
![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png) Kubernetes & AWS  
8. In AWS, using **EKS / eksctl**, how do you connect to pods?  
9. How do users access your application deployed on Kubernetes?  
![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png) Security & Access Management  
10. How can you give access to an **S3 bucket** internally?  
11. How do you provide **S3 access to external users**?  
![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png) DevOps & Tooling  
12. Where do you store container images and how do you pull them?  
13. Difference between **Terraform and Ansible**  
14. In Terraform, what is **count** and **for_each**?  
![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png) Project & Experience-Based  
15. What was the **top challenge** you faced in your project?  
16. What actions did you take to **mitigate or resolve that challenge**?
-------------------------
**Company: Evernorth Health Services (Cigna)**  
**Interview Mode: Face-To-Face**  
**Role: DevOps Engineer**  
**Date: 7th February 2026**  
  
![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png) Level 1 – Core DevOps & Cloud Fundamentals  
1. Can you introduce yourself?  
2. What are the best practices in Ansible?  
3. What is the purpose of storing the Terraform state file in Amazon S3?  
4. Write a basic Dockerfile.  
5. Explain how to build a Docker image and deploy it to Kubernetes using CI/CD  
(Write Dockerfile, Kubernetes Deployment manifest, and Jenkins pipeline stages).  
6. Write a Terraform configuration to create an S3 bucket.  
7. What is Blue/Green deployment?  
8. How does a Rolling Update work?  
9. How does a Canary Deployment work?  
10. What is an Ingress Controller in Kubernetes?  
11. What are terraform taint and terraform import, and when do you use them?  
  
![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png) Level 2 – Troubleshooting, Architecture & Experience  
12. A pod is continuously restarting and entering CrashLoopBackOff. How would you troubleshoot it?  
13. How do you migrate Jenkins to GitHub Actions?  
14. You accidentally ran terraform destroy instead of terraform apply. How would you handle this situation?  
15. Can you explain your hands-on experience with Kubernetes?  
16. What security best practices have you implemented in Kubernetes?  
17. Where and how do you store secrets securely?  
18. Why are you looking to move on from your current organization?
-------------------------------
Join DevOps  [10:30 AM]  

![:rocket:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f680@2x.png) **DevOps Engineer – Model Interview Questions for Practice**  
  
![:white_check_mark:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/2705@2x.png) **Level 1 – Core DevOps, Cloud & CI/CD**  
**![:one:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/0031-fe0f-20e3@2x.png)** **Introduction & Fundamentals**  
• Can you introduce yourself?  
• What are Ansible best practices you follow in production?  
• Why do we store Terraform state files in Amazon S3?  
**![:two:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/0032-fe0f-20e3@2x.png)** **Containerization & Infrastructure as Code**  
• Write a basic Dockerfile.  
• Write a Terraform configuration to create an S3 bucket.  
• What are `terraform taint` and `terraform import`, and when do you use them?  
**![:three:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/0033-fe0f-20e3@2x.png)** **CI/CD + Kubernetes Implementation**  
• Explain how you build a Docker image and deploy it to Kubernetes using CI/CD  
_(Dockerfile, Kubernetes Deployment manifest, Jenkins pipeline stages)_  
**![:four:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/0034-fe0f-20e3@2x.png)** **Deployment Strategies**  
• What is Blue/Green deployment?  
• How does a Rolling Update work in Kubernetes?  
• How does a Canary Deployment work?  
**![:five:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/0035-fe0f-20e3@2x.png)** **Kubernetes Networking**  
• What is an Ingress Controller in Kubernetes?  
![:white_check_mark:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/2705@2x.png) **Level 2 – Troubleshooting, Architecture & Real-World Experience**  
**![:wrench:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f527@2x.png)** **Troubleshooting**  
• A pod is continuously restarting and entering CrashLoopBackOff. How do you troubleshoot it?  
**![:building_construction:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f3d7-fe0f@2x.png)** **Architecture & Migration**  
• How would you migrate a CI/CD pipeline from Jenkins to GitHub Actions?  
• You accidentally ran `terraform destroy` instead of `terraform apply`. How would you handle this situation?  
**![:wheel_of_dharma:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/2638-fe0f@2x.png)** **Production Experience**  
• Can you explain your hands-on experience with Kubernetes in production?  
• What Kubernetes security best practices have you implemented?  
• Where and how do you store secrets securely?  
**![:briefcase:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f4bc@2x.png)** **Career & Behavioral**  
• Why are you looking to move on from your current organization?

----------------------------

Join DevOps  [12:11 PM]  

**Top DevOps Interview Questions (2026)**  
**_![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png)_** **_DevOps Fundamentals_**  

1. What is DevOps and why is it important in modern software development?
2. What are the key principles of DevOps?
3. How is DevOps different from Agile?
4. What are the main phases of the DevOps lifecycle?
5. What are the core benefits of implementing DevOps in an organization?

_![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png)_ **_CI/CD_**  
6. What is CI/CD and how does it help DevOps teams?  
7. What is the difference between Continuous Integration, Continuous Delivery, and Continuous Deployment?  
8. What are the common stages in a CI/CD pipeline?  
9. What are some popular CI/CD tools you have worked with?  
10. How do you design a scalable CI/CD pipeline?  
_![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png)_ **_Cloud & Platform Engineering_**  
11. Which cloud platforms are commonly used in DevOps?  
12. How do cloud services support DevOps practices?  
13. What is Infrastructure as Code (IaC)?  
14. What is immutable infrastructure?  
15. How do you manage multi-cloud or hybrid cloud environments?  
_![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png)_ **_Containers & Orchestration_**  
16. What is containerization and why is it important?  
17. What is Kubernetes and what problems does it solve?  
18. What are Pods, Deployments, and Services in Kubernetes?  
19. What is auto-scaling in container orchestration?  
20. How do you troubleshoot a failing container in production?  
_![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png)_ **_Configuration Management & IaC_**  
21. What is configuration management?  
22. What is Terraform and how does it work?  
23. What is the difference between Terraform and configuration management tools?  
24. What is state management in Terraform?  
25. What are modules in Terraform?  
_![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png)_ **_Version Control & GitOps_**  
26. What is GitOps?  
27. How does GitOps improve deployment reliability?  
28. What are Git branching strategies?  
29. What is the difference between merge and rebase?  
30. How do you handle merge conflicts?  
_![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png)_ **_Monitoring & Logging_**  
31. What is continuous monitoring?  
32. What are the golden signals of monitoring?  
33. What is observability?  
34. Difference between monitoring and logging?  
35. How do you set up alerting for production systems?  
_![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png)_ **_Security (DevSecOps)_**  
36. What is DevSecOps?  
37. How do you integrate security into CI/CD pipelines?  
38. What is shift-left security?  
39. What are secrets management best practices?  
40. How do you secure container images?  
_![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png)_ **_SRE Concepts_**  
41. What is Site Reliability Engineering (SRE)?  
42. What are SLO, SLA, and SLI?  
43. What is an error budget?  
44. How do SRE and DevOps work together?  
45. How do you improve system reliability?
----------------
Join DevOps  [10:24 AM]  

**Top DevOps Interview Questions (2026)**  
**Jenkins – Advanced**  
**46.** Explain the two types of pipelines in Jenkins, along with their syntax.  
**47.** How do you create a backup and copy files in Jenkins?  
**48.** How can you copy Jenkins from one server to another?  
**49.** Name three security mechanisms Jenkins uses to authenticate users.  
**50.** How is a custom build of a core plugin deployed?  
**51.** How can you temporarily turn off Jenkins security if administrative users are locked out of the admin console?  
**52.** What are the ways in which a build can be scheduled or run in Jenkins?  
**53.** What commands can be used to manually restart Jenkins?  
**54.** Explain how you can set up a Jenkins job.  
  
**![:small_blue_diamond:](https://a.slack-edge.com/production-standard-emoji-assets/15.0/google-medium/1f539@2x.png)** **Selenium – Continuous Testing**  
**55.** What are the different Selenium components?  
**56.** What are the different exceptions in Selenium WebDriver?  
**57.** Can Selenium test an application on an Android browser? If yes, how?  
**58.** What are the different test types supported by Selenium?  
**59.** How can you access the text of a web element in Selenium?  
**60.** How can you handle keyboard and mouse actions using Selenium?  
**61.** Which of the following is NOT a WebElement method?  

- getText()
- size()
- getTagName()
- sendKeys()

**62.** When do we use `findElement()` and `findElements()`?  
**63.** What is the difference between `driver.close()` and `driver.quit()` in WebDriver?  
**64.** What is the difference between Assert and Verify commands in Selenium?  
**65.** How do you launch a browser using WebDriver?

-------------------
DevOps Engineer (Fresher) – Interview Questions  
  
1.What motivated you to choose DevOps as your career path?  
  
2. Can you please introduce yourself?  
  
3. Can you briefly explain the projects you have worked on?  
  
4. How did you implement auto-scaling for virtual machines?  
  
5. What is the difference between Docker and Kubernetes?  
  
6. What networking services are available in cloud platforms (such as VPC, Load Balancer, Subnets, NAT Gateway, etc.)?  
  
7. What is the difference between a Pod and a Deployment in Kubernetes?  
  
8. What are Terraform provisioners? Can you explain local-exec and remote-exec?  
  
9. How did you deploy microservices in your project?  
  
10. Can you explain your Jenkins CI/CD pipeline?  
  
11. How do you collect and monitor application logs?  
  
12. What is a Headless Service in Kubernetes?  
  
13. What is the Shift-Left approach in DevOps?  
  
14. What are Kubernetes Secrets?  
  
15. How can you securely store secrets in a cloud-native environment?  
  
16. How do you fetch secrets from AWS Systems Manager (SSM) Parameter Store into Kubernetes?  
  
17. Can you write a sample Kubernetes manifest file?  
  
18. What is a Pod in Kubernetes?  
  
19. What is an Application Load Balancer (ALB)?  
  
20. Why do we need Ingress Controllers when we already have Service type LoadBalancer?  
  
21.  Do you have any questions for us?

---------------------------
**Today My** `**Deloitte**` **Interview Questions**  
Position Summary  
Level: Consultant  
Artificial Intelligence & Engineering  
  
Exp Range: 3-6 Years  
  
1. Self Intro  
2. Day to day activities  
3. CI/CD Pipeline from GIthub actions and Jenkins  
4. Write a dockerfile  
5. Commands for Docker image build and Run image as container  
6. Which type of runners we used in Github actions?  
7. Jenkins pipeline agents  
8. In dockerfile, what is RUN and CMD, What is the expose port ?  
9. Explain about Kubernetes archestructure  
10. write a basic Jenkins pipeline and Github actions pipeline  
11. what is pod, Can we run multiple container in single pod ?  
12. How to communicate pods from different nodes eachother ?  
13. We have an EC2 instance, enabled port from SG, but not allowed in NACL then what it happened ? & Viceversa  
14. Explain VPC Components  
15. What is load balancer, Write a load balancer and write a terraform code for Loadbalancer (edited)
--------------------------------------
Company: lakefusion ai  
Role: platform engineer  
  
jenkins pipeline- how to call one pipeline from another and how do u make first pipeline waits till the completion of second one. (success/failure)  
  
terraform provisioners-  
  
what are tf providers  
  
tf diff type of variables  
  
what is tf drift  
  
how to get existing resources into terraform- tf import  
  
what happens when resource manually deleted from console, how tf will behave at next tf apply  
  
tf modules  
  
how to see last 5 mins logs in a log file  
  
deployment vs daemonset  
  
example for daemonset  
  
AWS diff types of LBs- which LB works at which layer  
  
how do u design a VPC from scratch  
  
y VPC peering? is it possible cross account resources to communicate  
  
public private subnets  
  
dns port number  
  
diff types of services in k8s  
  
routing policy ingress  
  
what are the reasons for crashloop backoff  
  
pod keeps failing, how do u debug  
  
which ingress you use  
  
nginx ingress controller deprecated.. whats the alternate  
  
linux networking commands  
  
ssh, mysql, https - ports  
  
k8s requests limits  
  
how do u implement ur deployment when there is unpredicted load - hpa  
  
node selector vs taints and tolerations  
  
how do implement your deployment when we dont want two pods of the deployment in same node  
  
how to clearly view logs in terraform apply command - verbose  
  
what are other competitors for terraform u know  
  
how to reduce docker image size  
  
how do u define requests and limits in deployment -- how u determine the values  
  
awk command use cases  
  
what are auto.tfvars in terraform


-------------------------------
What is Terraform?  
What is Infrastructure as Code (IaC)?  
Why do we use Terraform?  
How is Terraform different from CloudFormation?  
What are providers in Terraform?  
What is a resource in Terraform?  
What is a data source in Terraform?  
What is Terraform state file?  
What is the purpose of terraform.tfstate?  
What is terraform init?  
What is terraform plan?  
What is terraform apply?  
What is terraform destroy?  
What is HCL (HashiCorp Configuration Language)?  
What are variables in Terraform?  
What are main Terraform files?  
What is [variables.tf](http://variables.tf) file?  
What is [outputs.tf](http://outputs.tf) file?  
What is terraform.tfvars?  
What is the use of backend in Terraform?  
What is remote backend?  
What is local backend?  
What is state locking?  
What is interpolation in Terraform?  
What is a provider block?  
What is state management in Terraform?  
What happens if the state file is deleted?  
What is terraform refresh?  
What is terraform import?  
What is lifecycle block?  
What is create_before_destroy?  
What is prevent_destroy?  
What is ignore_changes?  
How do you manage secrets in Terraform?  
What is terraform taint?  
What is a module in Terraform?  
What is the difference between root module and child module?  
How do you reuse Terraform code?  
What is module registry?  
How do you call a module?  
What are input and output variables in modules?  
Benefits of using modules?  
How do you handle multiple environments (dev, prod)?  
How do you manage remote state securely?  
How do you debug Terraform errors?  
What is terraform workspace?  
How do you update existing infrastructure?  
What happens if terraform apply fails?  
How do you reduce duplication in Terraform code?  
What are best practices in Terraform?

---------
What is Jenkins and how does it work internally?  
  
What are the different types of Jenkins jobs?  
  
What is the difference between Freestyle and Pipeline jobs?  
  
What is a Jenkins Pipeline?  
  
What is the difference between Declarative and Scripted Pipeline?  
  
What is a Jenkinsfile and where is it stored?  
  
What are the key components of a Jenkins Pipeline?  
  
What are stages, steps, and nodes in Jenkins?  
  
How does Jenkins integrate with Git?  
  
What is webhook in Jenkins and how does it work?  
  
How do you secure Jenkins?  
  
What are Jenkins agents (nodes) and how do they work?  
  
Difference between master and agent in Jenkins?  
  
How do you handle credentials in Jenkins?  
  
What are Jenkins plugins? Name some commonly used plugins.  
How do you install and manage plugins in Jenkins?  
  
What is Blue Ocean in Jenkins?  
How do you create a CI/CD pipeline in Jenkins?  
  
What is parameterized build in Jenkins?  
  
What is the use of environment variables in Jenkins?  
  
How do you handle build failures in Jenkins?  
  
What is Jenkins workspace?  
  
How do you clean up old builds in Jenkins?  
  
What is the use of post section in Jenkins pipeline?  
  
How do you trigger jobs in Jenkins?  
  
What is SCM polling in Jenkins?  
  
How do you integrate Jenkins with Docker?  
  
How do you integrate Jenkins with Kubernetes?  
  
What is Jenkins shared library?  
  
How do you monitor and troubleshoot Jenkins performance issues?

-------
*Monitoring Advanced Scenario Questions*  
  
1. Your alerts are not triggering even when the system is down. What will you check?  
  
2. You are getting too many false alerts (alert fatigue). How will you optimize alerting?  
  
3. Metrics are not visible in Prometheus. What could be the issue?  
  
4. Your Grafana dashboard is not showing data. How will you debug it?  
  
5. Logs are missing in centralized logging (Splunk/ELK). What will you check?  
  
6. You need to monitor a Kubernetes cluster effectively. What tools and approach will you use?  
  
7. Application latency is high but CPU/memory looks normal. Where will you investigate?  
  
8. You need to set up end-to-end observability (metrics, logs, traces). How will you design it?  
  
9. How do you implement alerting for business-level metrics (not just infra)?  
  
10. Monitoring system itself is down. How will you ensure reliability?
11. --------------
12.     
  
  
What is Terraform and how does it work?  
What is Infrastructure as Code (IaC)?  
What are Terraform providers?  
What is a Terraform resource?  
What is the difference between terraform init, plan, and apply?  
What is Terraform state file?  
Why is Terraform state important?  
What is remote state in Terraform?  
What are Terraform modules?  
How do you create reusable modules in Terraform?  
What is the difference between variables and locals?  
What are input and output variables?  
What is a backend in Terraform?  
What is the difference between local and  
remote backend?  
What is state locking and why is it important?  
What is Terraform workspace?  
How do you manage multiple environments in Terraform?  
What is dependency in Terraform and how is it handled?  
What is the use of depends_on?  
What are provisioners in Terraform?  
What is the difference between count and for_each?  
What is interpolation in Terraform?  
How do you handle secrets in Terraform?  
What are best practices for writing Terraform code?  
How do you optimize Terraform performance?  
How do you handle Terraform state file  
corruption?  
What is drift in Terraform and how do you handle it?  
How do you integrate Terraform with CI/CD pipelines?  
How do you import existing infrastructure into Terraform?  
How do you debug Terraform issues?
---------------------
[7:55 PM]

`**Ansible Interview Questions**`  
  
  
  
What is Ansible and how does it work?  
What are the key components of Ansible architecture?  
What is an Ansible playbook?  
What is the difference between playbook and ad-hoc commands?  
What is an inventory file in Ansible?  
What are static and dynamic inventories?  
What are Ansible modules?  
What are commonly used Ansible modules?  
What is idempotency in Ansible?  
What are tasks in Ansible?  
What are handlers in Ansible?  
What is the difference between tasks and handlers?  
What are variables in Ansible and how are they defined?  
What is variable precedence in Ansible?  
What are Ansible roles?  
What is the structure of an Ansible role?  
What is Ansible Galaxy?  
What are templates in Ansible?  
What is Jinja2 in Ansible?  
What is the difference between include and import in Ansible?  
What are conditionals in Ansible?  
What are loops in Ansible?  
How do you handle secrets in Ansible?  
What is Ansible Vault?  
What are tags in Ansible?  
How do you debug Ansible playbooks?  
How does Ansible connect to remote nodes?  
What is SSH key-based authentication in Ansible?  
How do you integrate Ansible with CI/CD pipelines?  
What are best practices for writing Ansible playbooks?

---
What is Prometheus and why is it used?  
What is Grafana and how does it work with Prometheus?  
What is time-series data?  
What are the key components of Prometheus architecture?  
What is a Prometheus server?  
What are exporters in Prometheus?  
What is Node Exporter?  
What is a metric in Prometheus?  
What are different types of metrics in Prometheus?  
What is a label in Prometheus?  
What is PromQL?  
How do you write a basic PromQL query?  
What is scraping in Prometheus?  
What is a scrape interval?  
What are targets in Prometheus?  
What is Alertmanager?  
How does alerting work in Prometheus?  
What are recording rules?  
What is service discovery in Prometheus?  
How do you monitor Kubernetes using Prometheus?  
What is Grafana dashboard?  
What are panels in Grafana?  
How do you connect Grafana to Prometheus?  
What are variables in Grafana dashboards?  
What are alerts in Grafana?  
What is the difference between Grafana alerting and Prometheus alerting?  
How do you secure Prometheus and Grafana?  
How do you scale Prometheus?  
What are common challenges in monitoring with Prometheus?  
How do you troubleshoot missing metrics in Grafana?

[8:56 AM]

`**Kubernetes Interview Questions**`  
  
What is Kubernetes and why is it used?  
What are the main components of Kubernetes architecture?  
What is the role of the API Server in Kubernetes?  
What is etcd and why is it important?  
What is a Pod in Kubernetes?  
What is the difference between Pod and Container?  
What is a Deployment in Kubernetes?  
What is the difference between Deployment and ReplicaSet?  
What is a Service in Kubernetes?  
What are different types of Services in Kubernetes?  
What is ClusterIP, NodePort, and LoadBalancer?  
What is an Ingress and how does it work?  
What is a Namespace in Kubernetes?  
What are ConfigMaps and Secrets?  
How do you manage sensitive data in Kubernetes?  
What is a StatefulSet and when do you use it?  
What is a DaemonSet?  
What is a Job and CronJob in Kubernetes?  
What is HPA (Horizontal Pod Autoscaler)?  
What is resource request and limit?  
What is liveness probe and readiness probe?  
What is rolling update and rollback in Kubernetes?  
How does Kubernetes handle service discovery?  
What is kube-proxy?  
What is CNI in Kubernetes?  
What are taints and tolerations?  
What are node selectors and affinity?  
How do you troubleshoot a failing Pod?  
How do you monitor Kubernetes clusters?  
How do you secure a Kubernetes cluster? (edited)

-----------
What is the Linux boot process and its stages?  
What is the difference between BIOS and UEFI?  
What is GRUB and how does it work?  
What are systemd and init systems in Linux?  
What is the difference between systemctl and service commands?  
How does process management work in Linux?  
What is the difference between a process and a thread?  
How do you check running processes in Linux?  
What is nice and renice in Linux?  
What is a zombie process?  
What is file permission in Linux and how does it work?  
What is the difference between hard link and soft link?  
What is umask and how is it used?  
What are special permissions (SUID, SGID, Sticky Bit)?  
What is inode in Linux?  
What is LVM and why is it used?  
What is the difference between ext4, xfs, and other file systems?  
How do you check disk usage and disk performance?  
What is fstab and how does it work?  
What is swap space and how is it managed?  
What is networking in Linux and how do you troubleshoot it?  
What are common networking commands used in Linux?  
What is SSH and how does it work?  
What is DNS and how is it configured in Linux?  
What is the difference between private and public IP?  
What is a package manager and how does it work?  
What is the difference between apt and yum/dnf?  
How do you manage services in Linux?  
What is log management in Linux and where are logs stored?  
How do you troubleshoot a high CPU or memory issue in Linux?\
---------
  
  
What is AWS and what are its core services?  
What is the difference between IaaS, PaaS, and SaaS in AWS?  
What is an AWS Region and Availability Zone?  
What is EC2 and how does it work?  
What are different types of EC2 instances?  
What is S3 and what are its storage classes?  
What is the difference between EBS and S3?  
What is IAM and how does it work?  
What are IAM roles and policies?  
What is VPC and its components?  
What are subnets, route tables, and  
Internet Gateway?  
What is a Security Group vs Network ACL?  
What is Elastic Load Balancer and its types?  
What is Auto Scaling and how does it work?  
What is RDS and its advantages?  
What is the difference between RDS and DynamoDB?  
What is CloudWatch and what can you monitor?  
What is CloudTrail and why is it used?  
What is Route 53 and how does DNS routing work?  
What is Lambda and serverless architecture?  
  
Your application is down — how do you troubleshoot in AWS step by step?  
How would you design a highly available 3-tier architecture in AWS?  
Your EC2 instance is not reachable — what could be the possible issues?  
S3 bucket is public accidentally — how do you secure it?  
Application latency has increased — how do you identify the root cause?  
How do you design a cost-optimized AWS architecture?  
How do you secure AWS infrastructure for production workloads?  
How do you implement CI/CD pipeline using AWS services?  
How do you handle disaster recovery in AWS?  
How do you monitor and alert production systems effectively in AWS?

-----------------
*Monitoring Advanced Scenario Questions*  
  
1. Your alerts are not triggering even when the system is down. What will you check?  
  
2. You are getting too many false alerts (alert fatigue). How will you optimize alerting?  
  
3. Metrics are not visible in Prometheus. What could be the issue?  
  
4. Your Grafana dashboard is not showing data. How will you debug it?  
  
5. Logs are missing in centralized logging (Splunk/ELK). What will you check?  
  
6. You need to monitor a Kubernetes cluster effectively. What tools and approach will you use?  
  
7. Application latency is high but CPU/memory looks normal. Where will you investigate?  
  
8. You need to set up end-to-end observability (metrics, logs, traces). How will you design it?  
  
9. How do you implement alerting for business-level metrics (not just infra)?  
  
10. Monitoring system itself is down. How will you ensure reliability?
-----------------
What is Kubernetes and why is it used?  
  
What are the core components of Kubernetes architecture?  
  
What is a Pod in Kubernetes?  
  
What is a Deployment and how does it work?  
  
What is a Service in Kubernetes?  
  
What are different types of Services (ClusterIP, NodePort, LoadBalancer)?  
  
What is a Namespace and why is it used?  
  
What is the difference between Deployment and StatefulSet?  
  
What is a DaemonSet and when would you use it?  
  
What is Ingress and how does it work?  
  
What are ConfigMaps and Secrets?  
  
What are liveness and readiness probes?  
  
What is Horizontal Pod Autoscaler (HPA)?  
  
What is RBAC in Kubernetes?  
  
What is the difference between Role and ClusterRole?  
  
How does Kubernetes networking work internally?  
  
What is CNI and how does it function?  
  
How does Kubernetes handle service discovery?  
  
What is etcd and how do you manage its backup and restore?  
  
What are taints and tolerations?  
  
What are affinity and anti-affinity rules?  
  
How do you secure a Kubernetes cluster?  
  
What is Helm and how does it simplify deployments?  
  
A Pod is stuck in CrashLoopBackOff — how do you troubleshoot it?  
  
Your application is not accessible via Service — what steps will you take?  
  
How would you perform zero-downtime deployment in Kubernetes?  
  
A node is not ready — how do you investigate?  
  
How do you handle high CPU/memory usage in a cluster?  
  
How do you scale applications automatically in Kubernetes?  
  
How do you monitor and log Kubernetes workloads effectively? (edited)
---------
	Recently attended interview for DevOps Analyst Postion 1st round interview technical screening about 30 minutes  
  
focused on terraform , ansible , Jenkins, and MySQL(as their requirement in project)  
  
1. what is terraform explain how it will work  
2. what is terraform providers  
3. how you integrate ansible with terraform  
4. write a terraform code to create a multiple Ec2 instances with for_each and count function.  
5. diff b/w for_each and count  
6. how many AWS Services you have worked on ?  
7. terraform modules  
8. which mechanism are you using in ansible and why  
9. how may servers did you configure  
10. Diff b/w Jenkins, GitHub Action, Azure Devops  
11. write a pipeline in declarative syntax  
12. why you are using Jenkins instead of codedeploy and azure devops  
13. what are ansible components  
14. write ansible push mechanism command to configure the application on remote servers  
15. write a query to create a table  
16. diff b/w delete , drop, truncate  
17. get top 10 record from the table (edited)
----------------
# SENIOR DEVOPS ENGINEER

Senior DevOps EngineerSharing the interview experience and questions asked in both rounds — hope this helps others preparing for similar roles.  
**_Round 1 – Technical Discussion_**  

1. Explain your current project architecture and CI/CD pipeline.
2. What is Docker? Explain the difference between an image and a container.
3. What is Kubernetes? Explain its architecture.
4. What are Pod, Service, and Deployment in Kubernetes?
5. Explain the differences between Rolling, Blue-Green, and Canary deployments.
6. What is Terraform? What is the Terraform state file?
7. Difference between public and private subnets in AWS.
8. What is IAM? Difference between a role and a policy.
9. What is a Load Balancer and how does it work?
10. What Git branching strategy do you follow?
11. How do you monitor applications in production?
12. What is DNS and how does it work?

  
  
**_Round 2 – Scenario-Based / Advanced Discussion_**  
How do you scale an application in Kubernetes?  
How do you secure container images in Kubernetes?  
What is the role of Amazon CloudFront in an architecture?  
How do you design disaster recovery for Amazon RDS?  
A developer cannot access an S3 bucket — what checks would you perform?  
You are facing latency issues in an EKS cluster — how do you troubleshoot?  
AWS Lambda is failing internally — what debugging steps would you follow?  
CI/CD pipeline is not able to connect to GitLab — what would you verify?  
Kubernetes is not able to expose a pod — what could be the possible issues?  

1. Pods are running but users are getting _503 errors_ — how do you debug?
2. _terraform apply_ failed midway — how do you recover safely?
3. How do you manage secrets securely across multiple environments?

**Overall, the interview focused on:**  

- _Core DevOps concepts_
- _AWS architecture and troubleshooting_
- _Kubernetes debugging scenarios_
- _Terraform recovery handling_
- _CI/CD troubleshooting_
- _Security best practices_

**Hope this helps anyone preparing for Senior DevOps interviews**