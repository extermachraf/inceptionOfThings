#!/bin/bash

# Create the k3d cluster
k3d cluster create --config ../conf/k3d-cluster.yaml

# Wait for the cluster to be ready
echo "Waiting for cluster to be ready..."
sleep 30

# Create namespaces
kubectl create namespace argocd
kubectl create namespace dev

# Install Argo CD
echo "Installing Argo CD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for Argo CD to be ready
echo "Waiting for Argo CD to be ready..."
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

# Change the Argo CD admin password to 'password'
# First, get the current admin password
ARGOCD_INITIAL_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Install Argo CD CLI
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd
sudo mv argocd /usr/local/bin/

# Wait for the Argo CD API server to be available
echo "Waiting for Argo CD API server..."
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

# Port-forward the Argo CD API server (in the background)
kubectl port-forward svc/argocd-server -n argocd 9090:443 &
PORT_FORWARD_PID=$!

# Wait for port-forward to establish
sleep 10

# Login to Argo CD
echo "Logging in to Argo CD..."
argocd login localhost:9090 --username admin --password $ARGOCD_INITIAL_PASSWORD --insecure

# Update the password (optional)
argocd account update-password --current-password $ARGOCD_INITIAL_PASSWORD --new-password password

# Stop the port-forwarding
kill $PORT_FORWARD_PID

echo "Argo CD has been successfully installed!"
echo "To access the Argo CD UI, follow these steps:"
echo "1. Run the following command to port-forward the Argo CD server:"
echo "   kubectl port-forward svc/argocd-server -n argocd 9090:443"
echo "2. Open your browser and navigate to: https://localhost:9090"
echo "3. Use the following credentials to log in:"
echo "   Username: admin"
echo "   Password: password"

# Create the Kubernetes Secret for pulling Docker images (if needed)
# kubectl create secret docker-registry regcred \
#   --namespace dev \
#   --docker-server=https://index.docker.io/v1/ \
#   --docker-username=username \
#   --docker-password=password \
#   --docker-email=email