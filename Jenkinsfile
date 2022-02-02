#!/usr/bin/env groovy

pipeline {
    agent {label 'dev_lab_2'}

    options {
      buildDiscarder(logRotator(numToKeepStr: '10'))
      disableConcurrentBuilds()
      timeout(time: 1, unit: 'HOURS')
      timestamps()
    }

//    tools {}

    environment {
      AWS_ECR_URL_REG= '216920179355.dkr.ecr.eu-central-1.amazonaws.com/vk-testangular'
      AWS_ECR_URL= '216920179355.dkr.ecr.eu-central-1.amazonaws.com'
      AWS_ECR_REGION = 'eu-central-1'
      THE_BUTLER_SAYS_SO=credentials('jenkins-aws-beanstalk')
//      POM_VERSION = getVersion()
//      JAR_NAME = getJarName()
      AWS_ECS_SERVICE = 'vk-fargate-service'
      AWS_ECS_TASK_DEFINITION = 'vk-v2'
      AWS_ECS_COMPATIBILITY = 'FARGATE'
      AWS_ECS_EXECUTION_ROL = 'ecsTaskExecutionRole'
      AWS_ECS_NETWORK_MODE = 'awsvpc'
      AWS_ECS_CPU = '256'
      AWS_ECS_MEMORY = '512'
      AWS_ECS_CLUSTER = 'vk-cluster-fargate'
      AWS_ECS_TASK_DEFINITION_PATH = 'aws/container-definition-update-image.json'
      NEW_ECR_IMAGE = "216920179355.dkr.ecr.eu-central-1.amazonaws.com/vk-testangular:${BUILD_ID}"
    }

    stages {
        stage('Build & Test') {
          steps {
            sh ' ls -l '
    			}
        }

        stage('Build Docker Image') {
          steps {
            script {
              sh '''
                docker build -t ${AWS_ECR_URL_REG}:${BUILD_ID} .
                 '''
            }
          }
        }

        stage('Push Image to ECR') {
          steps {
            sh '''
              aws ecr get-login-password | docker login --username AWS --password-stdin ${AWS_ECR_URL}
              docker push ${AWS_ECR_URL_REG}:${BUILD_ID}
               '''
          }
        }

        stage('Deploy in ECS') {
          steps {
            script {
              sh '''
                jq --arg newImage "$NEW_ECR_IMAGE" '.containerDefinitions[0].image = $newImage' aws/container-definition-update-image.json > "tmp" && mv "tmp" aws/container-definition-update-image.json
                aws ecs register-task-definition  --family vk-v2 --cli-input-json file://aws/container-definition-update-image.json
                aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --force-new-deployment
              '''
            }
          }
        }
    }

//    post {}
}
