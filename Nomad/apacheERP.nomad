job "ApacheOFbiz" {
task "ERP" {
  driver = "docker"

  config {
    image = "opensourceknight/ofbiz"
    portmap{ http = 80 }
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




