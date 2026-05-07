
The binding point is the `projectKey`, yes.

But it is not “generated in Jenkins agent by Sonar scanner” as a general rule.

More accurate:

The scanner running on the Jenkins agent determines the effective `projectKey` by either:

1. reading it explicitly (`sonar.projectKey=...`)
2. receiving it from Jenkins parameters
3. deriving it from build metadata (like Maven `groupId + artifactId`)

Then it sends that key with the analysis to SonarQube.

So flow is:

```
Jenkins Agent   ↓Sonar Scanner runs   ↓Effective projectKey resolved   ↓Analysis sent to SonarQube   ↓Stored under that projectKey
```

That `projectKey` is the identity binding.

But for pipeline correlation, there is also another important piece:

```
ceTaskId
```

(the Compute Engine task ID)

Because multiple analyses of the same project can happen.

Example:

```
projectKey = order-serviceBuild #101Build #102Build #103
```

All same project.

How does Jenkins know which specific analysis belongs to this pipeline run?

Through the analysis task ID + webhook/quality gate tracking.

So:

- `projectKey` → binds analysis to the project
- `taskId` → binds this specific pipeline run to this specific analysis

If you only say “projectKey,” the explanation is incomplete.