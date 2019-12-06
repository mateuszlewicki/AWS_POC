job "ApacheOFbiz" {
  datacenters = ["dc1"]
task "ERP" {
  driver = "docker"


env{
    DB = "postgres"
  }
  config {
    image = "opensourceknight/ofbiz"
    port_map{ http = 80 }
    labels {
      group = "Ofbiz"
    }
  }
 resources {
    network {
      port "http" {}
    }
  }

  service {
    name = "Ofbiz"
    tags = ["urlprefix-/biz"]
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




