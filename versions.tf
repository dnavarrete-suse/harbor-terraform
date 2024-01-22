terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    template = {
      source = "hashicorp/template"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.32.0"
    }    
  }
}
