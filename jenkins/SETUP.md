# Jenkins Installation and Setup Guide
# Sistema de Inventario - CI/CD Pipeline

## Prerequisites

- AWS Account with appropriate permissions
- Git repository (GitHub/GitLab/Bitbucket)
- Domain for Jenkins (optional but recommended)

---

## Option 1: Jenkins on AWS EC2 (Recommended)

### Step 1: Launch EC2 Instance

```bash
# Instance specifications:
# - AMI: Amazon Linux 2 or Ubuntu 22.04
# - Instance Type: t3.medium (2 vCPU, 4 GB RAM minimum)
# - Storage: 50 GB gp3
# - Security Group: Allow ports 8080 (Jenkins), 22 (SSH)
```

### Step 2: Install Jenkins

**For Amazon Linux 2:**
```bash
# Update system
sudo yum update -y

# Install Java
sudo amazon-linux-extras install java-openjdk11 -y

# Add Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
sudo yum install jenkins -y

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

**For Ubuntu 22.04:**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Java
sudo apt install openjdk-11-jdk -y

# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update
sudo apt install jenkins -y

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Step 3: Access Jenkins

1. Open browser: `http://<EC2-PUBLIC-IP>:8080`
2. Enter initial admin password
3. Install suggested plugins
4. Create admin user

---

## Option 2: Jenkins with Docker (Development)

```bash
# Create volume for persistence
docker volume create jenkins_home

# Run Jenkins container
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts

# Get initial password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# Access: http://localhost:8080
```

---

## Step 4: Install Required Plugins

Navigate to: `Manage Jenkins > Manage Plugins > Available`

Install these plugins:
- ✅ Pipeline
- ✅ Git
- ✅ Docker Pipeline
- ✅ AWS Credentials
- ✅ Terraform
- ✅ SonarQube Scanner
- ✅ Blue Ocean (optional, better UI)
- ✅ Slack Notification (optional)
- ✅ Email Extension
- ✅ Build Timeout
- ✅ Timestamper

---

## Step 5: Configure Global Tools

Go to: `Manage Jenkins > Global Tool Configuration`

### Terraform
- Name: `Terraform`
- Install automatically: ✅
- Version: `1.5.7`

### Docker
- Name: `Docker`
- Install automatically: ✅

### SonarQube Scanner
- Name: `SonarQube Scanner`
- Install automatically: ✅
- Version: Latest

---

## Step 6: Configure Credentials

Go to: `Manage Jenkins > Manage Credentials > (global)`

### 1. AWS Credentials
- Kind: `AWS Credentials`
- ID: `aws-credentials`
- Access Key ID: `<your-access-key>`
- Secret Access Key: `<your-secret-key>`

### 2. Database Password
- Kind: `Secret text`
- ID: `db-password`
- Secret: `<your-db-password>`

### 3. SonarQube Token
- Kind: `Secret text`
- ID: `sonarqube-token`
- Secret: `<sonarqube-token>`

### 4. Git Credentials
- Kind: `Username with password` or `SSH Username with private key`
- ID: `git-credentials`
- Username/Key: `<your-credentials>`

---

## Step 7: Configure SonarQube Integration

### Option A: Install SonarQube with Docker

```bash
docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  sonarqube:lts-community
```

Access: `http://localhost:9000`
- Default credentials: admin/admin

### Option B: Use SonarCloud

1. Go to https://sonarcloud.io
2. Sign up with GitHub/GitLab
3. Create organization and project
4. Generate token

### Configure in Jenkins

1. `Manage Jenkins > Configure System > SonarQube servers`
2. Add SonarQube:
   - Name: `SonarQube`
   - Server URL: `http://<sonarqube-url>:9000` or SonarCloud URL
   - Server authentication token: Select `sonarqube-token` credential

---

## Step 8: Setup Build Agent

### Install Agent Tools (on agent machine)

```bash
#!/bin/bash
# Run this on your build agent

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Terraform
wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
unzip terraform_1.5.7_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Checkov
sudo pip3 install checkov

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installations
docker --version
terraform --version
aws --version
checkov --version
node --version
npm --version
```

### Add Agent to Jenkins

1. `Manage Jenkins > Manage Nodes and Clouds > New Node`
2. Node name: `build-agent-01`
3. Type: `Permanent Agent`
4. Configuration:
   - Remote root directory: `/home/jenkins`
   - Labels: `docker terraform build`
   - Usage: `Use this node as much as possible`
   - Launch method: `Launch agent via SSH`
   - Host: `<agent-ip>`
   - Credentials: Add SSH credentials

---

## Step 9: Create Jenkins Pipeline Job

1. Click `New Item`
2. Enter name: `sistema-inventario-pipeline`
3. Select: `Pipeline`
4. Click `OK`

### Configure Pipeline

**General:**
- Description: `CI/CD pipeline for Sistema de Inventario`
- ✅ Discard old builds: Keep last 10 builds

**Build Triggers:**
- ✅ GitHub hook trigger for GITScm polling (if using GitHub)
- ✅ Poll SCM: `H/5 * * * *` (every 5 minutes, backup)

**Pipeline:**
- Definition: `Pipeline script from SCM`
- SCM: `Git`
- Repository URL: `<your-repo-url>`
- Credentials: Select your git credentials
- Branch: `*/main` or `*/develop`
- Script Path: `Jenkinsfile`

---

## Step 10: Configure Terraform Backend (S3)

```bash
# Create S3 bucket for Terraform state
aws s3api create-bucket \
    --bucket sistemainventario-terraform-state \
    --region us-east-2 \
    --create-bucket-configuration LocationConstraint=us-east-2

# Enable versioning
aws s3api put-bucket-versioning \
    --bucket sistemainventario-terraform-state \
    --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region us-east-2
```

---

## Step 11: Test Pipeline

1. Push code to repository
2. Jenkins should automatically trigger
3. Monitor pipeline execution in Blue Ocean UI
4. Check each stage for success/failure

---

## Troubleshooting

### Jenkins won't start
```bash
# Check logs
sudo journalctl -u jenkins -f

# Check Java version
java -version
```

### Agent won't connect
```bash
# Check SSH connectivity
ssh jenkins@<agent-ip>

# Check agent logs in Jenkins UI
```

### Docker permission denied
```bash
# Add jenkins user to docker group
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Terraform state lock
```bash
# Force unlock (use carefully)
terraform force-unlock <lock-id>
```

---

## Security Best Practices

1. ✅ Use HTTPS for Jenkins (configure reverse proxy)
2. ✅ Enable CSRF protection
3. ✅ Use role-based access control
4. ✅ Regular backups of Jenkins home
5. ✅ Keep Jenkins and plugins updated
6. ✅ Use credentials plugin for all secrets
7. ✅ Limit agent access
8. ✅ Enable audit logging

---

## Next Steps

1. ✅ Review and customize Jenkinsfile
2. ✅ Configure notifications (Slack/Email)
3. ✅ Set up monitoring (CloudWatch, Prometheus)
4. ✅ Create runbook for common issues
5. ✅ Train team on pipeline usage
