# 🔐 DevSecOps Pipeline

> Security-first CI/CD pipeline with SAST, dependency scanning, container vulnerability scanning, and DAST — all automated, none optional.

## 🏗️ Security Layers

```
Code Commit
    │
    ├── 🔍 Secrets Detection (truffleHog)
    ├── 🧪 SAST — Static Analysis (SonarQube)
    ├── 📦 Dependency CVE Scan (OWASP Dependency-Check)
    ├── 🐳 Container Scan (Trivy)
    ├── 🚀 Deploy to Staging
    └── 🌐 DAST — Dynamic Analysis (OWASP ZAP)
```

## 🛠️ Stack

- **SAST**: SonarQube
- **Secrets**: truffleHog
- **Dependencies**: OWASP Dependency-Check
- **Container**: Trivy
- **DAST**: OWASP ZAP
- **CI**: Jenkins

## 🔑 Key Jenkinsfile Snippet

```groovy
stage('Secrets Detection') {
  steps {
    sh 'trufflehog git file://. --only-verified --fail'
  }
}

stage('Dependency CVE Scan') {
  steps {
    dependencyCheck additionalArguments: '''
      --scan ./
      --format HTML
      --out dependency-check-report
      --failOnCVSS 7
    ''', odcInstallation: 'dependency-check'
    publishHTML([
      reportDir: 'dependency-check-report',
      reportFiles: 'dependency-check-report.html',
      reportName: 'CVE Report'
    ])
  }
}

stage('Container Scan') {
  steps {
    sh '''
      trivy image \
        --exit-code 1 \
        --severity HIGH,CRITICAL \
        --no-progress \
        myapp:${BUILD_NUMBER}
    '''
  }
}

stage('DAST - OWASP ZAP') {
  steps {
    sh '''
      docker run -t owasp/zap2docker-stable zap-baseline.py \
        -t http://staging.myapp.com \
        -r zap-report.html \
        -I
    '''
  }
}
```

## 🚀 How to Run

1. Set up Jenkins with SonarQube, Trivy, and OWASP tools configured
2. Point pipeline to this repo's Jenkinsfile
3. Every commit automatically gets scanned across all 5 security layers