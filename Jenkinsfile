pipeline{
    agent any
    tools {
        maven 'maven3.9'
    }
    stages {
        stage('Code Checkout') {
            steps{
                git branch: 'main', credentialsId: 'jenkins', url: 'https://github.com/udodi05/acada-webapp.git'
            }
        }
        stage('Build'){
            steps{
                sh 'mvn clean package'
            }
        }
        stage('Deploy'){
            steps{
                deploy adapters: [tomcat9(credentialsId: 'tomcat_password', path: '', url: 'http://50.17.14.225:8080/')], contextPath: 'web-app', war: 'target/*.war'
            }
    }    }
}
