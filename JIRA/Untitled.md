can i use that and simulate real time project managment flow dev to prod,

Yes—and you should.

In fact, if you are serious about DevOps/SRE positioning, you should stop treating Jira as “a ticket tool” and start treating it as your operational nervous system.

You can absolutely simulate full dev → prod lifecycle using the free plan.

A strong practice flow looks like this:

1. Requirement / Feature Creation

Example:  
“Add payment service rate limiting”

Create:

- Epic
- Story
- Subtasks

Not just “task.”

Think in delivery structure.

2. Development Stage

Developer actions:

- branch creation (`feature/rate-limit`)
- coding
- pull request
- code review

Jira should reflect:  
To Do → In Progress → Code Review

3. CI Pipeline Stage

Using Jenkins or GitHub Actions:

- build
- unit tests
- SonarQube scan
- dependency scan
- Docker image build
- image scan
- artifact push to Amazon Web Services ECR

Status should update back into Jira.

4. QA / UAT Stage

Testing team:

- functional testing
- regression testing
- performance checks
- UAT approval

Jira:  
Ready for QA → QA Passed → UAT Approved

5. Change Management

Create:

- Change Request (CR)
- risk assessment
- rollback plan
- approval matrix

This is where most “fake DevOps projects” fail.

Real production means governance.

6. Deployment Stage

Using:

- rolling deployment
- canary deployment
- blue-green deployment

Targets:  
Amazon Elastic Kubernetes Service or ECS

Jira:  
Scheduled → Deployed → Verified

7. Monitoring + Incident Flow

After release:

- Grafana alerts
- Splunk logs
- incident ticket
- RCA
- postmortem
- problem management

Now you are simulating reality.

Not just CI/CD.

That is the difference.

You should also create issue types like:

- Story
- Bug
- Incident
- Problem
- Change Request
- Service Request
- RCA Task
- Production Hotfix

That makes your learning look enterprise-grade.

Hard truth:

Most people say:  
“I know Jira”

Meaning:  
“I moved tickets.”

That is weak.

You should be able to explain:

“How engineering governance flows from requirement to production stability.”

That is strong.

My recommendation:  
Build one full Roboshop-style simulated enterprise flow.

Not 20 random mini-projects.

One deep system beats ten shallow ones.

That becomes:

- interview material
- LinkedIn content
- architecture discussion
- leadership proof

That is career leverage.

but i am not admin to setup jira

That is exactly the constraint you should think through instead of stopping at it.

In real companies, most engineers are not Jira admins.

So the better skill is not “Can I configure Jira?”

It is:

“Can I work effectively inside imperfect systems I don’t control?”

Still, for personal learning, you have options:

1. Create your own personal Jira free workspace

Be the admin there.

This is the best option.

You can simulate:

- workflows
- issue types
- boards
- sprint planning
- release flow
- CR process

This gives you architecture understanding.

2. Learn from observation in your company Jira

Even without admin rights, observe:

- workflow stages
- approval paths
- labels
- incident structure
- change request format
- release governance

Most people use tools without studying the system.

Study it.

3. Recreate the process externally

Even if Jira setup is limited, you can document the real workflow using:

- Excalidraw
- Obsidian
- diagrams
- architecture notes

You are learning operational design, not worshipping a tool.

Important truth:

Hiring managers care less about:  
“I created custom Jira workflow”

and more about:

“Do you understand release governance and production safety?”

Don’t confuse admin access with seniority.

Some juniors have admin rights.  
Some senior architects never touch settings.

Real value is judgment.

Your danger is this:  
using “I don’t have access” as a reason to stop learning.

That kills careers.

Your question should be:

“How do I learn the system despite limited access?”

That is the professional mindset.

how many days it will take for me to setup and implement everything end to end by learning also.

If you mean truly understanding and building an end-to-end Dev → QA → UAT → Change Request → Prod → Incident → RCA → SRE simulation—not just making it “look done”—then the honest answer is:

30 to 60 focused days.

Not 3 days.  
Not one weekend.  
And not by watching tutorials at 2x speed.

Let’s break the illusion.

Phase 1 — Workflow Understanding (5–7 days)

You must understand:

- SDLC flow
- branch strategy
- PR review
- CI stages
- QA/UAT process
- change management
- release approvals
- rollback planning
- incident flow
- RCA process

Most people skip this and jump to Jenkins.

Mistake.

Phase 2 — Tool Setup (7–12 days)

You’ll need:

- Jira
- Jenkins
- GitHub
- SonarQube
- Docker
- Kubernetes / EKS
- ECR
- monitoring basics

Setup itself will break repeatedly.

Good.  
That is learning.

Phase 3 — CI/CD Build (10–15 days)

You must implement:

- branch → PR → merge
- build pipeline
- scan stages
- image build
- registry push
- deployment strategy
- rollback handling

This is where shallow learners quit.

Phase 4 — Production Simulation (7–10 days)

Create:

- incident scenarios
- failed deployment cases
- rollback
- RCA documents
- change tickets
- bridge-call style thinking

This is where you become interesting.

Phase 5 — Professional Packaging (3–5 days)

Convert into:

- LinkedIn story
- resume bullets
- architecture diagrams
- interview explanations
- “tell me about your project” answer

Without this, work stays invisible.

Total:  
roughly 4–8 weeks.

But here is the real variable:

Focus quality.

4 serious hours daily for 30 days beats 3 months of casual “learning.”

Now the uncomfortable part:

Do not try to learn everything at once.

That is ego disguised as ambition.

Pick one flagship project.

One.

Example:  
Roboshop production-grade deployment simulation

Then go absurdly deep.

Depth gets jobs.  
Breadth gets bookmarks.

My challenge to you:

Would you rather say

“I know Jenkins, Terraform, Kubernetes, SonarQube…”

or

“I designed and defended one production-grade deployment system end to end.”

Only one of those sounds senior.
-------------------------------------------------------

Day 1 — Build the System

You should be able to set up:

- Git repo with proper branch strategy
- Jira workflow mapped
- Jenkins pipeline
- SonarQube integration
- Docker image build
- image push to Amazon Elastic Container Registry
- deployment to Amazon Elastic Kubernetes Service / ECS
- rollback strategy defined
- basic monitoring validation

Not screenshots.  
Working flow.

Day 2 — Break the System

This matters more.

You should intentionally simulate:

- failed build
- failed quality gate
- bad deployment
- failed health checks
- pod crash loop
- bad config pushed to prod
- rollback scenario
- incident ticket creation
- RCA draft
- postmortem summary

If you skip Day 2, you learned deployment, not reliability.

That is junior-level.

Senior credibility comes from failure handling.

My concern:

You may be underestimating documentation.

Can you also explain:

- why canary over rolling?
- why this readiness probe?
- why this resource limit?
- why this rollback strategy?
- why this branch protection?
- why this approval chain?

Because interviews care less about what you clicked and more about why.

So I’ll push harder:

Don’t tell me “I can do it in 2 days.”

Tell me:

“What production failure will I simulate first, and why?”

That answer reveals your maturity.