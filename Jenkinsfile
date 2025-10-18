pipeline {
    agent any
    stages {
        stage('Git checkout') {
            steps {
                sh 'echo "Checking git base project"'
                git branch: 'main', credentialsId: 'jenkins', url: 'https://github.com/udodi05/acada-webapp.git'
            }
        }
    }
}