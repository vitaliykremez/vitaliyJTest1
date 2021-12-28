pipeline {
//  agent any  
//  checkout(
 //         [$class: 'GitSCM', 
 //         branches: [[name: '*/master']], 
 //         extensions: [[$class: 'PreBuildMerge', 
 //         options: [mergeStrategy: 'RECURSIVE_THEIRS', 
 //                   mergeTarget: 'master']]], 
 //         userRemoteConfigs: [[credentialsId: 'j14', url: 'https://github.com/vitaliykremez/vitaliyJTest1.git']]]
 //  )
  agent {label 'dev_lab_2'}
  stages {
		stage('Build') {
			steps {
        sh 'npm install || ls || pwd'
			}
		}
//		stage('Lint') {
//			steps {
//				sh 'npm run lint'
//			}
//		}
            
		stage('Test') {
			steps {
				sh 'npm run test:ci'
         sleep 15
			}
		}
	}
}
