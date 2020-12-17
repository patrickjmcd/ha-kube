resource "helm_release" "helm-metallb" {
  name  = "metallb"
  repository = "https://charts.helm.sh/stable"
  chart = "metallb"
  namespace = "kube-system"

  set {
    name  = "configInline.address-pools[0].name"
    value = "default"
  }

  set {
      name = "configInline.address-pools[0].protocol"
      value="layer2"
  }

  set {
      name = "configInline.address-pools[0].addresses[0]"
      value = "192.168.8.200-192.168.8.210"
  }

}

resource "helm_release" "helm-ingress_nginx" {
    depends_on = [helm_release.helm-metallb]
  name  = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx/"
  chart = "ingress-nginx"
  namespace = "kube-system"

  set {
      name = "defaultBackend.enabled"
      value = "false"
  }
}



resource "helm_release" "helm-cert_manager" {
  depends_on = [helm_release.helm-ingress_nginx]
  name  = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart = "cert-manager"
  namespace = "cert-manager"

  set {
      name = "installCRDs"
      value = "true"
  }
}

data "kubectl_file_documents" "get_certmanager_resources" {
    content = file("../../roles/k3s_deploy/files/cert-manager/cf_issuers.yml")
}

resource "kubectl_manifest" "apply_certmanager_resources" {
    depends_on = [helm_release.helm-cert_manager]
    count     = length(data.kubectl_file_documents.get_certmanager_resources.documents)
    yaml_body = element(data.kubectl_file_documents.get_certmanager_resources.documents, count.index)
}

resource "helm_release" "helm-docker_registry" {
    depends_on = [kubectl_manifest.apply_certmanager_resources]
    name  = "registry"
    repository = "https://charts.helm.sh/stable"
    chart = "docker-registry"
    namespace = "kube-system"

    values = [
        file("../../roles/k3s_deploy/files/values/registry.values.yml")
    ]

}

resource "helm_release" "helm-oauth2_proxy" {
    depends_on = [helm_release.helm-docker_registry]
    name  = "oauth2-proxy-nginx"
    repository = "https://charts.helm.sh/stable"
    chart = "oauth2-proxy"
    namespace = "kube-system"
    values = [
            file("../../roles/k3s_deploy/files/values/oauth2-proxy.values.yml")
    ]
}

resource "helm_release" "helm-default" {
    depends_on = [kubectl_manifest.apply_certmanager_resources, helm_release.helm-docker_registry]
    name  = "default"
    chart = "../../roles/k3s_deploy/files/charts/default"
    namespace = "default"
    timeout = 600
    dependency_update = true
}

resource "helm_release" "helm-fantasyfootball" {
    depends_on = [kubectl_manifest.apply_certmanager_resources, helm_release.helm-docker_registry, helm_release.helm-default]
    name  = "fantasyfootball"
    chart = "../../roles/k3s_deploy/files/charts/fantasyfootball"
    namespace = "fantasyfootball"
    timeout = 600
    dependency_update = true
}

resource "helm_release" "helm-monitoring" {
    depends_on = [kubectl_manifest.apply_certmanager_resources]
    name  = "monitoring"
    chart = "../../roles/k3s_deploy/files/charts/monitoring"
    namespace = "monitoring"
    wait = false
    timeout = 600
    dependency_update = true
}

resource "helm_release" "helm-media" {
    depends_on = [kubectl_manifest.apply_certmanager_resources, helm_release.helm-oauth2_proxy]
    name  = "media"
    chart = "../../roles/k3s_deploy/files/charts/media"
    namespace = "media"
    timeout = 600
    dependency_update = true
}

data "kubectl_filename_list" "list_cronjobs" {
    depends_on = [kubectl_manifest.apply_certmanager_resources, helm_release.helm-docker_registry]
    pattern = "../../roles/k3s_deploy/files/cronjobs/*.yml"
}

// resource "kubectl_manifest" "apply_cronjobs" {
//     count     = length(data.kubectl_filename_list.list_cronjobs.matches)
//     yaml_body = file(element(data.kubectl_filename_list.list_cronjobs.matches, count.index))
// }


data "kubectl_file_documents" "list_telegraf_config" {
    content = file("../../roles/k3s_deploy/files/telegraf/telegraf.yaml")
}

resource "kubectl_manifest" "apply_telegraf_config" {
    count     = length(data.kubectl_file_documents.list_telegraf_config.documents)
    yaml_body = element(data.kubectl_file_documents.list_telegraf_config.documents, count.index)
}

data "kubectl_file_documents" "list_telegraf_deployment" {
    content = file("../../roles/k3s_deploy/files/telegraf/telegraf.deployment.yaml")
}

resource "kubectl_manifest" "telegraf_deployment" {
    count     = length(data.kubectl_file_documents.list_telegraf_deployment.documents)
    yaml_body = element(data.kubectl_file_documents.list_telegraf_deployment.documents, count.index)
}

data "kubectl_file_documents" "list_telegraf_daemonset" {
    content = file("../../roles/k3s_deploy/files/telegraf/telegraf.daemonset.yaml")
}

resource "kubectl_manifest" "telegraf_daemonset" {
    count     = length(data.kubectl_file_documents.list_telegraf_daemonset.documents)
    yaml_body = element(data.kubectl_file_documents.list_telegraf_daemonset.documents, count.index)
}

