pipeline {
  agent any
    

    
  stages {
     
    stage('Build') {
      steps {
        sh 'npm install'
      }
    }  
    stage('Lint') {
      steps {
        sh 'Npm run lint'
     }
    }
            
    stage('Test') {
      steps {
        sh 'npm run test:ci'
     }
    }
  }
}