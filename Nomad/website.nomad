job "Website" {

    datacenters = ["dc1"]
 

group "up&run"{

   volume "website" {
      type      = "host"
      read_only = false
      source    = "website"
    }
    task "angular" {
      driver = "docker"

        config {
            image = "httpd"
            portmap{ http = 80 }
            labels {
              group = "Website"
            }
        }
        resources {
            network {
              port "http" {}
            }
        }
    
        volume_mount {
           volume      = "website"
           destination = "/usr/local/apache2/htdocs/"
           read_only   = false
         }
    
    
        artifact {
            source      = "https://s3.amazonaws.com/mlewicki-mybucket-atos.net/website.tar"
            destination = "/opt/website/data/"
            options {
              checksum = "md5:df6a4178aec9fbdc1d6d7e3634d1bc33"
            }
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

    task "untar"{
        driver = "exec"
        config{ command = "/usr/bin/tar -xvf /opt/website/data/website.tar" }
        }
    }

}


