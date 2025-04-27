#!/bin/bash
# filepath: /home/achraf/iotpart3/scripts/cleanup.sh

echo "===== Starting complete cleanup ====="

# Kill any port-forwarding or background processes
echo "Killing port-forward processes..."
pkill -f "kubectl port-forward" || true
sleep 2

# Check for processes using critical ports and kill them
for port in 8080 8888 9090 30888; do
  pid=$(sudo lsof -ti:$port)
  if [ ! -z "$pid" ]; then
    echo "Killing process on port $port (PID: $pid)..."
    sudo kill -9 $pid
  fi
done

# Delete the k3d cluster
echo "Deleting k3d cluster..."
k3d cluster delete argocd-cluster || true
sleep 2

# Clean up argocd CLI config
echo "Cleaning Argo CD configuration..."
rm -rf ~/.config/argocd || true

# Reset kubectl context
echo "Resetting kubectl context..."
kubectl config use-context $(kubectl config get-contexts -o name | grep -v "k3d-argocd" | head -1) || true


# Final verification
echo "Verifying cleanup..."
echo "Checking for k3d clusters:"
k3d cluster list
echo "Checking for running pods:"
kubectl get pods -A || true
echo "Checking critical ports:"
sudo lsof -i:8080,8888,9090,30888 || true

echo "===== Cleanup complete! ====="
echo "You can now run your setup scripts to recreate everything."
echo "./cluster-setup.sh"
echo "./setup-argocd-app.sh"