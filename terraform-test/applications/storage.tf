

data "kubectl_file_documents" "manifests_storage_config" {
    content = file("../../roles/k3s_deploy/files/storage/config.yaml")
}

resource "kubectl_manifest" "apply_storage_config" {
    depends_on  = [kubernetes_namespace.namespace-media, kubernetes_namespace.namespace-monitoring] 
    count       = length(data.kubectl_file_documents.manifests_storage_config.documents)
    yaml_body   = element(data.kubectl_file_documents.manifests_storage_config.documents, count.index)
}

data "kubectl_file_documents" "manifests_storage_data" {
    content = file("../../roles/k3s_deploy/files/storage/data.yaml")
}

resource "kubectl_manifest" "apply_storage_data" {
    depends_on  = [kubernetes_namespace.namespace-fantasyfootball, kubernetes_namespace.namespace-monitoring] 
    count     = length(data.kubectl_file_documents.manifests_storage_data.documents)
    yaml_body = element(data.kubectl_file_documents.manifests_storage_data.documents, count.index)
}

data "kubectl_file_documents" "manifests_storage_downloads" {
    content = file("../../roles/k3s_deploy/files/storage/downloads.yaml")
}

resource "kubectl_manifest" "apply_storage_downloads" {
    depends_on  = [kubernetes_namespace.namespace-media] 
    count     = length(data.kubectl_file_documents.manifests_storage_downloads.documents)
    yaml_body = element(data.kubectl_file_documents.manifests_storage_downloads.documents, count.index)
}

data "kubectl_file_documents" "manifests_storage_movies" {
    content = file("../../roles/k3s_deploy/files/storage/movies.yaml")
}

resource "kubectl_manifest" "apply_storage_movies" {
    depends_on  = [kubernetes_namespace.namespace-media] 
    count     = length(data.kubectl_file_documents.manifests_storage_movies.documents)
    yaml_body = element(data.kubectl_file_documents.manifests_storage_movies.documents, count.index)
}

data "kubectl_file_documents" "manifests_storage_tv" {
    content = file("../../roles/k3s_deploy/files/storage/tv.yaml")
}

resource "kubectl_manifest" "apply_storage_tv" {
    depends_on  = [kubernetes_namespace.namespace-media] 
    count     = length(data.kubectl_file_documents.manifests_storage_tv.documents)
    yaml_body = element(data.kubectl_file_documents.manifests_storage_tv.documents, count.index)
}


data "kubectl_file_documents" "manifests_storage_video" {
    content = file("../../roles/k3s_deploy/files/storage/video.yaml")
}

resource "kubectl_manifest" "apply_storage_video" {
    depends_on  = [kubernetes_namespace.namespace-media] 
    count     = length(data.kubectl_file_documents.manifests_storage_video.documents)
    yaml_body = element(data.kubectl_file_documents.manifests_storage_video.documents, count.index)
}

data "kubectl_file_documents" "manifests_storage_music" {
    content = file("../../roles/k3s_deploy/files/storage/music.yaml")
}

resource "kubectl_manifest" "apply_storage_music" {
    depends_on  = [kubernetes_namespace.namespace-media] 
    count     = length(data.kubectl_file_documents.manifests_storage_music.documents)
    yaml_body = element(data.kubectl_file_documents.manifests_storage_music.documents, count.index)
}