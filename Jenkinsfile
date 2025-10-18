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
        stage('Deploy') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat-password', path: '', url: 'http://54.242.139.174:8080/')], contextPath: 'web-app', war: 'target/*.war'
            }
        }
        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.war', followSymlinks: false
            }
        }
    }
}