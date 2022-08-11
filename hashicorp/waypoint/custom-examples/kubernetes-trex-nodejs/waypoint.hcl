project = "kubernetes-trex-nodejs"

app "kubernetes-trex-nodejs" {
  labels = {
    "service" = "kubernetes-trex-nodejs",
    "env"     = "dev"
  }

  build {
    use "docker" {}
    # registry via minikube addon in minikube/minikube.sh
    registry {
      use "docker" {
        image = "10.9.99.10:5001/trex-nodejs" # See minikube docker registry
        tag   = "0.0.2"
        local = false
        # encoded_auth = filebase64("/etc/docker/auth.json") # https://www.waypointproject.io/docs/lifecycle/build#private-registries
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path   = "/"
      replicas     = 1
      service_port = 6001
      probe {
        initial_delay = 4
      }
      labels = {
        env = "local"
      }
      annotations = {
        demo = "yes"
      }
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port          = 6001
    }
  }
}
