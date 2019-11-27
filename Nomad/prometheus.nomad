job "Prometheus" {
task "monitor" {
  driver = "docker"

  config {
    image = "prom/prometheus"
    labels {
      group = "monitor"
    }
  }
}


}

