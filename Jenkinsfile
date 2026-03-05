pipeline{
    agent {
        labels 'acada-node'
    }
    tools {
        maven 'mvn3.9'
    }
    environment {
        DEPLOY_DB = 'True'
        DB_HOST = '3.96.167.29'
        NEXUS_HOST = "15.222.6.124"
        SONARQUBE_HOST = "15.222.233.235"
        APP_HOST = "99.79.41.129"
       
    }
    stages {
        stage('Git checkout'){
            steps{
             git branch: 'main', changelog: false, credentialsId: 'git-hub', url: 'https://github.com/udodi05/acada-webapp.git'               
            }
        }
        stage('Sonar Scan') {
            steps{
                    withCredentials([string(credentialsId: 'sonarqube_token', variable: 'SONAR_TOKEN')]) {
                        sh 'mvn clean verify sonar:sonar -Dsonar.projectName=Acada-webapp -Dsonar.host.url=http://${SONARQUBE_HOST}:9000 -Dsonar.token=${SONAR_TOKEN} -Dsonar.qualitygate.wait=true'
                }
            }
        }
        stage('Image Build | Push | Deploy to Nexus Repository') {
            parallel {
                stage('Image Build') {
                    steps{
                        withCredentials([usernamePassword(credentialsId: 'nexus-creds', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USER')]) {
                            sh 'echo ${NEXUS_PASSWORD} | docker login ${NEXUS_HOST}:90 -u ${NEXUS_USER} --password-stdin'
                            sh 'docker build -t ${NEXUS_HOST}:90/acada-repo/acada-webapp:v1 .'
                            sh 'docker push ${NEXUS_HOST}:90/acada-repo/acada-webapp:v1'
                        }
                    }
                }
                stage('Deploy to Nexus Repo') {
                    steps{
                        withCredentials([usernamePassword(credentialsId: 'nexus-creds', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USER')]) {
                            sh 'mvn deploy -Drepo.login=${NEXUS_USER} -Drepo.pwd=${NEXUS_PASSWORD} -s settings.xml'
                        }
                    }
                }
            }
        }
        stage('Deploy Database') {
            when {
                environment name: 'DEPLOY_DB', value: 'True'
            }
            steps{
                withCredentials([
                    usernamePassword(credentialsId: 'db_creds', passwordVariable: 'DB_PASSWORD', usernameVariable: 'DB_USER'),
                    sshUserPrivateKey(credentialsId: 'ec2-creds', keyFileVariable: 'EC2_KEY', usernameVariable: 'EC2_USER')
                    ]){
                        sh 'echo "POSTGRES_USER=$DB_USER" > .db_env'
                        sh 'echo "POSTGRES_PASSWORD=$DB_PASSWORD" >> .db_env'
                        sh 'ssh -o StrictHostKeyChecking=no -i ${EC2_KEY} ${EC2_USER}@${DB_HOST} "mkdir ~/web-app-db/" || true'
                        sh 'scp -o StrictHostKeyChecking=no -i ${EC2_KEY} init-db.sql .db_env deploy_db.sh ${EC2_USER}@${DB_HOST}:~/web-app-db/'
                        sh 'ssh -o StrictHostKeyChecking=no -i ${EC2_KEY} ${EC2_USER}@${DB_HOST} "bash ~/web-app-db/deploy_db.sh"'
                }
            }
        }
        stage('Deploy Application') {
            steps{
                    withCredentials([
                        usernamePassword(credentialsId: 'db_creds', passwordVariable: 'DB_PASSWORD', usernameVariable: 'DB_USER'),
                        usernamePassword(credentialsId: 'nexus-creds', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USER'),
                        sshUserPrivateKey(credentialsId: 'ec2-creds', keyFileVariable: 'EC2_KEY', usernameVariable: 'EC2_USER'),
                        string(credentialsId: 'smtp_creds', variable: 'SMTP_PASSWORD'),
                    ]) {
                        sh 'echo "DB_HOST=${DB_HOST}" > .app_env'
                        sh 'echo "DB_PORT=5432" >> .app_env'
                        sh 'echo "DB_NAME=acada_db" >> .app_env'
                        sh 'echo "DB_USERNAME=$DB_USER" >> .app_env'
                        sh 'echo "DB_PASSWORD=$DB_PASSWORD" >> .app_env'
                        sh 'echo "NEXUS_USER=$NEXUS_USER" >> .app_env'
                        sh 'echo "NEXUS_PASSWORD=$NEXUS_PASSWORD" >> .app_env'
                        sh 'echo "NEXUS_HOST=$NEXUS_HOST" >> .app_env'
                        sh 'echo "SMTP_HOST=smtp.gmail.com" >> .app_env'
                        sh 'echo "SMTP_PORT=587" >> .app_env'
                        sh 'echo "SMTP_USERNAME=kelechi.ifediniru@gmail.com" >> .app_env'
                        sh 'echo "SMTP_PASSWORD=$SMTP_PASSWORD" >> .app_env'
                        sh 'echo "SMTP_FROM_EMAIL=kelechi.ifediniru@gmail.com" >> .app_env'
                        sh 'ssh -o StrictHostKeyChecking=no -i ${EC2_KEY} ${EC2_USER}@${APP_HOST} "mkdir ~/web-app/" || true'
                        sh 'scp -o StrictHostKeyChecking=no -i ${EC2_KEY} .app_env deploy_app.sh haproxy.cfg ${EC2_USER}@${APP_HOST}:~/web-app/'
                        sh 'ssh -o StrictHostKeyChecking=no -i ${EC2_KEY} ${EC2_USER}@${APP_HOST} "bash ~/web-app/deploy_app.sh"'
                    }
            }
        }
    }
}