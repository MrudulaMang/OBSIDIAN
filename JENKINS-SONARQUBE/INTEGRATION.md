give me steps to integrate sonarqube analysis to jenkins

## Claude responded: 3 phases — SonarQube side, Jenkins side, and the Jenkinsfile code.

---

**SonarQube + Jenkins Integration — Step by Step**

---

**Phase 1 — SonarQube Side**

1. Log in to SonarQube → go to **My Account → Security**
2. Under **Generate Tokens**, give it a name like `jenkins-token` → click Generate → copy the token immediately, it won't show again
3. Go to **Projects → Create Project → Manually** → note down the **Project Key**, you'll need it in the Jenkinsfile

---

**Phase 2 — Jenkins Side**

1. **Install plugin** → Manage Jenkins → Plugins → Available → search **SonarQube Scanner** → install and restart
2. **Add token as credential** → Manage Jenkins → Credentials → Global → Add Credential
    - Kind: Secret text
    - Secret: paste the token
    - ID: `sonar-token`
3. **Configure SonarQube server** → Manage Jenkins → System → SonarQube Servers → Add
    - Name: `sonar-server`
    - URL: your SonarQube URL
    - Token: select `sonar-token`
4. **Configure Scanner tool** → Manage Jenkins → Global Tool Configuration → SonarQube Scanner → Add
    - Name: `sonar-8`
    - Check **Install automatically** → pick version
    - _(This is what `tool name: 'sonar-8'` in your Jenkinsfile refers to — name must match exactly)_


3 phases — SonarQube side, Jenkins side, and the Jenkinsfile code. A few things worth noting:

- The name `sonar-8` in the tool config and `sonar-server` in the system config must match exactly what you use in the Jenkinsfile — case sensitive
- `withSonarQubeEnv()` automatically injects `SONAR_HOST_URL` and `SONAR_AUTH_TOKEN` as environment variables so you don't hardcode them
- The Quality Gate stage is optional but highly recommended — without it the pipeline passes even if your code fails the quality check

Want me to show you a complete Jenkinsfile with all stages including the SonarQube analysis wired in?





![[Pasted image 20260507104400.png|115]]