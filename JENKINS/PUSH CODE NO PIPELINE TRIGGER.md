

 Here are the ways to **push code without triggering the pipeline**:

---
### Option 1: Skip CI via Commit Message (Most Common)

Most CI tools recognize special keywords in commit messages:

bash

```bash
# Jenkins / GitHub Actions / GitLab CI
git commit -m "updated readme [skip ci]"
git commit -m "updated readme [ci skip]"
git commit -m "updated readme [no ci]"

# GitLab specific
git commit -m "updated readme [skip gitlab ci]"

# GitHub Actions specific
git commit -m "updated readme [skip actions]"
```

Jenkins needs the **SCM Skip plugin** installed for this to work:

bash

```bash
# Install from Jenkins Plugin Manager
"SCM Skip Plugin"
```

---

#### Option 2: Push to a Different Branch (Cleanest Approach)

Configure Jenkins to **only trigger on specific branches**:

groovy

```groovy
// Jenkinsfile
pipeline {
    agent any
    triggers {
        // Only trigger on main and release branches
        pollSCM('* * * * *')
    }
    stages {
        stage('Build') {
            when {
                anyOf {
                    branch 'main'
                    branch 'release/*'
                }
            }
            steps {
                echo 'Building...'
            }
        }
    }
}
```

So developers work on:

bash

```bash
# Create a dev branch — no pipeline triggers here
git checkout -b dev/feature-login
git push origin dev/feature-login   # ✅ no pipeline

# Only triggers when merged to main
git checkout main
git merge dev/feature-login
git push origin main                # ✅ pipeline runs
```

---

#### Option 3: Disable the Trigger Temporarily in Jenkins

```
Jenkins Dashboard
  → Your Job
    → Configure
      → Build Triggers
        → Uncheck "GitHub hook trigger" or "Poll SCM"
          → Save
```

Re-enable it when the team is ready.

---

#### Option 4: Webhook Filtering (Branch/Path Filter)

If using GitHub/GitLab webhooks, filter which pushes trigger Jenkins:

groovy

```groovy
// Jenkinsfile - only run pipeline if specific files changed
pipeline {
    agent any
    stages {
        stage('Build') {
            when {
                changeset "src/**"   // only trigger if src/ folder changed
            }
            steps {
                echo 'Building...'
            }
        }
    }
}
```

So pushing to `README.md`, `docs/` etc. won't trigger a build.

---

#### Option 5: Manual Trigger Only

Set the job to **only run when manually triggered** — no automatic triggers at all:

groovy

```groovy
// Jenkinsfile
pipeline {
    agent any
    triggers {
        // Remove all automatic triggers
        // pollSCM('')  ← comment this out
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building only when manually triggered'
            }
        }
    }
}
```

---

#### Which Option Should You Use?

|Situation|Best Option|
|---|---|
|Temporary, quick fix|Option 1 — `[skip ci]` in commit|
|Early development phase|Option 3 — Disable trigger in Jenkins|
|Long term branch strategy|Option 2 — Branch-based triggers|
|Only specific files matter|Option 4 — Path filtering|
|Full manual control|Option 5 — Manual trigger only|

> **Recommended for early development:** Use **Option 2** — push all dev work to a `dev` or `feature/*` branch. Only when the team decides the code is ready, merge to `main` and let the pipeline run. This is the cleanest and most professional approach.