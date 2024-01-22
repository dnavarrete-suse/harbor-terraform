variable "do_token" {
}

variable "region" {
  default = "fra1"
}

variable "harbor_password" {
  default = "Harbor12345"
}

variable "email" {
}

variable "docker_version" {
}

variable "size" {
  default = "s-4vcpu-8gb"
}

variable "image" {
  default = "ubuntu-20-04-x64"
}

variable "digitalocean_domain" {
}

variable "ssh_keys" {
  default = []
}

variable "instance_suffix" {
}
  
