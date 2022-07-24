project = "nomad-trex-nodejs"

app "nomad-trex-nodejs" {
  labels = {
    "service" = "nomad-trex-nodejs",
    "env"     = "dev"
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "trex-nodejs" # See docker registry in docker/docker.sh
        tag   = "0.0.2"
        local = true
        #encoded_auth = filebase64("/etc/docker/auth.json") # https://www.waypointproject.io/docs/lifecycle/build#private-registries
      }
    }
  }

  deploy {
    use "nomad" {
      datacenter = "dc1"
    }
  }

}
