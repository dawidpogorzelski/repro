variable "projectid" {}
data "google_compute_zones" "available" {
  region = "europe-west1"
}

provider "google" {
  project = var.projectid
}

resource "google_compute_health_check" "test" {
  name = "test"

  timeout_sec        = 1
  check_interval_sec = 10

  tcp_health_check {
    port = 8010
  }
}

resource "google_compute_instance_group" "test" {
  name = "test"
  zone = data.google_compute_zones.available.names[0]

  instances = []

  named_port {
    name = "foo"
    port = 8010
  }

  named_port {
    name = "bar"
    port = 80
  }
}
resource "google_compute_backend_service" "test" {
  name      = "test"
  protocol  = "HTTP"
  port_name = "test"

  backend {
    group = google_compute_instance_group.test.self_link
  }

  health_checks = [
    google_compute_health_check.test.self_link
  ]
}
