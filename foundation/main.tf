terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  region = "fr-par"
}

resource "scaleway_registry_namespace" "registry" {
  name        = "container-registry"
  description = "Main container registry"
}

resource "scaleway_k8s_cluster" "cluster" {
  name    = "cluster"
  version = "1.21.5"
  # private_network_id          = var.vpc_id
  cni = "cilium"
  # project_id                  = var.project_id
  delete_additional_resources = false
}

resource "scaleway_rdb_instance" "prod_db" {
  name      = "prod-db"
  node_type = "DB-DEV-S"
  engine    = "redis"
  password  = var.db_password
}

resource "scaleway_lb" "dev_lb" {
  name = "dev-lb"
  # project_id = var.project_id
  type = "LB-S"
}

resource "scaleway_lb" "prod_lb" {
  name = "prod-lb"
  # project_id = var.project_id
  type = "LB-S"
}

resource "scaleway_domain_record" "prod_dns" {
  dns_zone = "kiowy.net"
  name     = "calculatrice-dunand-mathieu-polytech-dijon.kiowy.net"
  type     = "A"
  data     = "1.2.3.4"
  # value = scaleway_lb.prod_lb.ip
  ttl = 3600
}

resource "scaleway_domain_record" "dev_dns" {
  dns_zone = "kiowy.net"
  name     = "calculatrice-dev-dunand-mathieu-polytech-dijon.kiowy.net"
  type     = "A"
  data     = "1.2.3.4"
  # value = scaleway_lb.dev_lb.ip
  ttl = 3600
}

# export AWS_ACCESS_KEY_ID="<access-key-id>"
# export AWS_SECRET_ACCESS_KEY="<access-key-secret>"
# export AWS_REGION="eu-west-3"