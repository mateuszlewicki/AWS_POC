job "webapp"{
  
  datacenters = ["dc1"]

task "webservice" {
  driver = "java"

  config {
    jar_path    = "local/demo-0.0.1-SNAPSHOT.jar"
    args = ["--server.servlet.context-path=/spring"]
  }
  artifact {
    source = "https://s3.amazonaws.com/mlewicki-mybucket-atos.net/demo-0.0.1-SNAPSHOT.jar"}

 resources {
    network {
      port "http" {
      static = 8080}
    }
  }


service {
    name = "Spring"
    tags = ["urlprefix-/spring redirect=303"]
    port = "http"
    check {
      name     = "alive"
      type     = "http"
      path     = "/spring/actuator/health"
      interval = "10s"
      timeout  = "2s"
      }
    }


}
}
