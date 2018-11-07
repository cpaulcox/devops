# TODO

# CIDR ranges
# Loadbalancer and rules L7?
# firewall rule
# create instance in a subnet
# forwarding rule?


# Provider
# Everything is owned by a project
provider "google" {
  credentials = "${file("../../account.json")}"
  #project     = "my-project-id" use env-var instead export GOOGLE_PROJECT=xxxxxxx
  region      = "us-central1"    # always free tier
  zone        = "us-central1-c"
}

# Default service account
#data "google_compute_default_service_account" "default" { }


#-------------------------------------------------------------------
#
# Network Toplogy
#
#-------------------------------------------------------------------

# network
# with two subnets - one for app servers and one for database
# settimg a CIDR range here is deprecated
resource "google_compute_network" "sky_net" {
  name                    = "sky-net"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "sky_subnet_app_server" {
  name          = "app-servers-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = "${google_compute_network.sky_net.self_link}"
#   secondary_ip_range {
#     range_name    = "tf-test-secondary-range-update1"
#     ip_cidr_range = "192.168.10.0/24"
#   }
}

resource "google_compute_subnetwork" "sky_subnet_database" {
  name          = "databases-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = "${google_compute_network.sky_net.self_link}"
#   secondary_ip_range {
#     range_name    = "tf-test-secondary-range-update1"
#     ip_cidr_range = "192.168.10.0/24"
#   }
}

#-------------------------------------------------------------------
#
# Network routing
#
#-------------------------------------------------------------------


resource "google_compute_router" "sky_net_rtr" {
  name    = "sky-net-rtr"
  network = "${google_compute_network.sky_net.name}"
#   bgp {  # border gateway protocol
#     asn               = 64514
#     advertise_mode    = "CUSTOM"
#     advertised_groups = ["ALL_SUBNETS"]
#     advertised_ip_ranges {
#       range = "6.7.0.0/16"
#     }
#   }
}

# Router routes
# Not clear what are optional in what combintation.
resource "google_compute_route" "net_route_1" {
  name        = "network-route-1"
  dest_range  = "15.0.0.0/24"  # IPV4 packet range of outgoing packets i.e. outgoing packets with this range of destination IPs goto the internet gateway
  network     = "${google_compute_network.sky_net.name}"
  next_hop_ip = "10.132.1.5"  # Network IP address of an instance that should handle matching packets
  priority    = 100
  #tags # list of instance tags to which the rule applies e.g. app_server_node or database_node
  #next_hop_gateway = "global/gateways/default-internet-gateway"  # only the Internet gateway is currently supported
}


#-------------------------------------------------------------------
#
# Firewall
#
#-------------------------------------------------------------------


resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = "${google_compute_network.sky_net.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

#-------------------------------------------------------------------
#
# LOad Balancer?
#
#-------------------------------------------------------------------

resource "google_compute_target_tcp_proxy" "default" {
  name            = "test-proxy"
  backend_service = "${google_compute_backend_service.default.self_link}"
}

resource "google_compute_backend_service" "default" {
  name          = "backend-service"
  protocol      = "TCP"
  timeout_sec   = 10

  health_checks = ["${google_compute_health_check.default.self_link}"]
}

resource "google_compute_health_check" "default" {
  name               = "health-check"
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "443"
  }
}


#-------------------------------------------------------------------
#
# Compute
#
#-------------------------------------------------------------------



resource "google_compute_instance" "terminator_1" {
  name         = "terminator-1"
  machine_type = "f1-micro"
  zone        = "us-central1-c"


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {  # can be many networks to attach to
    # A default network is created for all GCP projects
    #network       = "${google_compute_network.sky_net.self_link}"
    subnetwork = "${google_compute_subnetwork.sky_subnet_app_server.self_link}"    
    access_config = {
    }
  }
}
