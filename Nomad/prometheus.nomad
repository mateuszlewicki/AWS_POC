job "Prometheus" {
task "monitor" {
  driver = "docker"

  config {
    image = "prom/prometheus:latest"
    artifact {
      source = "s3::https://my-bucket-example.s3-eu-west-1.amazonaws.com/my_app.tar.gz"
      destination = "/etc/prometheus/prometheus.yml"
      }

     volumes = [
          "local/prometheus.yml:/etc/prometheus/prometheus.yml"
        ]
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
      path     = "/-/healthy"
      interval = "10s"
      timeout  = "2s"
      }
    }
}


}

