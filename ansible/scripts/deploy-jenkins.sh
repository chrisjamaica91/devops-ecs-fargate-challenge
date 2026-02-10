#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Jenkins Deployment Script${NC}"
echo -e "${GREEN}========================================${NC}"

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo -e "${RED}Error: Ansible is not installed${NC}"
    echo "Install with: pip install ansible"
    exit 1
fi

# Configure SSH key
echo -e "${YELLOW}Configuring SSH key...${NC}"

SSH_KEY="$HOME/.ssh/root.pem"

if [ ! -f "$SSH_KEY" ]; then
    echo -e "${RED}Error: SSH key not found at $SSH_KEY${NC}"
    exit 1
fi

# Verify key has correct permissions (600 or 400)
chmod 400 "$SSH_KEY" 2>/dev/null || true

echo -e "${GREEN}SSH key configured: $SSH_KEY${NC}"

# Get Jenkins EC2 public IP from Terraform output
echo -e "${YELLOW}Retrieving Jenkins EC2 IP from Terraform...${NC}"

# Change to terraform directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/terraform"
ANSIBLE_DIR="$(dirname "$SCRIPT_DIR")"

cd "$TERRAFORM_DIR"

JENKINS_IP=$(terraform output -raw jenkins_public_ip 2>/dev/null)

if [ -z "$JENKINS_IP" ]; then
    echo -e "${RED}Error: Could not retrieve Jenkins IP from Terraform${NC}"
    echo "Make sure you've run 'terraform apply' first"
    exit 1
fi

echo -e "${GREEN}Jenkins IP: $JENKINS_IP${NC}"

# Generate inventory.ini
echo -e "${YELLOW}Generating Ansible inventory...${NC}"

cat > "$ANSIBLE_DIR/inventory.ini" << EOF
[jenkins]
jenkins-server ansible_host=$JENKINS_IP ansible_user=ec2-user ansible_ssh_private_key_file=$SSH_KEY ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[jenkins:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

echo -e "${GREEN}Inventory generated at: $ANSIBLE_DIR/inventory.ini${NC}"

# Wait for EC2 to be ready (SSH accessible)
echo -e "${YELLOW}Waiting for EC2 instance to be ready...${NC}"
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if nc -zv -w 5 $JENKINS_IP 22 &> /dev/null; then
        echo -e "${GREEN}EC2 instance is ready!${NC}"
        sleep 10  # Give it a few more seconds
        break
    fi
    
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "Waiting for SSH... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 10
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo -e "${RED}Error: EC2 instance did not become ready in time${NC}"
    exit 1
fi

# Run Ansible playbook
echo -e "${YELLOW}Running Ansible playbook...${NC}"

cd "$ANSIBLE_DIR"

ansible-playbook -i inventory.ini playbooks/jenkins-setup.yml

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "Jenkins URL: http://$JENKINS_IP:8080"
echo -e "Check the output above for the initial admin password"