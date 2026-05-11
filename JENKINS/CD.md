The goal is to treat your pipeline like a living system—always evolving based on real outcomes. So next time, ask yourself: What did production teach me, and how will my next deployment be stronger for it?what is cd

CD means either:

1. Continuous Delivery
2. Continuous Deployment

People use the same abbreviation for both, and many teams confuse them.

Both start after CI.

Flow:

```
Code → Build → Test → Artifact → Deploy
```

CI = Continuous Integration  
CD = what happens after successful integration

Continuous Delivery

The system automatically:

- builds
- tests
- packages
- prepares deployment

But production release still requires a human approval.

Example:

```
Build passed↓Deploy to staging automatically↓Manager / Release owner clicks approve↓Deploy to production
```

Continuous Deployment

No manual approval.

If pipeline passes, production deployment happens automatically.

Example:

```
Build passed↓Tests passed↓Deploy to production automatically
```

Difference:

Delivery = ready to release  
Deployment = automatically released

In Jenkins:

```
stage('Deploy to Prod') {    input {        message "Approve production deployment?"    }    steps {        sh 'kubectl apply -f deployment.yaml'    }}
```

This is Continuous Delivery because approval exists.

Without `input`, it moves toward Continuous Deployment.

Reality check:

Most enterprises say “we do CD”  
but actually mean:  
manual approvals + CAB meetings + weekend deployments

That is usually Continuous Delivery, not Deployment.

Interview answer should be precise:

“CI validates code integration. CD ensures tested artifacts move reliably toward production, either with manual approval (delivery) or automatically (deployment).”

That sounds senior.

Not:

“CD means automatic deployment.”

That answer is incomplete.