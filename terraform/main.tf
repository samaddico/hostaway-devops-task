# Internal namespaces
resource "kubernetes_namespace" "internal" {
  for_each = toset(var.environments)
  metadata {
    name = "internal-${each.key}"
    labels = {
      type = "internal"
      env  = each.key
    }
  }
}

# External namespaces
resource "kubernetes_namespace" "external" {
  for_each = toset(var.environments)
  metadata {
    name = "external-${each.key}"
    labels = {
      type = "external"
      env  = each.key
    }
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.3"

  set {
    name  = "server.service.type"
    value = "NodePort"
  }
}
