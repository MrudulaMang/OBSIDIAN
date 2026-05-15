More precise:

- Scanner runs inside the runner
- Scanner inspects source code and build context
- Scanner generates analysis data/metadata (not the final verdict)
- Runner sends that data to SonarQube
- SonarQube server applies rules, stores results, computes Quality Gate
- Runner checks the Quality Gate/API result
- Pipeline decides pass/fail

So the clean interview version is:

```
Scanner generates analysis metadata locally.Runner submits it to SonarQube.SonarQube computes issues and Quality Gate.Runner fetches the result and pipeline proceeds accordingly.
```