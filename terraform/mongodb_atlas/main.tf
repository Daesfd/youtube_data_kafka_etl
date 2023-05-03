terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.8.2"
    }
  }
}

provider "mongodbatlas" {
  public_key = var.mongodb_public_key
  private_key = var.mongodb_private_key
}

data "mongodbatlas_roles_org_id" "yt_kafka_project" {
}

resource "mongodbatlas_project" "yt_kafka_project" {
  name   = "yt_kafka_project"
  org_id = data.mongodbatlas_roles_org_id.yt_kafka_project.id
}

resource "mongodbatlas_cluster" "yt_stream_cluster" {
  name                        = var.mongodb_cluster_name
  project_id                  = mongodbatlas_project.yt_kafka_project.id

  provider_name               = "TENANT"
  backing_provider_name       = var.cluster_cloud_type
  provider_instance_size_name = var.cluster_size_type
  provider_region_name        = var.region
}
