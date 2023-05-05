terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.39.0"
    }
  }
}

data "terraform_remote_state" "conf_config" {
  backend = "local"

  config = {
    path = "../module/terraform.tfstate"
  }
}

locals {
  confluent_cloud_api_key = data.terraform_remote_state.conf_config.outputs["confluent_api_key"]
}

locals {
  confluent_cloud_api_secret = data.terraform_remote_state.conf_config.outputs["confluent_api_secret"]
}

locals {
  confluent_cluster_id = data.terraform_remote_state.conf_config.outputs["kafka_cluster_id"]
}


provider "confluent" {
  cloud_api_key    = local.confluent_cloud_api_key    # optionally use CONFLUENT_CLOUD_API_KEY env var
  cloud_api_secret = local.confluent_cloud_api_secret # optionally use CONFLUENT_CLOUD_API_SECRET env var
}

data "confluent_environment" "Development" {
  display_name = "Development"
}

data "confluent_kafka_cluster" "basic" {
  id = local.confluent_cluster_id
  environment {
    id = data.confluent_environment.Development.id
  }
}

data "confluent_schema_registry_region" "example" {
  cloud   = "AWS"
  region  = "us-east-2"
  package = "ESSENTIALS"
}

resource "confluent_schema_registry_cluster" "essentials" {
  package = data.confluent_schema_registry_region.example.package

  environment {
    id = data.confluent_environment.Development.id
  }

  region {
    # See https://docs.confluent.io/cloud/current/stream-governance/packages.html#stream-governance-regions
    # Schema Registry and Kafka clusters can be in different regions as well as different cloud providers,
    # but you should to place both in the same cloud and region to restrict the fault isolation boundary.
    id = data.confluent_schema_registry_region.example.id
  }
}

resource "confluent_service_account" "app-ksql" {
  display_name = "app-ksql"
  description  = "Service account to manage 'example' ksqlDB cluster"
}

resource "confluent_role_binding" "app-ksql-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = data.confluent_kafka_cluster.basic.rbac_crn
}


resource "confluent_role_binding" "app-ksql-schema-registry-resource-owner" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = format("%s/%s", confluent_schema_registry_cluster.essentials.resource_name, "subject=*")
}

resource "confluent_ksql_cluster" "example" {
  display_name = "mongodb_ksql_cluster"
  csu          = 1
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  credential_identity {
    id = confluent_service_account.app-ksql.id
  }
  environment {
    id = data.confluent_environment.Development.id
  }
  depends_on = [
    confluent_role_binding.app-ksql-kafka-cluster-admin,
    confluent_role_binding.app-ksql-schema-registry-resource-owner,
    confluent_schema_registry_cluster.essentials
  ]
}

resource "confluent_api_key" "app-ksql-cluster-api-key" {
  display_name = "app-ksql-cluster-api-key"
  owner {
    api_version = confluent_service_account.app-ksql.api_version
    id          = confluent_service_account.app-ksql.id
    kind        = confluent_service_account.app-ksql.kind
  }
  managed_resource {
    api_version = confluent_ksql_cluster.example.api_version
    id          = confluent_ksql_cluster.example.id
    kind        = confluent_ksql_cluster.example.kind

    environment {
      id = data.confluent_environment.Development.id
    }
  }
}