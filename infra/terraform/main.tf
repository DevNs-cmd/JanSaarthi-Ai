terraform {
  required_version = ">= 1.6.0"
}

variable "region" {
  type = string
  default = "in-central-1"
}

variable "cluster_name" {
  type = string
  default = "jansaarthi-prod"
}

output "cluster_name" {
  value = var.cluster_name
}
