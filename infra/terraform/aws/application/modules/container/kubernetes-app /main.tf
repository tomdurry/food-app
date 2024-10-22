resource "kubernetes_deployment" "go_app" {
  metadata {
    name = "go-app"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "go-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "go-app"
        }
      }
      spec {
        container {
          name  = "go-app"
          image = "your-dockerhub-username/go-app:latest"
          port {
            container_port = 8080
          }
          env {
            name  = "DB_HOST"
            value = "postgres-service"
          }
          env {
            name  = "DB_USER"
            value = "myuser"
          }
          env {
            name  = "DB_PASSWORD"
            value = "mypassword"
          }
          env {
            name  = "DB_NAME"
            value = "mydb"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }
      spec {
        container {
          name  = "postgres"
          image = "postgres:14"
          port {
            container_port = 5432
          }
          env {
            name  = "POSTGRES_USER"
            value = "myuser"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "mypassword"
          }
          env {
            name  = "POSTGRES_DB"
            value = "mydb"
          }
        }
      }
    }
  }
}
