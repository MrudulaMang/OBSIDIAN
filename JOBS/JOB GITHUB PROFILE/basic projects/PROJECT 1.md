# 🔁 End-to-End Jenkins CI/CD Pipeline


Want me to generate the actual working code files for any of the 5 projects?

> Production-grade CI/CD pipeline with automated quality gates, container builds, and Kubernetes deployment on AWS EKS.

## 🏗️ Architecture

```
Code Push → GitHub Webhook → Jenkins Pipeline
    │
    ├── Stage 1: Checkout & Build
    ├── Stage 2: Unit Tests
    ├── Stage 3: SonarQube Analysis
    ├── Stage 4: Quality Gate Check
    ├── Stage 5: Docker Build & Push (ECR)
    ├── Stage 6: Deploy to EKS (Dev)
    ├── Stage 7: Smoke Tests
    └── Stage 8: Deploy to Production (Blue/Green)
```

## 🛠️ Stack

- **CI/CD**: Jenkins, GitHub Webhooks
- **Code Quality**: SonarQube, JUnit
- **Containers**: Docker, Amazon ECR
- **Deployment**: AWS EKS, kubectl, Helm
- **Notifications**: Slack

## 📁 Repo Structure

```
jenkins-cicd-pipeline/
├── Jenkinsfile
├── Dockerfile
├── sonar-project.properties
├── helm/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── deployment.yaml
│       ├── service.yaml
│       └── ingress.yaml
├── scripts/
│   ├── deploy.sh
│   └── smoke-test.sh
└── README.md
```

## 🔑 Key Jenkinsfile Snippet

```groovy
pipeline {
  agent any

  environment {
    SCANNER_HOME  = tool name: 'sonar-8'
    ECR_REPO      = '123456789.dkr.ecr.us-east-1.amazonaws.com/myapp'
    IMAGE_TAG     = "${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/you/myapp.git'
      }
    }

    stage('Unit Tests') {
      steps {
        sh 'mvn test'
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('sonar-server') {
          sh '''
            ${SCANNER_HOME}/bin/sonar-scanner \
            -Dsonar.projectKey=myapp \
            -Dsonar.sources=src
          '''
        }
      }
    }

    stage('Quality Gate') {
      steps {
        waitForQualityGate abortPipeline: true
      }
    }

    stage('Docker Build & Push') {
      steps {
        withCredentials([string(credentialsId: 'aws-account-id', variable: 'AWS_ACCOUNT')]) {
          sh '''
            aws ecr get-login-password --region us-east-1 | \
            docker login --username AWS --password-stdin ${ECR_REPO}
            docker build -t myapp:${IMAGE_TAG} .
            docker tag myapp:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
            docker push ${ECR_REPO}:${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh '''
          helm upgrade --install myapp ./helm \
          --set image.tag=${IMAGE_TAG} \
          --namespace production
        '''
      }
    }
  }

  post {
    success {
      slackSend channel: '#deployments', message: "✅ Deploy ${IMAGE_TAG} succeeded"
    }
    failure {
      slackSend channel: '#deployments', message: "❌ Pipeline failed at ${STAGE_NAME}"
    }
  }
}
```

## 🚀 How to Run

1. Clone this repo
2. Configure Jenkins with SonarQube and AWS credentials
3. Point a Jenkins job to this repo's Jenkinsfile
4. Push a commit and watch the pipeline run