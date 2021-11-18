locals {
    hostname = format("%s-bastion", var.bastion_name)
}

resource "google_service_account" "bastion" {
  account_id = format("%s-bastion-sa", var.bastion_name)
  display_name = "GKE Bastion Service Account"
}

resource "google_compute_firewall" "bastion-ssh" {
  name = format("%s-basstion-ssh", var.bastion_name)
  network = var.vpc_name
  direction = "INGRESS"
  project = var.project_id
  source_ranges = [ "0.0.0.0/0" ]

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  target_tags = ["bastion"]
}

# data "template_file" "startup_script" {
#   template = <<-EOF
#   sudo yum update -y
#   sudo yum install -y tinyproxy
#   sudo systemctl start tinyproxy
#   sudo systemctl enable tinyproxy
#   EOF
# }

resource "google_compute_instance" "bastion" {
  name = local.hostname
  machine_type = "e2-micro"
  zone = var.zone
  tags = [ "bastion" ]
  project = var.project_id
  boot_disk {
    initialize_params {
        image = "centos-cloud/centos-7"
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
    enable_vtpm = true
    enable_integrity_monitoring = true
  }

  metadata_startup_script = "sudo yum -y install tinyproxy && sudo yum -y install kubectl && sudo systemctl start tinyproxy && sudo systemctl enable tinyproxy"

  network_interface {
    subnetwork = var.subnet_name

    access_config {
        network_tier = "STANDARD"
    }
  }

  allow_stopping_for_update = true
  
  service_account {
      email = google_service_account.bastion.email
      scopes = ["cloud-platform"]
  }

#   provisioner "local-exec" {
#     command = <<EOF
#         READY=""
#         for i in $(seq 1 20); do
#           if gcloud compute ssh ${local.hostname} --project ${var.project_id} --zone ${var.region}-b --command uptime; then
#             READY="yes"
#             break;
#           fi
#           echo "Waiting for ${local.hostname} to initialize..."
#           sleep 10;
#         done
#         if [[ -z $READY ]]; then
#           echo "${local.hostname} failed to start in time."
#           echo "Please verify that the instance starts and then re-run `terraform apply`"
#           exit 1
#         fi
# EOF
#   }

  scheduling {
    preemptible = true
    automatic_restart = false
  }
}   