// Name: Gnanitha Suryadevara
// Course: SWE 645 - HW2
// Purpose: Jenkinsfile defining CI/CD pipeline for automated build and deployment to Kubernetes

pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'YOUR_DOCKERHUB_USERNAME'       // <-- Replace with your Docker Hub username
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/swe645-hw2"
        IMAGE_TAG = "latest"
        KUBECONFIG_CREDENTIAL_ID = 'kubeconfig-credentials'  // Jenkins credential ID for kubeconfig
        DOCKERHUB_CREDENTIAL_ID  = 'dockerhub-credentials'  // Jenkins credential ID for Docker Hub
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDENTIAL_ID}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes cluster...'
                withCredentials([file(
                    credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                    variable: 'KUBECONFIG'
                )]) {
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl rollout restart deployment/swe645-deployment"
                    sh "kubectl rollout status deployment/swe645-deployment"
                }
            }
        }

    }

    post {
        success {
            echo 'Pipeline completed successfully! Application deployed.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs above.'
        }
    }
}
