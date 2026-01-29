#!/bin/bash
# ============================================================
# EC2 Deployment Script for Acada Learning Web Application
# ============================================================
# 
# USAGE:
#   ./deploy-to-ec2.sh <ec2-user>@<ec2-host> <path-to-.env> <path-to-private-key.pem>
#
# EXAMPLE:
#   ./deploy-to-ec2.sh ec2-user@54.123.45.67 .env ~/.ssh/acada-key.pem
#
# PREREQUISITES:
#   - EC2 instance running and accessible via SSH
#   - Tomcat installed at /opt/tomcat
#   - PostgreSQL accessible from EC2 instance
#   - Application built: mvn clean package

set -e  # Exit on any error

# Configuration
EC2_HOST="${1:-}"
ENV_FILE="${2:-.env}"
PRIVATE_KEY="${3:-}"
TOMCAT_HOME="/opt/tomcat"
CONFIG_DIR="/etc/acada"
APP_NAME="web-app"
WAR_FILE="target/${APP_NAME}.war"

# Validate inputs
if [ -z "$EC2_HOST" ]; then
    echo "❌ Error: EC2 host not provided"
    echo "Usage: $0 <ec2-user>@<ec2-host> [.env-file] [private-key.pem]"
    exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Error: .env file not found at $ENV_FILE"
    exit 1
fi

if [ ! -f "$WAR_FILE" ]; then
    echo "❌ Error: WAR file not found at $WAR_FILE"
    echo "Please run: mvn clean package"
    exit 1
fi

# Build SSH command
SSH_CMD="ssh"
if [ -n "$PRIVATE_KEY" ]; then
    SSH_CMD="ssh -i $PRIVATE_KEY"
fi

SCP_CMD="scp"
if [ -n "$PRIVATE_KEY" ]; then
    SCP_CMD="scp -i $PRIVATE_KEY"
fi

echo "🚀 Starting EC2 Deployment..."
echo "   Target: $EC2_HOST"
echo "   Config: $ENV_FILE"
echo ""

# Step 1: Create config directory on EC2
echo "📁 Creating configuration directory on EC2..."
$SSH_CMD "$EC2_HOST" "sudo mkdir -p $CONFIG_DIR && sudo chmod 755 $CONFIG_DIR" || {
    echo "⚠️  Could not create directory (may already exist)"
}

# Step 2: Copy .env file to EC2
echo "📤 Uploading .env file..."
$SCP_CMD "$ENV_FILE" "$EC2_HOST:/tmp/.env" || {
    echo "❌ Failed to copy .env file"
    exit 1
}

# Step 3: Move .env to config directory with proper permissions
echo "🔐 Setting up .env with secure permissions..."
$SSH_CMD "$EC2_HOST" "sudo mv /tmp/.env $CONFIG_DIR/.env && sudo chmod 600 $CONFIG_DIR/.env && sudo chown tomcat:tomcat $CONFIG_DIR/.env" || {
    echo "❌ Failed to set up .env file"
    exit 1
}

# Step 4: Verify .env is readable
echo "✅ Verifying .env configuration..."
$SSH_CMD "$EC2_HOST" "sudo cat $CONFIG_DIR/.env | head -3" > /dev/null || {
    echo "⚠️  Warning: Could not verify .env file"
}

# Step 5: Copy WAR file to Tomcat
echo "📤 Uploading application WAR file..."
$SCP_CMD "$WAR_FILE" "$EC2_HOST:/tmp/${APP_NAME}.war" || {
    echo "❌ Failed to copy WAR file"
    exit 1
}

# Step 6: Stop Tomcat
echo "🛑 Stopping Tomcat..."
$SSH_CMD "$EC2_HOST" "sudo systemctl stop tomcat || sudo $TOMCAT_HOME/bin/shutdown.sh" || true

# Wait for Tomcat to stop
sleep 3

# Step 7: Backup existing WAR
echo "💾 Backing up previous application..."
$SSH_CMD "$EC2_HOST" "sudo cp $TOMCAT_HOME/webapps/${APP_NAME}.war $TOMCAT_HOME/webapps/${APP_NAME}.war.backup" || true

# Step 8: Remove old application
echo "🗑️  Cleaning old application..."
$SSH_CMD "$EC2_HOST" "sudo rm -rf $TOMCAT_HOME/webapps/${APP_NAME} $TOMCAT_HOME/webapps/${APP_NAME}.war"

# Step 9: Deploy new WAR
echo "📦 Deploying new application..."
$SSH_CMD "$EC2_HOST" "sudo mv /tmp/${APP_NAME}.war $TOMCAT_HOME/webapps/ && sudo chown tomcat:tomcat $TOMCAT_HOME/webapps/${APP_NAME}.war"

# Step 10: Set environment variable for config location
echo "⚙️  Configuring Tomcat environment..."
$SSH_CMD "$EC2_HOST" "cat > /tmp/tomcat-env.sh << 'EOF'
#!/bin/bash
export ENV_FILE_PATH=$CONFIG_DIR/.env
EOF
sudo mv /tmp/tomcat-env.sh /opt/tomcat/bin/env.sh
sudo chmod +x /opt/tomcat/bin/env.sh" || true

# Step 11: Start Tomcat
echo "🚀 Starting Tomcat..."
$SSH_CMD "$EC2_HOST" "sudo systemctl start tomcat || sudo $TOMCAT_HOME/bin/startup.sh" || {
    echo "❌ Failed to start Tomcat"
    exit 1
}

# Step 12: Wait for Tomcat to start
echo "⏳ Waiting for Tomcat to start..."
sleep 5

# Step 13: Verify deployment
echo "🔍 Verifying deployment..."
HTTP_CODE=$($SSH_CMD "$EC2_HOST" "curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/${APP_NAME}/admin" || echo "000")

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Deployment successful!"
    echo ""
    echo "📊 Application Status:"
    echo "   URL: http://$EC2_HOST:8080/${APP_NAME}/"
    echo "   Admin Panel: http://$EC2_HOST:8080/${APP_NAME}/admin"
    echo "   HTTP Status: $HTTP_CODE"
    echo ""
    echo "🔧 Configuration Location: $CONFIG_DIR/.env"
    echo "📝 To update config: scp .env $EC2_HOST:/tmp/ && ssh $EC2_HOST 'sudo mv /tmp/.env $CONFIG_DIR/'"
else
    echo "⚠️  Deployment may have issues (HTTP $HTTP_CODE)"
    echo "📋 Check logs with: ssh $EC2_HOST 'sudo tail -100 $TOMCAT_HOME/logs/catalina.out'"
    exit 1
fi

echo ""
echo "✨ Deployment complete!"
