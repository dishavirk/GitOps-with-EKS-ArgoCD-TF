output "argocd_helm_release_status" {
  value = helm_release.argocd.status
}
output "argocd_url" {
  value = helm_release.argocd.values
}