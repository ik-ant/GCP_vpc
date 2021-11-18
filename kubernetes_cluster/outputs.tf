output "name" {
    value = google_container_cluster.preview_deploys.name
    description = "The Kubernetes cluster name."
}

output "project_id" {
    value = google_container_cluster.preview_deploys.project
}

output "zone" {
    value = google_container_cluster.preview_deploys.location
}

