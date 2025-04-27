#!/bin/bash

# Replace with your GitHub repository URL
GITHUB_REPO_URL="https://github.com/extermachraf/dep.git"

# Replace the placeholder in the application.yaml file
sed -i "s|https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git|$GITHUB_REPO_URL|g" ../conf/application.yaml

# Apply the Argo CD Application configuration
kubectl apply -f ../conf/application.yaml
kubectl port-forward svc/playground -n dev 8888:8888 &
echo "Application available at http://localhost:8888/"

# Port-forward Argo CD server to access the UI
echo "Starting port-forward for Argo CD UI. Access it at https://localhost:9090"
echo "Username: admin"
echo "Password: password"
kubectl port-forward svc/argocd-server -n argocd 9090:443