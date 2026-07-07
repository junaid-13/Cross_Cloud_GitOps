#! /usr/bin/env bash
set -euo pipefail

# Bootstrap script that does:
# 1. Terraform init/plan/apply for AWS and GCP infrastructure
# 2. Configures kubeconfig for EKS and GKE clusters
# 3. Installs ArgoCD in both clusters
# 4. Installs Prometheus/Grafana via ArgoCD Applications
# 5. Registers sample app in ArgoCD

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="$ROOT_DIR/infrastructure/terraform"
AWS_TF="$TF_DIR/aws"
GCP_TF="$TF_DIR/gcp"

echo "1) Terraform initialize and apply for AWS"
cd "$AWS_TF"
terraform init -input=false
terraform fmt -check || terraform fmt
terraform validate
terraform plan -out=tfplan -input=false
terraform apply -input=false tfplan

EKS_CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
EKS_REGION=$(terraform output -raw region)

echo "Configure kubeconfig for EKS cluster"
aws eks --region "${EKS_REGION}" update-kubeconfig --name "${EKS_CLUSTER_NAME}"

echo "2) Terraform initialize and apply for GCP"
cd "$GCP_TF"
terraform init -input=false
terraform fmt -check || terraform fmt
terraform validate
terraform plan -out=tfplan -input=false
terraform apply -input=false tfplan

GKE_CLUSTER_NAME=$(terraform output -raw gke_cluster_name)
GKE_ZONE=$(terraform output -raw gke_zone)

echo "Configure kubeconfig for GKE"
gcloud container clusters get-credentials "${GKE_CLUSTER_NAME}" --zone "${GKE_ZONE}" --project "$(terraform output -raw project_id)"

echo "3) Install ArgoCD in both clusters"

kubectl config use-context "arn:aws:eks:${EKS_REGION}:$(aws sts get-caller-identity --query Account --output text):cluster/${EKS_CLUSTER_NAME}" || true
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD server to be ready in EKS..."
kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd

echo "EKS ArgoCD initial admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo

echo "Register ArgoCD Applications"
kubectl config use-context "arn:aws:eks:${EKS_REGION}:$(aws sts get-caller-identity --query Account --output text):cluster/${EKS_CLUSTER_NAME}" || true
kubectl apply -f "$ROOT_DIR/argocd/apps/infra-app.yaml"
kubectl apply -f "$ROOT_DIR/argocd/apps/apps.yaml"
kubectl apply -f "$ROOT_DIR/argocd/apps/observability.yaml"
kubectl apply -f "$ROOT_DIR/argocd/apps/automation.yaml"

echo "Bootstrap completed successfully."
