pipeline {
    agent any
    tools {
        maven 'maven3.9'
    }
    stages {
        stage('Git checkout') {
            steps {
                sh 'echo "Checkout git based project"'
                git branch: 'main', credentialsId: 'jenkins', url: 'https://github.com/udodi05/acada-webapp.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
}