locals {
    subnets = {
        for x in var.subnets :
        "${x.subnet_region}/${x.subnet_name}" => x
    }
}

#======================VPC============================
resource "google_compute_network" "vpc" {
  name = var.gcp_vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode = var.routing_mode
  delete_default_routes_on_create = var.delete_default_routes_on_create
}


#===================SUBNETS===========================
resource "google_compute_subnetwork" "subnets" {
    for_each = local.subnets
    name = each.value.subnet_name
    ip_cidr_range = each.value.subnet_ip_range
    region = each.value.subnet_region
    network = google_compute_network.vpc.id
    description = lookup(each.value, "description", null)
    private_ip_google_access = lookup(each.value, "subnet_private_access", "true")
}

#=================COMPUTE ROUTER======================
resource "google_compute_route" "igw" {
  # count = var.gcp_create_router 
  name = "route"
  network = google_compute_network.vpc.name
  
  dest_range = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
}