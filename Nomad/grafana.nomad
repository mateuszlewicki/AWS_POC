job "grafana" {
  datacenters = ["dc1"]
  task "graf" {
    driver = "docker"

    config {
      image = "grafana/grafana"
      portmap{ http = 3000 }
      labels {
        group = "monitor"
      }
    }
    resources {
        network {
          port "http" {}
        }
      }

    service {
      name = "grafana"
      tags = ["urlprefix-/grafana"]
      port = "http"
      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
        }
      }
}


}

