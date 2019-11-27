job "Prometheus" {
task "monitor" {
  driver = "docker"

  config {
    image = "prom/prometheus"
    portmap{ http = 9090 }
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
    name = "prometheus"
    tags = ["urlprefix-/prometheus"]
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

