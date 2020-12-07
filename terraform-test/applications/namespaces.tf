
resource "kubernetes_namespace" "namespace-cert-manager" {
  metadata {
    annotations = {
      name = "cert-manager"
      createdby = "terraform"
    }

    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "namespace-cron" {
  metadata {
    annotations = {
      name = "cron"
      createdby = "terraform"
    }

    name = "cron"
  }
}

resource "kubernetes_namespace" "namespace-fantasyfootball" {
  metadata {
    annotations = {
      name = "fantasyfootball"
      createdby = "terraform"
    }

    name = "fantasyfootball"
  }
}

resource "kubernetes_namespace" "namespace-media" {
  metadata {
    annotations = {
      name = "media"
      createdby = "terraform"
    }

    name = "media"
  }
}

resource "kubernetes_namespace" "namespace-monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
      createdby = "terraform"
    }

    name = "monitoring"
  }
}
