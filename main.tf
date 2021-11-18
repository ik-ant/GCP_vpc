terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.53.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file_path)

  project = var.project_id
  region  = var.region
  zone    = var.main_zone
}

module "google_networks" {
  source = "./networks"

  nat_subnet_name = "application-subnet "

  #==========================SUBNETS=============================
  subnets = [
    {
      subnet_name     = "presentation-subnet"
      subnet_ip_range = var.presentation_ip_range
      subnet_region   = "us-central1"
    },
    {
      subnet_name           = "application-subnet"
      subnet_ip_range       = var.application_ip_range
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "database-subnet"
      subnet_ip_range       = var.database_ip_range
      subnet_region         = "us-central1"
      subnet_private_access = true
    },

  ]


  #============================ROUTES=============================

  routes = [
    {
      name              = "igw-route"
      destination_range = var.igw_destination
      next_hop_internet = "true"
    },
  ]

  #=========================FIREWALL-RULES========================
  firewall_rules = [
    {
      name        = "presentation-firewall-rule"
      direction   = "INGRESS"
      ranges      = var.presentation_firewall_ranges
      target_tags = ["public"]
      source_tags = null

      allow = [{
        protocol = "all"
        ports    = null
      }]
      deny = []
    },
    {
      name        = "application-firewall-rule"
      direction   = "INGRESS"
      ranges      = var.application_firewall_ranges
      target_tags = ["application"]
      source_tags = null

      allow = [{
        protocol = "all"
        ports    = null
      }]
      deny = []

    },
    {
      name        = "database-firewall-rule"
      direction   = "INGRESS"
      ranges      = var.database_firewall_ranges
      source_tags = null
      target_tags = ["database"]

      allow = [{
        protocol = "all"
        ports    = null
      }]
      deny = []
    }
  ]
}


module "google_kubernetes_cluster" {
  source = "./kubernetes_cluster"

  location                   = "us-central1-b"
  network                    = module.google_networks.vpc_name
  subnet_name                = module.google_networks.subnet_name[0]
  ip_range_pods              = module.google_networks.cluster_pods_ip_cidr_range
  ip_range_services          = module.google_networks.cluster_services_ip_cidr_range
  master_ipv4_cidr_block     = module.google_networks.cluster_master_ip_cidr_range
  authorized_ipv4_cidr_block = "${module.bastion.ip}/32"
  tags                       = ["application"]
}

module "bastion" {
  source = "./bastion"

  region       = var.region
  project_id   = var.project_id
  zone         = var.main_zone
  bastion_name = "app-cluster"
  vpc_name     = module.google_networks.vpc_name
  subnet_name  = module.google_networks.subnet_name[2]
}