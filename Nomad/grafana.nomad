job "grafana" {
task "graf" {
  driver = "docker"

  config {
    image = "grafana/grafana"
    labels {
      group = "monitor"
    }
  }
}


}

