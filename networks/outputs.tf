output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "subnet_name" {
  value = [for subnet in google_compute_subnetwork.subnets: subnet.name]
}

output "subnet_region" {
  value = [for subnet in google_compute_subnetwork.subnets: subnet.region]
}

output "cluster_pods_ip_cidr_range" {
  value = local.cluster_pods_ip_cidr_range
  description = "The CIDR range to use for Kubernetes cluster pods"
}


output "cluster_services_ip_cidr_range" {
  value = local.cluster_services_ip_cidr_range
  description = "The CIDR range to user for Kubernetes cluster services"
}

output "cluster_master_ip_cidr_range" {
  value = local.cluster_master_ip_cidr_range
}