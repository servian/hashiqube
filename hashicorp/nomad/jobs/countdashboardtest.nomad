// https://www.nomadproject.io/guides/integrations/consul-connect/index.html
job "countdashtest" {
  datacenters = ["dc1"]

  group "apitest" {
    network {
      mode = "bridge"

      port "httpapitest" {
        static = 9011
        to     = 9011
      }
    }

    service {
      name = "count-api-test"
      port = "9011"
    }

    task "webtest" {
      driver = "docker"

      env {
        PORT = "9011"
      }

      config {
        image = "hashicorpnomad/counter-api:v1"
      }
    }
  }

  group "dashboardtest" {
    network {
      mode = "bridge"

      port "httpdashboardtest" {
        static = 9022
        to     = 9022
      }
    }

    service {
      name = "count-dashboardtest"
      port = "9022"
      # tags = ["urlprefix-10.9.99.10:9022/countdashtest strip=/countdashtest"]
    }

    task "dashboardtest" {
      driver = "docker"

      env {
        COUNTING_SERVICE_URL = "http://10.9.99.10:9011"
        PORT = "9022"
      }

      config {
        image = "hashicorpnomad/counter-dashboard:v1"
      }
    }
  }

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "20s"
  }

}
