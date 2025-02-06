terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.49.0"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  zone   = "fr-par-1"
  region = "fr-par"
}

resource "scaleway_registry_namespace" "registry" {
  name        = "container-registry"
  description = "Registry calculatrice"
}

resource "scaleway_k8s_cluster" "cluster" {
  name                        = "calculatrice-dunand-mathieu-cluster"
  version                     = "1.29.1"
  cni                         = "cilium"
  delete_additional_resources = false
}

resource "scaleway_rdb_instance" "redis_instance" {
  name              = "calculatrice-${var.environment}-rdb"
  engine            = "redis"
  node_type         = var.environment == "prod" ? "DB-GENERAL-XS" : "DB-DEV-S"
  volume_size_in_gb = var.environment == "prod" ? 20 : 10
  region            = "fr-par"
  user_name         = "admin"
  password          = var.redis_password
}

resource "scaleway_rdb_database" "dev" {
  name        = "calculatrice-dev-db"
  count       = var.environment == "dev" ? 1 : 0
  instance_id = scaleway_rdb_instance.redis_instance.id
}

resource "scaleway_rdb_database" "prod" {
  name        = "calculatrice-prod-db"
  count       = var.environment == "prod" ? 1 : 0
  instance_id = scaleway_rdb_instance.redis_instance.id
}

resource "scaleway_domain_record" "dns" {
  dns_zone = "polytech-dijon.kiowy.net"
  name     = var.environment == "dev" ? "calculatrice-dev-dunand-mathieu" : "calculatrice-dunand-mathieu"
  type     = "A"
  data     = scaleway_lb_ip.ip.ip_address
  ttl      = 3600
}

resource "scaleway_lb_ip" "ip" {
  zone = "fr-par-1"
}

resource "scaleway_lb" "lb" {
  ip_ids = [scaleway_lb_ip.ip.id]
  zone   = scaleway_lb_ip.ip.zone
  name   = "calc-${var.environment}-lb"
  type   = "LB-S"
}


output "lb_ip" {
  value       = scaleway_lb_ip.ip.ip_address
  description = "Adresse IP du load balancer"
}

