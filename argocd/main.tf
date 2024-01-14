resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = var.argocd_namespace
  timeout    = "1200"
  values     = [templatefile("./manifests/argocd_install.yaml", {})]
  depends_on = [
    kubernetes_namespace.argocd
  ]
}

# resource "null_resource" "password" {
#   provisioner "local-exec" {
#     command     = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
#   }
# }

# resource "null_resource" "del-argo-pass" {
#   depends_on = [null_resource.password]
#   provisioner "local-exec" {
#     command = "kubectl -n argocd delete secret argocd-initial-admin-secret"
#   }
# }

# data "kubernetes_service" "argocd_server" {
#   metadata {
#     name      = "argocd-server"
#     namespace = var.argocd_namespace
#   }
# }
