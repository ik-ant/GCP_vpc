provider "google" {
  project = ""
  region = "us-central1"
  zone = "us-centrall1-c"

  credentials = file("")
}


module "network" {
  source = "../network"
  presentation_tags = ["key"]
  
  presentation_protocol = "tcp"
  presentation_ports = ["22"]
  
  app_firewall_ingress_range = ["10.0.1.0/24"]
  app_tags = [ "pem" ]

  app_protocol = "tcp"
  app_ports = ["22"]

  
  db_firewall_ingress_range = ["10.0.2.0/24"]
  db_tags = [ "de" ]


  db_protocol = "tcp"
  db_ports = ["22"]


  delete_default_routes_on_create = true

  subnets = [
    {
      subnet_name = "presentation-subnet"
      subnet_ip_range = "10.0.1.0/24"
      subnet_region = "us-central1"
    },
    {
      subnet_name = "app-subnet"
      subnet_ip_range = "10.0.2.0/24"
      subnet_region = "us-central1"
    },
    {
      subnet_name = "db-subnet"
      subnet_ip_range = "10.0.3.0/24"
      subnet_region = "us-central1"
    },

  ]
  # app_tags = module.gke.tags
}