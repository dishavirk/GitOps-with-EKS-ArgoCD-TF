# Celsius to Fahrenheit Conversion Web App - GitOps Implementation

## Overview

This repository demonstrates an advanced GitOps workflow using GitHub Actions, ArgoCD, Terraform, and AWS EKS for a Python Flask application that converts temperatures from Celsius to Fahrenheit.

## Repository Structure

- `.github/workflows`: Contains GitHub Actions workflows, automating CI/CD pipelines.
- `argocd`: Includes ArgoCD manifests for continuous deployment and application configuration.
- `eks_cluster`: Terraform files for AWS EKS cluster setup, defining infrastructure as code.
- `k8s_manifest`: Kubernetes manifests for application deployment and management.
- `tf_state_management`: Manages Terraform state, essential for infrastructure tracking and versioning.
- `Dockerfile`: Container configuration for the Flask app.
- `argocd_manifest.yaml`: ArgoCD application manifest for Kubernetes deployment.
- `celsius-to-fahrenheit.py`: Python application script.
- `requirements.txt`: Python dependencies.
- `local/kind`: Local Kubernetes cluster setup for development and testing.

## GitHub Actions Workflows

The workflows in `.github/workflows` automate the continuous integration and deployment processes, including testing, building, and deploying the application. These workflows ensure that each change in the repository is automatically and reliably reflected in the deployed application.

## Terraform Infrastructure as Code

The `eks_cluster` and `tf_state_management` directories contain Terraform files for defining and managing the AWS EKS cluster infrastructure. These files allow for reproducible infrastructure setup and easy management of cloud resources.

## ArgoCD for Continuous Deployment

ArgoCD manifests in the `argocd` directory facilitate the GitOps approach for continuous deployment. They link the Kubernetes resources with the repository, ensuring that changes in the repository are automatically deployed to the Kubernetes cluster.

## Local Kubernetes Cluster Setup

The `local/kind` directory contains a local Kubernetes cluster setup using KinD (Kubernetes in Docker) for development and testing purposes. This setup allows for testing the application locally before deploying it to a production environment.

## Local Setup and Running

### Create and Activate a Python Virtual Environment

```bash
python -m venv venv
source venv/bin/activate
```

### Install Dependencies

```bash
pip install -U pip
pip install -r requirements.txt
```

### Start the Flask Server

```bash
python main.py
```

The app will be running on http://127.0.0.1:8080/

## Important Notes

This application is for development and testing purposes. Do not use the development server in a production environment.
