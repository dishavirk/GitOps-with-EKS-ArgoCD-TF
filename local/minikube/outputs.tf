output "cluster_client_certificate" {
  value = minikube_cluster.cluster.client_certificate
  sensitive = true
}

output "cluster_client_key" {
  value = minikube_cluster.cluster.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value = minikube_cluster.cluster.cluster_ca_certificate
  sensitive = true
}

output "cluster_host" {
  value = minikube_cluster.cluster.host
}

output "cluster_id" {
  value = minikube_cluster.cluster.id
}
