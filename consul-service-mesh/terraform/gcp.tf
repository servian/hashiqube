# https://www.terraform.io/docs/providers/google/r/compute_instance.html
# https://github.com/terraform-providers/terraform-provider-google/blob/master/examples/internal-load-balancing/main.tf

provider "google" {
  credentials = file("~/.gcp/credentials.json")
  project     = var.gcp_project
  region      = var.gcp_region
}

resource "google_compute_region_instance_group_manager" "hashiqube" {
  name     = "hashiqube"
  provider = google

  base_instance_name        = var.gcp_cluster_name
  region                    = var.gcp_region
  distribution_policy_zones = var.gcp_zones

  version {
    name              = var.gcp_cluster_name
    instance_template = google_compute_instance_template.hashiqube.self_link
  }

  target_size = var.gcp_cluster_size

  depends_on = [google_compute_instance_template.hashiqube]

  update_policy {
    type           = "PROACTIVE"
    minimal_action = "REPLACE"

    max_surge_fixed       = 3
    max_unavailable_fixed = 0
    min_ready_sec         = 60
  }
}

data "google_compute_subnetwork" "default" {
  provider = google
  name     = "default"
}

data "template_file" "hashiqube2_user_data" {
  template = file("./startup_script")
  vars = {
    HASHIQUBE1_IP = aws_eip.hashiqube.public_ip
    HASHIQUBE2_IP = google_compute_address.static.address
  }
}

resource "google_compute_instance_template" "hashiqube" {
  provider    = google
  name_prefix = var.gcp_cluster_name
  description = var.gcp_cluster_description

  instance_description = var.gcp_cluster_description
  machine_type         = var.gcp_machine_type

  tags = list(var.gcp_cluster_tag_name)

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  disk {
    boot         = true
    auto_delete  = true
    source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
    disk_size_gb = var.gcp_root_volume_disk_size_gb
    disk_type    = var.gcp_root_volume_disk_type
  }

  # metadata_startup_script = file("./startup_script")
  metadata_startup_script = data.template_file.hashiqube2_user_data.rendered

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.default.self_link

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  service_account {
    email  = google_service_account.consul_compute.email
    scopes = ["userinfo-email", "compute-ro", "storage-rw"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_address" "static" {
  name = "hashiqube"
}

resource "google_compute_firewall" "hashiqube" {
  name    = "${var.gcp_cluster_name}-hashiqube"
  network = "default"
  project = var.gcp_project

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["${data.external.myipaddress.result.ip}/32", "${aws_eip.hashiqube.public_ip}/32"]
}

resource "google_compute_firewall" "hashiqube1" {
  name    = "${var.gcp_cluster_name}-hashiqube1"
  network = "default"
  project = var.gcp_project

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["${aws_eip.hashiqube.public_ip}/32"]
  description   = "HASHIQUBE1_IP"
}

resource "google_service_account" "consul_compute" {
  account_id   = "sa-consul-compute-prod"
  display_name = "Consul Primary Account for ${var.gcp_project}"
  project      = var.gcp_project
}

resource "google_project_iam_member" "compute_policy" {
  project = var.gcp_project
  role    = "roles/compute.networkViewer"
  member  = "serviceAccount:${google_service_account.consul_compute.email}"
}

output "GCP_hashiqube2-service-consul" {
  value = google_compute_address.static.address
}

output "GCP_hashiqube2-ssh-service-consul" {
  value = "ssh ubuntu@${google_compute_address.static.address}"
}

output "GCP_hashiqube2-consul-service-consul" {
  value = "http://${google_compute_address.static.address}:8500"
}

output "GCP_hashiqube2-nomad-service-consul" {
  value = "http://${google_compute_address.static.address}:4646"
}

output "GCP_hashiqube2-fabio-ui-service-consul" {
  value = "http://${google_compute_address.static.address}:9998"
}
