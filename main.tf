variable "vultr_api_key" {
  description = "Vultr API Key"
}

terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.17.1"
    }
  }
}

provider "vultr" {
  api_key     = var.vultr_api_key
  rate_limit  = 100
  retry_limit = 3
}

resource "vultr_instance" "vm_docker" {
  plan     = "vc2-1c-1gb"
  region   = "fra"
  image_id = "docker"

  user_data = <<-EOF
              #!/bin/bash
              docker pull satzisa/html5-speedtest
              docker run -d -p 80:80 satzisa/html5-speedtest
              EOF
}

output "ip_address" {
  value = vultr_instance.vm_docker.main_ip
}
