
provider "google" {
  project     = "paul-cox-sandbox"
  region      = "us-central1"
}

data "google_container_cluster" "your-first-cluster-1" {
  name       = "your-first-cluster-1"
  location   = "us-central1-a"
}

#output "cluster_username" {
#  value = "${data.google_container_cluster.your-first-cluster-1.master_auth.0.username}"
#}

#output "cluster_password" {
#  value = "${data.google_container_cluster.your-first-cluster-1.master_auth.0.password}"
#}

#output "endpoint" {
#  value = "${data.google_container_cluster.your-first-cluster-1.endpoint}"
#}

#output "instance_group_urls" {
#  value = "${data.google_container_cluster.your-first-cluster-1.instance_group_urls}"
#}

#output "node_config" {
#  value = "${data.google_container_cluster.your-first-cluster-1.node_config}"
#}



#output "node_pools" {
#  value = "${data.google_container_cluster.your-first-cluster-1.node_pool}"
#}

output "cluster" {
  value = "${data.google_container_cluster.your-first-cluster-1}"
}
