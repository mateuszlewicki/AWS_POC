job "ApacheOFbiz" {
task "ERP" {
  driver = "docker"

  config {
    image = "opensourceknight/ofbiz"
    labels {
      group = "Ofbiz"
    }
  }
}


}
