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