job "Website" {

    datacenters = ["dc1"]
 

group "up&run"{

#   volume "website" {
#      type      = "host"
#      read_only = false
#      source    = "website"
#    }
    task "angular" {
      driver = "docker"

        config {
            image = "httpd"
            port_map{ http = 80 }
            labels {
              group = "Website"
            }
        volumes = [
          "local/:/usr/local/apache2/htdocs/"
        ]
        }
        resources {
            network {
              port "http" {}
            }
        }
    
#        volume_mount {
#           volume      = "website"
#           destination = "/usr/local/apache2/htdocs/"
#           read_only   = false
#         }
    
    
        artifact {
            source      = "https://s3.amazonaws.com/mlewicki-mybucket-atos.net/website.tar.gz"
            destination = "local/"
            }
    
        service {
           name = "Website"
           tags = ["urlprefix-/"]
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

}


