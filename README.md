# SWE 645 – Homework Assignment 2
**Name:** Gnanitha Suryadevara  
**Course:** SWE 645  

---

## Overview
This assignment containerizes the static web application (homepage + student survey) built in HW1, deploys it on a Kubernetes cluster via Rancher, and automates builds/deployments using a Jenkins CI/CD pipeline.

---

## Prerequisites
- Docker Desktop installed
- Docker Hub account
- GitHub account
- Rancher Kubernetes cluster set up
- Jenkins server running (can run locally via Docker)
- `kubectl` configured to connect to your Rancher cluster

---

## Step 1: Docker – Build & Push Image

### 1.1 Build the Docker image
```bash
docker build -t YOUR_DOCKERHUB_USERNAME/swe645-hw2:latest .
```

### 1.2 Log in to Docker Hub
```bash
docker login
```

### 1.3 Push the image to Docker Hub
```bash
docker push YOUR_DOCKERHUB_USERNAME/swe645-hw2:latest
```

### 1.4 (Optional) Test locally
```bash
docker run -p 8080:80 YOUR_DOCKERHUB_USERNAME/swe645-hw2:latest
# Open http://localhost:8080 in your browser
```

---

## Step 2: Kubernetes Deployment via Rancher

### 2.1 Update deployment.yaml
In `deployment.yaml`, replace `YOUR_DOCKERHUB_USERNAME` with your actual Docker Hub username.

### 2.2 Connect kubectl to your Rancher cluster
- In Rancher UI → your cluster → click **Kubeconfig File** → download and save as `~/.kube/config`

### 2.3 Apply the Kubernetes manifests
```bash
kubectl apply -f deployment.yaml
```

### 2.4 Verify pods are running (should show 3 pods)
```bash
kubectl get pods
kubectl get services
```

### 2.5 Access the application
- Get the external IP from `kubectl get services`
- Open `http://EXTERNAL_IP` in your browser

### 2.6 Resiliency test – delete a pod and verify auto-recovery
```bash
kubectl delete pod <pod-name>
kubectl get pods   # A new pod should spin up automatically
```

---

## Step 3: CI/CD Pipeline with Jenkins

### 3.1 Install Jenkins
Run Jenkins via Docker:
```bash
docker run -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

### 3.2 Install required Jenkins plugins
- Git plugin
- Docker Pipeline plugin
- Kubernetes CLI plugin
- Credentials Binding plugin

### 3.3 Add credentials in Jenkins
Go to **Manage Jenkins → Credentials → Global** and add:
1. **Docker Hub credentials** (Username/Password) with ID: `dockerhub-credentials`
2. **Kubeconfig file** (Secret File) with ID: `kubeconfig-credentials`
   - Download kubeconfig from Rancher and upload it here

### 3.4 Create a Jenkins Pipeline job
- **New Item** → Pipeline
- Under **Pipeline** → select **Pipeline script from SCM**
- Set SCM to **Git** and enter your GitHub repo URL
- Set **Script Path** to `Jenkinsfile`

### 3.5 Configure GitHub Webhook (for automatic triggers)
- In GitHub repo → **Settings → Webhooks → Add webhook**
- Payload URL: `http://YOUR_JENKINS_URL/github-webhook/`
- Content type: `application/json`
- Select **Just the push event**

### 3.6 Run the pipeline
- Click **Build Now** in Jenkins, or push a commit to GitHub
- Pipeline stages: Checkout → Build → Push → Deploy

---

## Project Structure
```
hw2/
├── index.html          # Homepage (from HW1)
├── survey.html         # Student Survey form (from HW1)
├── error.html          # Error page (from HW1)
├── Dockerfile          # Docker build instructions
├── nginx.conf          # Nginx web server config
├── deployment.yaml     # Kubernetes Deployment + Service manifest
├── Jenkinsfile         # CI/CD pipeline definition
└── README.md           # This file
```

---

## Application URLs
- **Kubernetes Deployed App:** http://EXTERNAL_IP  *(fill in after deployment)*

---

## Tools & References
- Docker: https://www.docker.com/
- Docker Hub: https://hub.docker.com/
- Rancher: https://rancher.com/docs
- kubectl: https://kubernetes.io/docs/tasks/tools/
- Jenkins: https://www.jenkins.io/
- nginx: https://hub.docker.com/_/nginx
