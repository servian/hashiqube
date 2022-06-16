# https://traefik.io/blog/traefik-proxy-fully-integrates-with-hashicorp-nomad/

job "traefik-whoami" {
  datacenters = ["dc1"]

  type = "service"

  group "traefik-whoami" {
    count = 1

    network {
       port "http" {
         to = 8080
       }
    }

    service {
      name = "traefik-whoami"
      port = "http"
      provider = "nomad"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=Host(`whoami.nomad.localhost`)",
      ]
    }

    task "server" {
      env {
        WHOAMI_PORT_NUMBER = "${NOMAD_PORT_http}"
      }

      driver = "docker"

      config {
        image = "traefik/whoami"
        ports = ["http"]
      }
    }
  }
}