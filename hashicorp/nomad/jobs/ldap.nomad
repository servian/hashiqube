job "ldap" {
  datacenters = ["dc1"]
  group "ldap" {

    task "ldap" {
      driver = "docker"

      config {
        image = "rroemhild/test-openldap"
        network_mode = "bridge"
      }

      resources {
        cpu    = 500
        memory = 512
        network {
          mbits = 10
        }
      }

      service {
        name = "ldap"
        port = 389
        address_mode = "driver"
        check {
          name     = "host-ldap-check"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
          port     = 389

          address_mode = "driver"
        }
      }
    }
  }
}
