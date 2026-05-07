A merge commit is created when Git combines changes from two branches using `git merge`, preserving the full branch history and showing exactly where branches joined; it is useful in shared branches because it keeps context and audit trails clear. Rebase, using `git rebase`, rewrites commit history by moving your branch commits on top of another branch, creating a cleaner and more linear history without extra merge commits. Rebase is commonly used on local feature branches before raising a PR, while merge is preferred for integrating shared work safely. In simple terms: merge preserves history as it happened, rebase rewrites history to make it look cleaner.

-------------------------------------------------
who has merge authority? this is my next question

Merge authority depends on branch criticality, not job title.

Think in layers:

1. Feature branches (`feature → develop`)  
    Usually:

- Senior developer
- Module owner
- Tech lead

Low business risk, faster approvals.

2. Shared integration branch (`develop → release`)  
    Usually:

- Tech lead
- Engineering manager
- Release owner
- Sometimes QA sign-off required

Because bad merges here affect multiple teams.

3. Production branch (`release → main` or `master`)  
    Usually:

- Release manager
- Engineering manager
- Platform lead
- DevOps lead
- Sometimes CAB approval for regulated environments

High blast radius. Access is intentionally restricted.

4. Infrastructure repositories (Terraform, Kubernetes, Helm, Jenkinsfiles)  
    Usually:

- Platform/DevOps lead
- Cloud architect
- SRE lead

Because one bad merge can break everything, not just one service.

In mature teams, direct merge rights are enforced by branch protection rules in GitHub, GitLab, or Bitbucket:

- required approvals
- status checks
- restricted push access
- mandatory reviews
- signed commits sometimes

Hard truth: if everyone can merge to production, you do not have a process—you have optimism.

Your interview-grade answer should be:  
“PR is raised by the code owner, but merge authority is controlled by branch policies and usually reserved for leads or release owners depending on environment criticality.”