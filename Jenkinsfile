pipeline {
  agent any
    

    
  stages {
     
    stage('Build') {
      steps {
        sh 'npm install'
 //       sh 'npm start'
      }
    }  
    
            
    stage('Test') {
      steps {
        sh 'ng test --watch=false'
     }
    }
  }
}