pipeline {
    agent any
    stages {
        stage('Git checkout') {
            steps {
                git branch: 'main', credentialsId: 'jenkins', url: 'https://github.com/udodi05/acada-webapp.git'
            }
        }
    }
}