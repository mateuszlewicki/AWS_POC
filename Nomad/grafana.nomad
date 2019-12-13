job "grafana" {
  datacenters = ["dc1"]
  task "graf" {
    driver = "docker"

    config {
      image = "grafana/grafana"
      port_map{ http = 3000 }
      labels {
        group = "monitor"
      }
      volumes = [
      "local/:/var/lib/pulgins"]
    }
    env {
       GF_SECURITY_ADMIN_PASSWORD= "admin",
       GF_PATHS_PLUGINS= "/local/",
       GF_SERVER_ROOT_URL= "%(protocol)s://%(domain)s/grafana/",
       GF_SESSION_COOKIE_SECURE= "false",
       GF_ALERTING_ENABLED= "false",
       GF_AUTH_ANONYMOUS_ENABLED= "true",
       GF_LOG_MODE= "console",
       GF_LOG_LEVEL= "DEBUG"

    }
    resources {
        network {
          port "http" {}
        }
      }

    artifact {
     source = "https://s3.amazonaws.com/mlewicki-mybucket-atos.net/sbueringer-grafana-consul-datasource-v0.1.5-1-g4226d7b.tar.gz"
      destination = "local/"
    }
    service {
      name = "grafana"
      tags = ["urlprefix-/grafana strip=/grafana redirect=303"]
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
