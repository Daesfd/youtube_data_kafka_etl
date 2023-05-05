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

resource "confluent_service_account" "app-manager" {
  display_name = "topic-manager"
  description  = "Service account to manage 'inventory' Kafka cluster"
}

data "confluent_kafka_cluster" "basic" {
  id = local.confluent_cluster_id
  environment {
    id = data.confluent_environment.Development.id
  }
}

resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = data.confluent_kafka_cluster.basic.rbac_crn
}

resource "confluent_api_key" "app_manager_kafka_api_key" {
  display_name = "app_manager_kafka_api_key"
  owner {
    api_version = confluent_service_account.app-manager.api_version
    id          = confluent_service_account.app-manager.id
    kind        = confluent_service_account.app-manager.kind
  }
  managed_resource {
    api_version = data.confluent_kafka_cluster.basic.api_version
    id          = data.confluent_kafka_cluster.basic.id
    kind        = data.confluent_kafka_cluster.basic.kind

    environment {
      id = data.confluent_environment.Development.id
    }
  }

  depends_on = [
    confluent_role_binding.app-manager-kafka-cluster-admin
  ]
}

resource "confluent_kafka_topic" "connection_topic" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  topic_name = "connection_topic"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.app_manager_kafka_api_key.id
    secret = confluent_api_key.app_manager_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "data_ingestion_topic" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  topic_name = "data_ingestion_topic"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.app_manager_kafka_api_key.id
    secret = confluent_api_key.app_manager_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "data_change_topic" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.basic.id
  }
  topic_name = "data_change_topic"
  rest_endpoint = data.confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.app_manager_kafka_api_key.id
    secret = confluent_api_key.app_manager_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

