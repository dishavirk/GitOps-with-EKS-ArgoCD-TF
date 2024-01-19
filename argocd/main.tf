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

