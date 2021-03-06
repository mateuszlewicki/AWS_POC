job "Prometheus" {
  datacenters = ["dc1"]
  group "promWCons"{
  task "conExp"{
    driver= "docker"
    config{ 
      network_mode = "host"
      image = "prom/consul-exporter"
      args = [ "--consul.server=127.0.0.1:8500"]
     	labels {
        group = "monitor"
      }
    }
    resources{
    	network{
       port "tcp"{
       		static = 9107
       		}
       }
    }
      service{
      	name="ConsExp"
        port="tcp"
        check{
        	type = "tcp"
          port = "tcp"
          interval = "10s"
          timeout = "5s"
        }
      }
        
    
  }
task "monitor" {
  driver = "docker"

  config {
    network_mode = "host"
    image = "prom/prometheus:latest"
    args = [
        "--config.file=/etc/prometheus/prometheus.yml",
        "--web.route-prefix=/prometheus",
        "--web.external-url=http://localhost/prometheus/"
]
    

     volumes = [
          "local/prometheus.yml:/etc/prometheus/prometheus.yml"
        ]
    #port_map{ http = 9090 }
    labels {
      group = "monitor"
    }
  }
  artifact {
      source = "s3::https://s3.amazonaws.com/mlewicki-mybucket-atos.net/config.yml"
      destination = "local/prometheus.yml"
      mode = "file"
      }
  resources {
    network {
      port "http" {
      static = 9090}
    }
  }

  service {
    name = "prometheus"
    tags = ["urlprefix-/prometheus redirect=303"]
    port = "http"
    check {
      name     = "alive"
      type     = "http"
      path     = "/prometheus/-/healthy"
      interval = "10s"
      timeout  = "2s"
      }
    }
}
  }

}
