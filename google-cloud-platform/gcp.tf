# Global: VPC, Routes, Firewalls
# Regional: Static IP, Subnets
# Zonal: Instances, Disks, Machine Types
#
# 

# TODO

# Loadbalancer and rules L7?
# firewall rule
# forwarding rule?
# firewall rules on a subnet

# https://tools.ietf.org/html/rfc1918 Private address ranges must be used for subnets
#  10.0.0.0        -   10.255.255.255  (10/8 prefix)
#  172.16.0.0      -   172.31.255.255  (172.16/12 prefix)
#  192.168.0.0     -   192.168.255.255 (192.168/16 prefix)

# Provider
# Everything is owned by a project
provider "google" {
  credentials = "${file("../../account.json")}"
  #project     = "my-project-id" use env-var instead export GOOGLE_PROJECT=xxxxxxx
  region      = "us-central1"    # always free tier
  zone        = "us-central1-b"
}

# Default service account
#data "google_compute_default_service_account" "default" { }


#-------------------------------------------------------------------
#
# Network Toplogy
#
# 172.16.0.0/24 (256 addresses - least significant octet)
# 172.16.1.0/24 (256 addresses - least significant octet)
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
  ip_cidr_range = "172.16.0.0/24"
  region        = "us-central1"
  network       = "${google_compute_network.sky_net.self_link}"
#   secondary_ip_range {
#     range_name    = "tf-test-secondary-range-update1"
#     ip_cidr_range = "192.168.10.0/24"
#   }
}

resource "google_compute_subnetwork" "sky_subnet_database" {
  name          = "databases-subnet"
  ip_cidr_range = "172.16.1.0/24"
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
  next_hop_ip = "172.16.1.99"  # Network IP address of an instance that should handle matching packets
  priority    = 100
  #tags # list of instance tags to which the rule applies e.g. app_server_node or database_node
  #next_hop_gateway = "global/gateways/default-internet-gateway"  # only the Internet gateway is currently supported
}

# lowest priority route applies to all IP addresses.  If nothing matches first then send to the Internet
resource "google_compute_route" "internet_route" {
  name        = "internet-route"
  dest_range  = "0.0.0.0/0"  # IPV4 packet range of outgoing packets i.e. outgoing packets with this range of destination IPs goto the internet gateway
  network     = "${google_compute_network.sky_net.name}"
  priority    = 999
  next_hop_gateway = "global/gateways/default-internet-gateway"  # only the Internet gateway is currently supported
}


#-------------------------------------------------------------------
#
# Firewall Rules...Terraform resource is badly named
#
#-------------------------------------------------------------------


resource "google_compute_firewall" "firewall_rule_1" {
  name    = "firewall-1"
  network = "${google_compute_network.sky_net.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  # deny {

  # }
  source_tags = ["app-server"]
  //target_tags = ["app-server"]

  // default = 1000
  priority = 1000
}

resource "google_compute_firewall" "firewall_rule_2" {
  name    = "firewall-2"
  network = "${google_compute_network.sky_net.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  # deny {

  # }
  //source_tags = ["database"]
  // Does this mean the target instances only allow HTTP traffic?
  target_tags = ["database"]

  // default = 1000
  priority = 1000
}

#-------------------------------------------------------------------
#
# Load Balancer?
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
# https://www.terraform.io/docs/providers/google/r/compute_instance.html
#-------------------------------------------------------------------

resource "google_compute_instance" "terminator_1" {
  name         = "terminator-1"
  machine_type = "f1-micro"
  // Zone is required but defaults to the provider zone
  #zone        = "us-central1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  # scratch_disk {
  # }

  network_interface {  # can be many networks to attach to
    # A default network is created for all GCP projects
    #network       = "${google_compute_network.sky_net.self_link}"
    #network       = "default"
    subnetwork = "${google_compute_subnetwork.sky_subnet_app_server.self_link}"

    // Omit this block to ensure that the instance is not accessible from the Internet
    access_config {
      // Ephemeral public IP - auto-generated
    }
  }

  metadata {
    data = "visible inside instance"
  }

  // Does this conflict with the metadata key?
  //metadata_startup_script = "echo hi > /test.txt"

  labels = [
    { environment = "test" }
    ]
  
  tags = ["app-server"]

  # Akin to EC2 Instance Profile - the bob-the-instance-builder for a Jenkins slave instance running acceptance tests on spawned VMs.
  # service_account {
  #   email = "bob@builder.com"
  #   scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  # }
}
