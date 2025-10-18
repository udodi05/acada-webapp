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
        JFROG_TOKEN = 'eyJ2ZXIiOiIyIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYiLCJraWQiOiJhY2JZZGk4SlRjN0FFWXRIZEYzUWdEU2pDTlZfNkc0ZFFhTXJ4YzlTOTlFIn0.eyJleHQiOiJ7XCJyZXZvY2FibGVcIjpcInRydWVcIn0iLCJzdWIiOiJqZmFjQDAxazd3NTlnOWZhMjZhMXptdzFqZ2Exejg1XC91c2Vyc1wvYWRtaW4iLCJzY3AiOiJhcHBsaWVkLXBlcm1pc3Npb25zXC91c2VyIiwiYXVkIjoiKkAqIiwiaXNzIjoiamZmZUAwMDAiLCJpYXQiOjE3NjA4MDgzMzksImp0aSI6IjU5ZmNlZDA2LWI5YzUtNDM1OS04MzZjLTMwOTNiZmUyYThhYiJ9.KZlT_pB9mkAmmUNPxz7vTnsaZQQ62J0szDUmb4J9-VMv_UUhkX47iZLYiULZrsWSqBh_B6aO_fp-kDI8iL0VqA4FKfQ-3NpDsnOnWwqoauXi2g4Pb23qSWBN4mwYl0s0t66oLmrzqWzia6d-9VESTjLLDk7kV3oAm7HQ_Jg7iHEC2jqT2ToEhIlIhvM6BMXl_Tob8l-62LuDqzn9HDsNhSDQEmza2ne0IJAQW_4Ne6YheIt9A-JoI7TzQ2DZ4MSmAe02yw0_zk_NTq82IemXtMtjYLDi-LTQ7eOMQtWl5u52ztp7B_HFthuWTduwoPTSefghmtiVS5KC4nepCiWgqA'
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
                deploy adapters: [tomcat9(credentialsId: "${TOMCAT_CREDENTIALS}", path: '', url: "${TOMCAT_URL}")], contextPath: "${TOMCAT_CONTEXT}", war: 'target/*.war'
            }
        }
        stage('Archive') {
            steps {
                sh 'mvn -Drepo.pwd="${JFROG_TOKEN}" deploy -s settings.xml'
            }
        }
    }
}