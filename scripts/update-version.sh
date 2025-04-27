#!/bin/bash

# This script updates the application version from v1 to v2

# Check if you're in the git repository directory
if [ ! -d ".git" ]; then
  echo "Error: Not in a git repository. Please run this script from your repository root."
  exit 1
fi

# Update the deployment.yaml file
echo "Updating deployment.yaml from v1 to v2..."
sed -i 's/ael-kouc42\/playground:v3/ael-kouc42\/playground:v4/g' deployment.yaml
# Commit and push the changes
echo "Committing and pushing changes..."
git add deployment.yaml
git commit -m "Update application version to v2"
git push

echo "Application update complete!"
echo "Argo CD will automatically detect the changes and update the deployment."
echo "You can verify the update by checking the Argo CD UI or running:"
echo "kubectl get pods -n dev"
echo "curl http://localhost:8888/"