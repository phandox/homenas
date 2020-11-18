variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "testenv-compute" {
  image = "centos-7.6-x64"
  name = "testsrv-01"
  region = "fra1"
  size = "s-1vcpu-1gb"
  backups = false,
  ipv6 = true,
  user_data = file("${path.module}/cloud-config.yaml")
  private_networking = true
  monitoring = true
}

resource "digitalocean_firewall" "testenv-firewall" {
  name = "only-22"

  droplet_ids = [digitalocean_droplet.testenv-compute]

  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}