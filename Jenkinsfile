pipeline {
    agent any
    tools {
        maven 'maven3.9'
    }
    environment {
        GIT_URL = 'https://github.com/udodi05/acada-webapp.git'
        GIT_CREDENTIALS = 'jenkins'
        TOMCAT_URL1 = 'http://54.172.146.136:8080/'
        TOMCAT_URL2 = 'http://34.228.31.255:8080/'
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
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh 'mvn sonar:sonar -Dsonar.login="${SONAR_TOKEN}"'
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
                deploy adapters: [tomcat9(credentialsId: "${TOMCAT_CREDENTIALS}", path: '', url: "${TOMCAT_URL1}")], contextPath: "${TOMCAT_CONTEXT}", war: 'target/*.war'
                deploy adapters: [tomcat9(credentialsId: "${TOMCAT_CREDENTIALS}", path: '', url: "${TOMCAT_URL2}")], contextPath: "${TOMCAT_CONTEXT}", war: 'target/*.war'
            }
        }
        stage('Archive') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-cred', passwordVariable: 'nexus_password', usernameVariable: 'nexus_username')]) {
                    sh 'mvn -Drepo.login="${nexus_username}" -Drepo.pwd="${nexus_password}" deploy -s settings.xml'
                }
            }
        }
    }
}