terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

# Droplet resource which will create a new Droplet in Digital Ocean 
# with “webserver” as name and our previously defined image, region and size. 
# Also monitoring, private networking and backups are enabled. 
# The last line in the resource injects our SSH key into the droplet, so we can log in via SSH as root.
resource "digitalocean_droplet" "web" {
  image              = var.droplet_image
  name               = "webserver"
  region             = var.droplet_region
  size               = var.droplet_size
  backups            = true
  monitoring         = true
  private_networking = true
  ssh_keys = [
    var.ssh_fingerprint
  ]
}

# Firewall block -------------------------------------------------------------------
# This firewall allows inbound SSH, HTTP and HTTPS traffic to the webserver Droplet. 
# It also allows any kind of ICMP, TCP and UDP outbound traffic.
resource "digitalocean_firewall" "web" {
  name = "only-allow-ssh-http-and-https"

  droplet_ids = [digitalocean_droplet.web.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}