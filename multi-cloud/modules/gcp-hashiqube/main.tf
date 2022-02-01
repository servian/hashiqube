# https://www.terraform.io/docs/providers/google/r/compute_instance.html
# https://github.com/terraform-providers/terraform-provider-google/blob/master/examples/internal-load-balancing/main.tf

resource "null_resource" "hashiqube" {
  triggers = {
    deploy_to_aws      = var.deploy_to_aws
    deploy_to_azure    = var.deploy_to_azure
    deploy_to_gcp      = var.deploy_to_gcp
    whitelist_cidr     = var.whitelist_cidr
    my_ipaddress       = var.my_ipaddress
    gcp_project        = var.gcp_project
    gcp_credentials    = var.gcp_credentials
    ssh_public_key     = var.ssh_public_key
    aws_hashiqube_ip   = var.aws_hashiqube_ip
    azure_hashiqube_ip = var.azure_hashiqube_ip
    vault_enabled      = lookup(var.vault, "enabled")
    vault_version      = lookup(var.vault, "version")
  }
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
    type                 = "PROACTIVE"
    minimal_action       = "REPLACE"
    max_surge_fixed       = 3
    max_unavailable_fixed = 0
    min_ready_sec        = 60
  }
}

data "google_compute_subnetwork" "hashiqube" {
  provider = google
  name     = "default"
}

data "template_file" "hashiqube" {
  template = file("${path.module}/../../modules/shared/startup_script")
  vars = {
    HASHIQUBE_GCP_IP   = google_compute_address.hashiqube.address
    HASHIQUBE_AWS_IP   = var.aws_hashiqube_ip == null ? "" : var.aws_hashiqube_ip
    HASHIQUBE_AZURE_IP = var.azure_hashiqube_ip == null ? "" : var.azure_hashiqube_ip
    VAULT_ENABLED      = lookup(var.vault, "enabled")
  }
}

resource "google_compute_instance_template" "hashiqube" {
  provider             = google
  name_prefix          = var.gcp_cluster_name
  description          = var.gcp_cluster_description
  instance_description = var.gcp_cluster_description
  machine_type         = var.gcp_machine_type
  tags                 = list(var.gcp_cluster_tag_name)
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
  metadata_startup_script = data.template_file.hashiqube.rendered
  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key)}"
  }
  network_interface {
    subnetwork = data.google_compute_subnetwork.hashiqube.self_link
    access_config {
      nat_ip = google_compute_address.hashiqube.address
    }
  }
  service_account {
    email  = google_service_account.hashiqube.email
    scopes = ["userinfo-email", "compute-ro", "storage-rw"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_address" "hashiqube" {
  name = "hashiqube"
}

resource "google_compute_firewall" "my_ipaddress" {
  name    = "${var.gcp_cluster_name}-my-ipaddress"
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
  source_ranges = ["${var.my_ipaddress}/32"]
}

resource "google_compute_firewall" "aws-hashiqube_ip" {
  count   = var.deploy_to_aws ? 1 : 0
  name    = "aws-hashiqube-ip"
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
  source_ranges = ["${var.aws_hashiqube_ip}/32"]
}

resource "google_compute_firewall" "azure_hashiqube_ip" {
  count   = var.deploy_to_azure ? 1 : 0
  name    = "azure-hashiqube-ip"
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
  source_ranges = ["${var.aws_hashiqube_ip}/32"]
}

resource "google_compute_firewall" "gcp_hashiqube_ip" {
  count   = var.deploy_to_gcp ? 1 : 0
  name    = "gcp-hashiqube-ip"
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
  source_ranges = ["${google_compute_address.hashiqube.address}/32"]
}

resource "google_compute_firewall" "whitelist_cidr" {
  count   = var.whitelist_cidr != "" ? 1 : 0
  name    = "whitelist-cidr"
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
  source_ranges = [var.whitelist_cidr]
}

resource "google_service_account" "hashiqube" {
  account_id   = var.gcp_account_id
  display_name = "hashiqube"
  project      = var.gcp_project
}

resource "google_project_iam_member" "hashiqube" {
  project = var.gcp_project
  role    = "roles/compute.networkViewer"
  member  = "serviceAccount:${google_service_account.hashiqube.email}"
}
