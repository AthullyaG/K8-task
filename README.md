# Cloud DevOps Engineer Assessment Task

## Overview

This project contains the solution for the Cloud & DevOps Engineer Assessment Task. The goal is to deploy a simple static web application on AWS EKS with Prometheus for monitoring and logging. The solution uses Terraform for infrastructure provisioning, Docker for containerization, and Kubernetes for deployment.

## Project Structure

- `index.html`: A simple static HTML page that serves as the content for the web application.
- `Dockerfile`: The Dockerfile used to containerize the web application.
- `main.tf`: Terraform configuration to provision AWS resources (VPC, subnets, and EKS cluster).
- `prometheus-deployment.yaml`: Kubernetes configuration to deploy Prometheus for monitoring.
- `web-app-deployment.yaml`: Kubernetes deployment configuration for the web application.
- `web-app-service.yaml`: Kubernetes service configuration to expose the web application.
- `README.md`: This file, which provides instructions for deploying the solution.

## Prerequisites

Before getting started, ensure the following tools are installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Docker](https://www.docker.com/get-started)
- [Helm (optional for Prometheus setup)](https://helm.sh/docs/intro/install/)

## Setup Instructions

### 1. Configure AWS CLI

Set up AWS CLI with your credentials by running the following command:

```bash
aws configure
```

Enter AWS Access Key, Secret Key, region, and output format when prompted.

### 2. Deploy Infrastructure with Terraform

Terraform is used to create the necessary AWS resources such as VPC, subnets, and EKS cluster.

#### Initialize Terraform

Navigate to the project directory and run the following command to initialize Terraform:

```bash
terraform init
```

#### Apply the Configuration

To create the infrastructure, apply the Terraform configuration:

```bash
terraform apply
```

Terraform will prompt to confirm the creation of resources. Type `yes` to proceed.

### 3. Set Up kubectl for EKS

Once the EKS cluster is created, configure `kubectl` to interact with the newly created cluster:

```bash
aws eks --region us-west-2 update-kubeconfig --name web-app-cluster
```

This will configure `kubectl` to interact with the `web-app-cluster` on AWS EKS.

### 4. Build and Push Docker Image

The web application needs to be containerized using Docker.

#### Build the Docker Image

Navigate to the directory with the `Dockerfile` and build the Docker image:

```bash
docker build -t web-app .
```

#### Push the Docker Image to Docker Hub (or AWS ECR)

If using Docker Hub, tag and push the image:

```bash
docker tag web-app <dockerhub_username>/web-app:latest
docker push <dockerhub_username>/web-app:latest
```

If using AWS ECR, create a repository and push the Docker image there.

### 5. Deploy Web Application on Kubernetes

Now, the web application can be deployed on Kubernetes.

#### Web App Deployment

Create the Kubernetes deployment for the web app using the `web-app-deployment.yaml` file:

```bash
kubectl apply -f web-app-deployment.yaml
```

#### Web App Service

Create the Kubernetes service to expose the web app externally using the `web-app-service.yaml` file:

```bash
kubectl apply -f web-app-service.yaml
```

### 6. Set Up Prometheus for Monitoring

Prometheus will be deployed for monitoring the web application. Apply the `prometheus-deployment.yaml` file:

```bash
kubectl apply -f prometheus-deployment.yaml
```

Prometheus will be exposed via a LoadBalancer service on port 9090. To check the Prometheus service, run:

```bash
kubectl get svc prometheus
```

Visit Prometheus at `http://<Prometheus_LoadBalancer_IP>:9090` to view metrics and set up monitoring.

### 7. Accessing the Web Application and Monitoring

- **Web Application**: Access the web application via the LoadBalancer IP of the `web-app-service`.
- **Prometheus**: Access Prometheus at the LoadBalancer IP of the `prometheus` service, typically at `http://<Prometheus_LoadBalancer_IP>:9090`.

## File Breakdown

### `index.html`

A simple static HTML page displayed by the web application. It contains a welcome message and a short description of the consultancy.

### `Dockerfile`

The Dockerfile used to containerize the web application. It copies the `index.html` to the Nginx container and exposes port 80:

```Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
```

### `main.tf`

Terraform configuration to provision AWS resources:
- VPC
- Subnets
- EKS Cluster

### `prometheus-deployment.yaml`

Kubernetes deployment and service configuration for Prometheus:
- Deployment: Deploys Prometheus container.
- Service: Exposes Prometheus via LoadBalancer on port 9090.

### `web-app-deployment.yaml`

Kubernetes deployment configuration for the web application:
- Deploys two replicas of the web app container.

### `web-app-service.yaml`

Kubernetes service configuration to expose the web app externally using a LoadBalancer.

## Conclusion

This task demonstrates a simple deployment of a static web application on AWS EKS, with Prometheus for monitoring. The project utilizes Terraform for infrastructure provisioning, Docker for containerization, and Kubernetes for deployment, all while ensuring that the system is fully monitored.

## Next Steps

- Scale the application using Kubernetes Horizontal Pod Autoscaler.
- Implement advanced logging solutions (e.g., ELK Stack, AWS CloudWatch).
- Optimize both the application and infrastructure based on monitoring insights.
