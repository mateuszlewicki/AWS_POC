job "PostgreSQL" {
  datacenters = ["dc1"]
task "DB" {
  driver = "docker"

  env{
    POSTGRES_USER = "ofbiz"
    POSTGRES_PASSWORD = "ofbiz"
    POSTGRES_DB = "ofbiz"
  }
  config {
    image = "postgres"
    port_map{ tcp = 5432  }
    labels {
      group = "Ofbiz"
    }

  }

  service {
    name = "postgress"
    tags = ["database"]
    port = "tcp"
    }
  resources {
            network {
              port "tcp" {}
            }
        }
}


}
