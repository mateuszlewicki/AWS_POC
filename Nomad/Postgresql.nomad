job "PostgreSQL" {
task "DB" {
  driver = "docker"

  config {
    image = "postgres"
    labels {
      group = "Ofbiz"
    }
  }
}


}
