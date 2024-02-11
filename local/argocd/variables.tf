variable "argocd_namespace" {
  description = "The Kubernetes namespace in which to install ArgoCD."
  type        = string
  default     = "argocd"
}
