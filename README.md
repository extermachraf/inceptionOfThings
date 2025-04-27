# Inception-of-Things (IoT) - Part 3: K3d and Argo CD

This repository contains the implementation for Part 3 of the Inception-of-Things project, focusing on Kubernetes deployment with K3d and Argo CD.

## Overview

Part 3 implements a GitOps workflow using K3d (a lightweight Kubernetes distribution running in Docker) and Argo CD (a declarative continuous delivery tool for Kubernetes). The setup enables automatic deployment of applications from a GitHub repository, demonstrating the GitOps approach to application deployment and management.

## Architecture

The implementation includes:

- **K3d**: Lightweight Kubernetes cluster running in Docker containers
- **Argo CD**: GitOps continuous delivery tool for Kubernetes
- **Namespace Structure**:
  - `argocd`: Contains all Argo CD components
  - `dev`: Contains the application deployed by Argo CD
- **GitHub Integration**: Automatic syncing with a repository containing Kubernetes manifests
- **Docker Hub Integration**: Application images pulled from Docker Hub

## Directory Structure

```
./
├── conf/
│   ├── application.yaml     # Argo CD application definition
│   ├── deployment.yaml      # Kubernetes deployment manifest
│   └── k3d-cluster.yaml     # K3d cluster configuration
└── scripts/
    ├── clean.sh             # Cleanup script for resetting the environment
    ├── cluster-setup.sh     # Script to create and configure the K3d cluster and Argo CD
    ├── install-script.sh    # Script to install prerequisites (Docker, kubectl, K3d)
    ├── setup-argocd-app.sh  # Script to set up the Argo CD application
    └── update-version.sh    # Script to update the application version
```

## Prerequisites

- Linux-based operating system
- Internet connection
- Sufficient disk space (~2GB) and memory (~2GB)
- Permissions to run Docker and install software

## Setup Instructions

### 1. Install Required Software

Run the installation script to set up all prerequisites:

```bash
sudo ./scripts/install-script.sh
```

This installs:

- Docker
- kubectl
- K3d
- Helm

### 2. Create the K3d Cluster and Install Argo CD

```bash
./scripts/cluster-setup.sh
```

This script:

- Creates a K3d cluster with the configuration in `conf/k3d-cluster.yaml`
- Creates `argocd` and `dev` namespaces
- Installs Argo CD in the `argocd` namespace
- Configures Argo CD with admin credentials

### 3. Deploy the Application using Argo CD

```bash
./scripts/setup-argocd-app.sh
```

This script:

- Configures Argo CD to monitor the GitHub repository
- Applies the application definition to deploy the application in the `dev` namespace
- Sets up port forwarding to access the application and Argo CD UI

### 4. Access the Applications

- Argo CD UI: https://localhost:9090 (Username: admin, Password: password)
- Deployed application: http://localhost:8888

### 5. Updating the Application Version

To demonstrate the GitOps workflow, you can update the application version:

```bash
# Navigate to your GitHub repository clone first
cd /path/to/your/repo
./scripts/update-version.sh
```

This updates the image version in the deployment manifest, commits and pushes the change to GitHub.
Argo CD automatically detects the change and updates the deployment.

### 6. Cleanup

To clean up the environment and remove all resources:

```bash
./scripts/clean.sh
```

## GitOps Workflow

This setup demonstrates the GitOps principles:

1. **Declarative Configuration**: All application configurations are defined in Git
2. **Version Control**: Changes are tracked through Git commits
3. **Automated Deployment**: Argo CD automatically applies changes from Git
4. **Drift Detection**: Argo CD ensures the cluster state matches the declared state in Git

## Troubleshooting

- **Image Pull Errors**: If you encounter image pull issues, uncomment and configure the Docker registry secret in `cluster-setup.sh`
- **Port Conflicts**: Ensure ports 8888, 9090, and 8080 are available
- **Empty Responses**: Try direct port-forwarding to check if the application is running properly
- **Connection Issues**: Use `kubectl describe pod` to check for container status and events
