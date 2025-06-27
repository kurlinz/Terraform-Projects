locals {
  nsg_rules = {
    
    "allow_http" = {
      priority               = 100
      destination_port_range = "80"
      description           = "Allow HTTP"
    },
    "allow_ssh" = {
      priority               = 200
      destination_port_range = "22"
      description           = "Allow SSH"
    },
    "allow_https" = {
      priority               = 110
      destination_port_range = "443"
      description           = "Allow HTTPS"
    }
  }
}