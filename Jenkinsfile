pipeline {
//  agent any
options ([disableConcurrentBuilds()])
  triggers {
    cron (BRANCH_NAME == "master" ? "0 2 * * *" : "")
  }
  agent {label 'dev_lab_2'}
  stages {
		stage('install') {
			steps {
        sh 'npm install || ls || pwd'
			}
		}
/*		stage('Lint') {
			steps {
				sh 'npm run lint'
			}
		}
*/
		stage('Test') {
			steps {
				sh 'npm run test:ci'
//         sleep 15
			}
		}
    stage('Build') {
			steps {
				sh '''
          npm run build
          pwd && ls -l
          ls -la "dist/TestProjectJenkins/"
          ls -la "/var/www/TestProjectJenkins/"
        '''
//        archiveArtifacts artifacts: 'dist/TestProjectJenkins/*', followSymlinks: false, onlyIfSuccessful: true
        chuckNorris()
      }
		}

    stage('deploy') {
//      when { branch 'master' }
			steps {
				sh '''
          rm -rf  dist
          rm -rf node_modules
          docker build -t testangular:v-$build_id .
        '''
			}
		}

	}
}
