https://www.reddit.com/r/devops/comments/1ue3cmq/passed_ckad_with_87_heres_my_exam_experience/
oday, I passed CKAD with 87% and wrote a detailed blog about my exam experience, preparation approach, and the Kubernetes topics that helped me the most.

Edit: DMs are open if you are preparing for the exam. I can help with whatever is still fresh in my memory.

Sharing some useful notes here as well.

My biggest takeaway: CKAD is not about memorising Kubernetes. It is about hands-on speed, YAML accuracy, and knowing how to verify that your work is actually correct.

A few things that helped me:

1. Don’t solve the exam strictly in order. In my case, the first few questions felt time-consuming, so I skipped them and picked easier ones first. This helped me build momentum and avoid wasting time early.
    
2. Please get comfortable with vim; you'll be editing a lot of YAML. Basic vim speed matters more than people think.
    
3. Use kubectl explain when YAML nesting gets confusing. This helped me especially around CronJobs, securityContext, resources, PV/PVC, and nested pod template fields.
    
4. Always verify that a resource getting created does not mean the task is done. Check Pods, Services, endpoints, rollout status, logs, and connectivity wherever required.
    
5. Practice testing from temporary Pods This helped a lot for Service, Ingress, and NetworkPolicy questions. Being able to test a Service from inside the cluster quickly is very useful.
    
6. Copy names, labels, paths, and namespaces carefully. Small typos can cost marks. I tried to copy exact names from the question wherever possible.
    

Topics I would strongly recommend practising:

- Secrets and environment variables
    
- CronJobs
    
- ServiceAccount, Role, and RoleBinding
    
- Podman image build and save/export
    
- Ingress creation and troubleshooting
    
- Services, selectors, and endpoints
    
- NodePort Services
    
- NetworkPolicies
    
- Canary deployments with manual traffic split
    
- Deployment update and rollback
    
- Pod/container securityContext
    
- Resource requests and limits
    
- ResourceQuota-based sizing
    
- PV, PVC, StorageClass, and volumeMounts
    
- InitContainers
    

Resources I used:

- KodeKloud CKAD course and mock tests
    
- dgkanatsios CKAD exercises on GitHub
    
- iximiuz Labs for hands-on practice
    

My prep took around 3 weeks, but that depends on how comfortable you already are with Kubernetes.

I also wrote a full blog with more details on my prep, exam strategy, topics to focus on, and mistakes to avoid.

Blog: [https://blog.prateekjain.dev/ckad-exam-experience-2026-how-i-passed-with-87-f1616a0865b1?sk=1fbb525079e81f40a45728ba69785db0](https://blog.prateekjain.dev/ckad-exam-experience-2026-how-i-passed-with-87-f1616a0865b1?sk=1fbb525079e81f40a45728ba69785db0)