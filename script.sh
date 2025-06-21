#!/bin/bash

set -e

# Move to the terraform directory (assumes script is in project-root/scripts/)
cd "$(dirname "${BASH_SOURCE[0]}")/../terraform"

# Ensure Terraform state is initialized
terraform init -input=false

# Extract Terraform outputs
CLUSTER_NAME=$(terraform output -raw cluster_name)
REGION=$(terraform output -raw region)

# Install kubectl if not already installed
if ! command -v kubectl &> /dev/null; then
  echo "Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/kubectl
fi

# Show kubectl version
kubectl version --client

# Update kubeconfig with EKS cluster info
echo "Connecting to EKS cluster: $CLUSTER_NAME in region $REGION"
aws eks --region "$REGION" update-kubeconfig --name "$CLUSTER_NAME"

# Verify connection
echo "Testing kubectl access..."
kubectl get nodes
