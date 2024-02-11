variable "minikube_driver" {
  description = "The driver to use for the Minikube cluster"
  type        = string
  default     = "docker"
}

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

variable "cluster_addons" {
  description = "List of addons to enable"
  type        = list(string)
  default     = [
    "dashboard",
    "ingress",
    "metrics-server",
  ]
}

variable "cluster_cpus" {
  description = "Number of CPUs for each node"
  type        = number
  default     = 2
}

variable "cluster_disk_size" {
  description = "Disk size for each node"
  type        = string
  default     = "20g"
}

variable "cluster_memory" {
  description = "Memory for each node"
  type        = string
  default     = "2048"
}

variable "cluster_nodes" {
  description = "Number of nodes"
  type        = number
  default     = 2
}