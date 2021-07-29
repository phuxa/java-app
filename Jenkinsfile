pipeline {

  environment {
    PROJECT = "iamotis"
    APP_NAME = "java-app"
    FE_SVC_NAME = "${APP_NAME}-frontend"
    CLUSTER = "jenkins-cd"
    CLUSTER_ZONE = "us-east1-d"
    IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
    JENKINS_CRED = "${PROJECT}"
  }

  agent {
    kubernetes {
      label 'sample-app'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: cd-jenkins
  containers:
  - name: java
    image: openjdk:11
    command:
    - cat
    tty: true
  - name: gcloud
    image: gcr.io/cloud-builders/gcloud
    command:
    - cat
    tty: true
  - name: kubectl
    image: gcr.io/cloud-builders/kubectl
    command:
    - cat
    tty: true
"""
}
  }
  stages {
    
    stage('Test') {
      steps {
        echo"test"
      }
    }
    stage('Build and push image with Container Builder') {
      steps {
        container('gcloud') {
          sh "PYTHONUNBUFFERED=1 gcloud builds submit -t ${IMAGE_TAG} ."
        }
      }
    }
    
    stage('Deploy Production') {
      // Production branch
      when { branch 'master' }
      steps{
        container('kubectl') {
          sh("sed -i 's/:v1/:master.${env.BUILD_NUMBER}/g' ./k8s/production/*.yaml")
          sh("kubectl apply -f ./k8s/production/*.yaml")
        }
      }
    }
    stage('Deploy Dev') {
      
      when {
        not { branch 'master' }
      }
      steps {
        container('kubectl') {
           sh("sed -i 's/:v1/:dev.${env.BUILD_NUMBER}/g' ./k8s/dev/*.yaml")
           sh("kubectl apply -f ./k8s/dev/*.yaml")
        }
      }
    }
  }
}
