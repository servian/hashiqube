project = "nomad-trex-nodejs"

app "nomad-trex-nodejs" {
  labels = {
    "service" = "nomad-trex-nodejs",
    "env"     = "dev"
  }

  build {
    # TODO: Waypoint application has trouble connecting to Waypoint server
    # https://www.waypointproject.io/docs/entrypoint/disable#disable-the-waypoint-entrypoint
    # disable_entrypoint = true
    use "docker" {}
    # docker registry in docker/docker.sh
    registry {
      use "docker" {
        image = "10.9.99.10:5002/trex-nodejs" # See docker registry in docker/docker.sh
        tag   = "0.0.2"
        local = true
        encoded_auth = filebase64("/etc/docker/auth.json") # https://www.waypointproject.io/docs/lifecycle/build#private-registries
      }
    }
  }

  deploy {
    use "nomad" {
      datacenter = "dc1"
    }
  }

}
