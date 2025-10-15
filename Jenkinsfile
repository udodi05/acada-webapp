pipeline{
    agent any
    stages {
        stage('Code Checkout') {
            steps{
                git branch: 'main', credentialsId: 'jenkins-pipeline', url: 'https://github.com/udodi05/acada-webapp.git'
            }
        }
    }
}