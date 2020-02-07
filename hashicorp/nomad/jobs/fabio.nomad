# https://learn.hashicorp.com/nomad/load-balancing/fabio
job "fabio" {
  datacenters = ["dc1"]
  type = "system"

  group "fabio" {
    task "fabio" {
      driver = "docker"
      config {
        image = "fabiolb/fabio"
        network_mode = "host"
        volumes = [
          # Use absolute paths to mount arbitrary paths on the host
          "/vagrant/hashicorp/nomad/jobs:/etc/fabio"
        ]
      }

      env {
        NOMAD_IP_elb = "0.0.0.0"
        NOMAD_IP_admin = "0.0.0.0"
        NOMAD_IP_tcp = "0.0.0.0"
        NOMAD_ADDR_ui = "0.0.0.0:9998"
        NOMAD_ADDR_lb = "0.0.0.0:9999"
      }

      resources {
        cpu    = 200
        memory = 128
        network {
          mbits = 10
          port "lb" {
            static = 9999
          }
          port "ui" {
            static = 9998
          }
        }
      }

      service {
        port = "ui"
        name = "fabio"
        tags = ["urlprefix-fabio.service.consul/", "urlprefix-/", "urlprefix-/routes"]
        check {
           type     = "http"
           path     = "/health"
           port     = "ui"
           interval = "10s"
           timeout  = "2s"
         }
      }

    }
  }
}
