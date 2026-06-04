pipeline {
  agent any
  tools {
    maven 'maven3.9'
  }
  environment {
    deploy_DB = "true"
    DB_HOST   = "15.157.68.146"
    APP_HOST  = "35.183.18.77"
  }
  stages {
    stage("Git checkout") {
      steps {
        git branch: 'main', url: 'https://github.com/udodi05/acada-webapp.git'
      }
    }
    stage("Sonar Scan") {
      steps{
        withCredentials([string(credentialsId: 'sonar_token', variable: 'SONAR_TOKEN')]) {
          sh """
            mvn clean verify sonar:sonar \
            -Dsonar.projectKey=acada-webapp \
            -Dsonar.projectName='acada-webapp' \
            -Dsonar.host.url=http://15.223.69.242:9000 \
            -Dsonar.token=${SONAR_TOKEN}
          """
        }
      }
    }
    stage("Maven Packaging") {
      steps {
        sh 'mvn clean package'
      }
    }
    stage("Image Build & Push") {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-PAT', passwordVariable: 'DOCKERHUB_PASS', usernameVariable: 'DOCKERHUB_USER')]) {
          sh 'echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin'
        }
        sh 'docker build -t kniru/acada-webapp:latest .'
        sh 'docker push kniru/acada-webapp:latest'
      }
    }
    stage("Archive Artifact On Nexus") {
      steps{
        withCredentials([usernamePassword(credentialsId: 'nexus-cred', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USER')]) {
          sh "mvn deploy -Drepo.login=${NEXUS_USER} -Drepo.pwd=${NEXUS_PASSWORD} -s settings.xml"
        }
      }
    }
    stage("Deploy: DATABASE") {
      steps {
        script {
          if (deploy_DB == "true") {
            withCredentials([usernamePassword(credentialsId: 'DB-Pass', passwordVariable: 'POSTGRES_PASS', usernameVariable: 'POSTGRES_USER')]) {
              sh """
                echo 'POSTGRES_USER=${POSTGRES_USER}'      > .env
                echo 'POSTGRES_PASSWORD=${POSTGRES_PASS}' >> .env
              """
            }
            withCredentials([sshUserPrivateKey(credentialsId: 'DB-HOST', keyFileVariable: 'DB_SSH_KEY', usernameVariable: 'DB_SSH_USER')]) {
              sh "ssh -o StrictHostKeyChecking=no -i ${DB_SSH_KEY} ${DB_SSH_USER}@${DB_HOST} 'mkdir -p ~/web-app-db/'"
              sh "scp -o StrictHostKeyChecking=no -i ${DB_SSH_KEY} .env init-db.sql ${DB_SSH_USER}@${DB_HOST}:~/web-app-db/"
              sh """
                ssh -o StrictHostKeyChecking=no -i ${DB_SSH_KEY} ${DB_SSH_USER}@${DB_HOST} '
                  docker rm -f acada-postgres || true
                  docker run -d \\
                    --name acada-postgres \\
                    -p 5432:5432 \\
                    -v ~/web-app-db/init-db.sql:/docker-entrypoint-initdb.d/init-db.sql \\
                    --env-file ~/web-app-db/.env \\
                    postgres:15-alpine
                '
              """
            }
          }
        }
      }
    }
    stage("Deploy: APPLICATION") {
      steps {
        withCredentials([
          usernamePassword(credentialsId: 'docker-PAT', passwordVariable: 'DOCKERHUB_PASS', usernameVariable: 'DOCKERHUB_USER'),
          usernamePassword(credentialsId: 'DB-Pass',    passwordVariable: 'POSTGRES_PASS',  usernameVariable: 'POSTGRES_USER')
        ]) {
          sh """
            echo 'DB_HOST=${DB_HOST}'           > .env
            echo 'DB_PORT=5432'                >> .env
            echo 'DB_NAME=acada_db'            >> .env
            echo 'DB_USERNAME=${POSTGRES_USER}' >> .env
            echo 'DB_PASSWORD=${POSTGRES_PASS}' >> .env
          """
          withCredentials([sshUserPrivateKey(credentialsId: 'DB-HOST', keyFileVariable: 'APP_SSH_KEY', usernameVariable: 'APP_SSH_USER')]) {
            sh "ssh -o StrictHostKeyChecking=no -i ${APP_SSH_KEY} ${APP_SSH_USER}@${APP_HOST} 'mkdir -p ~/web-app/'"
            sh "scp -o StrictHostKeyChecking=no -i ${APP_SSH_KEY} .env ${APP_SSH_USER}@${APP_HOST}:~/web-app/"
            sh """
              ssh -o StrictHostKeyChecking=no -i ${APP_SSH_KEY} ${APP_SSH_USER}@${APP_HOST} \
                'echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin && \
                 docker rm -f acada-app || true && \
                 docker pull kniru/acada-webapp:latest && \
                 docker run -d \\
                   --name acada-app \\
                   -p 8080:8080 \\
                   --env-file ~/web-app/.env \\
                   kniru/acada-webapp:latest'
            """
          }
        }
      }
    }
  }
}