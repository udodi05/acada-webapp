pipeline {
    agent any
    tools {
        maven 'maven3.9'
    }
    environment {
        GIT_URL = 'https://github.com/udodi05/acada-webapp.git'
        GIT_CREDENTIALS = 'jenkins'
        TOMCAT_URL = 'http://54.242.139.174:8080/'
        TOMCAT_CREDENTIALS = 'tomcat-password'
        TOMCAT_CONTEXT = 'web-app'
    }
    stages {
        stage('Git checkout') {
            steps {
                sh 'echo "Checkout git based project"'
                git branch: 'main', credentialsId: "${GIT_CREDENTIALS}", url: "${GIT_URL}"
            }
        }
        stage('Test Code') {
            steps{
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR-TOKEN')]) {
                    sh 'mvn sonar:sonar -Dsonar.login=$SONAR-TOKEN}'
                }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Deploy') {
            steps {
                deploy adapters: [tomcat9(credentialsId: "${TOMCAT_CREDENTIALS}", path: '', url: "${TOMCAT_URL}")], contextPath: "${TOMCAT_CONTEXT}", war: 'target/*.war'
            }
        }
        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.war', followSymlinks: false
            }
        }
    }
}