terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.39.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key    # optionally use CONFLUENT_CLOUD_API_KEY env var
  cloud_api_secret = var.confluent_cloud_api_secret # optionally use CONFLUENT_CLOUD_API_SECRET env var
}

data "confluent_environment" "Development" {
  display_name = "Development"
}

data "confluent_kafka_cluster" "basic" {
  id = var.confluent_cluster_id
  environment {
    id = data.confluent_environment.Development.id
  }
}
