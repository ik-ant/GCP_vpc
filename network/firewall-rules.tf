#=======================PRESENTATION=========================

resource "google_compute_firewall" "presentation" {
    name = "presentation-firewall"
    network =  google_compute_network.vpc.name

    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]
    target_tags = var.presentation_tags

    allow {
        protocol = var.presentation_protocol
        ports = var.presentation_ports
    }
}


#=======================APPLILCATION=========================

resource "google_compute_firewall" "app" {
    name = "app-firewall"
    network =  google_compute_network.vpc.name

    direction = "INGRESS"
    source_ranges = var.app_firewall_ingress_range
    target_tags = var.app_tags

    allow {
        protocol = var.app_protocol
        ports = var.app_ports
    }
    depends_on = [
      google_compute_subnetwork.subnets
    ]
}


#=======================DATABASE==============================

resource "google_compute_firewall" "db" {
    name = "db-firewall"
    network = google_compute_network.vpc.name

    direction = "INGRESS"
    source_ranges = var.db_firewall_ingress_range
    target_tags = var.db_tags

    allow {
        protocol = var.db_protocol
        ports = var.db_ports
    }
}





