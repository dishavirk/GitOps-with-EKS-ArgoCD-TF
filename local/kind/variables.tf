# Name of the EKS cluster
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "v1.29.1"
}

variable "kind" {
  description = "Kind of the cluster"
  type        = string
  default     = "Cluster"
}

variable "api_version" {
  description = "API version"
  type        = string
  default     = "kind.sigs.k8s.io/v1alpha4"
}
