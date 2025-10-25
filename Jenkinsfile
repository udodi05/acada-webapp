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
        stage('Deploy LoadBalancer'){
            steps{
                withCredentials([sshUserPrivateKey(credentialsId: 'aws-haproxy', keyFileVariable: 'SSH-KEY', usernameVariable: 'SSH-USER')]) {
                    scp haproxy.cfg -i $SSH-KEY $SSH-USER@18.209.69.196:/tmp/
                    ssh -i $SSH-KEY $SSH-USER@18.209.69.196 <<'EOF'
                    echo "Deploying HAproxy container..."
                    docker rm haproxy -f >/dev/null 2>&1 || true
                    docker run -d --name haproxy -v /tmp/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro -p 443:80 haproxy:latest
                    docker ps | grep -i haproxy*
                    echo "Deploying HAproxy container done"
                    EOF
                }
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