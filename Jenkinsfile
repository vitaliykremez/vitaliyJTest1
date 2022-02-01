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
      AWS_ECS_SERVICE = 'vk-fagate-service'
      AWS_ECS_TASK_DEFINITION = 'vk-v2'
      AWS_ECS_COMPATIBILITY = 'FARGATE'
      AWS_ECS_NETWORK_MODE = 'awsvpc'
      AWS_ECS_CPU = '256'
      AWS_ECS_MEMORY = '512'
      AWS_ECS_CLUSTER = 'vk-cluster-fargate'
      AWS_ECS_TASK_DEFINITION_PATH = './ecs/container-definition-update-image.json'
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
        //      updateContainerDefinitionJsonWithImageVersion()
              sh("/usr/local/bin/aws ecs register-task-definition --region ${AWS_ECR_REGION} --family ${AWS_ECS_TASK_DEFINITION} --execution-role-arn ${AWS_ECS_EXECUTION_ROL} --requires-compatibilities ${AWS_ECS_COMPATIBILITY} --network-mode ${AWS_ECS_NETWORK_MODE} --cpu ${AWS_ECS_CPU} --memory ${AWS_ECS_MEMORY} --container-definitions file://${AWS_ECS_TASK_DEFINITION_PATH}")
              def taskRevision = sh(script: "/usr/local/bin/aws ecs describe-task-definition --task-definition ${AWS_ECS_TASK_DEFINITION} | egrep \"revision\" | tr \"/\" \" \" | awk '{print \$2}' | sed 's/\"\$//'", returnStdout: true)
              sh("/usr/local/bin/aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --task-definition ${AWS_ECS_TASK_DEFINITION}:${taskRevision}")
            }
          }
        }
    }

//    post {}
}
