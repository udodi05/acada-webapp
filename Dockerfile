FROM tomcat:11

# Copy application
COPY target/*.war /usr/local/tomcat/webapps/web-app.war

# Copy Tomcat configurations
RUN cp -rf /usr/local/tomcat/webapps.dist/manager /usr/local/tomcat/webapps/manager && \
    cp -rf /usr/local/tomcat/webapps.dist/host-manager /usr/local/tomcat/webapps/host-manager
RUN rm -rf /usr/local/tomcat/webapps/host-manager/META-INF/context.xml && \
    rm -rf /usr/local/tomcat/webapps/manager/META-INF/context.xml
COPY context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

# Configuration for production deployment
# The application looks for .env in this order:
# 1. ENV_FILE_PATH environment variable (if set)
# 2. /etc/acada/.env (production path)
# 3. ./.env (local/development path)
#
# DEPLOYMENT INSTRUCTIONS:
# Local development with Docker:
#   docker run -v $(pwd)/.env:/opt/tomcat/.env acada-webapp
#
# EC2 deployment:
#   1. Place .env at /etc/acada/.env on the EC2 instance
#   2. Set permissions: chmod 600 /etc/acada/.env
#   3. Mount when running: -v /etc/acada/.env:/etc/acada/.env
#   OR
#   1. Set ENV_FILE_PATH=/opt/acada/.env in container environment
#   2. Mount: -v /host/path/.env:/opt/acada/.env
#
# Example systemd service on EC2:
#   [Service]
#   Environment="ENV_FILE_PATH=/etc/acada/.env"
#   ExecStart=/opt/tomcat/bin/catalina.sh run

EXPOSE 8080
CMD ["catalina.sh", "run"]
