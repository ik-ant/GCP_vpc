#================================ SUBNETS ==================================
resource "google_compute_subnetwork" "subnets" {
    for_each = local.subnets
    name = each.value.subnet_name
    ip_cidr_range = each.value.subnet_ip_range
    region = each.value.subnet_region
    network = google_compute_network.vpc.id
    description = lookup(each.value, "description", null)
    private_ip_google_access = lookup(each.value, "subnet_private_access", null)
}