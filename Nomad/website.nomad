job "Website" {

    
    volume "website" {
      type      = "host"
      read_only = false
      source    = "website"
    }

task "angular" {
  driver = "docker"

    artifact {
        source      = "http://mlewicki-mybucket-atos.net.s3-us-east-1.amazonaws.com/website.tar"
        destination = "local/some-directory"
        options {
          checksum = "md5:df6a4178aec9fbdc1d6d7e3634d1bc33"
        }
      }
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




