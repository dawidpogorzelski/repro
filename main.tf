variable "projectid" {}

provider "google" {
  project = var.projectid
}

resource "google_compute_backend_service" "test" {
  name = "test"
}
