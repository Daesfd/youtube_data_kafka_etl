output "environment_name" {
  value = data.confluent_environment.Development.display_name
}

output "environment_id" {
  value = data.confluent_environment.Development.id
}

output "Kafka_cluster_name" {
  value = data.confluent_kafka_cluster.basic.display_name
}

output "Kafka_cluster_id" {
  value = data.confluent_kafka_cluster.basic.id
}

output "Kafka_cluster_cloud_region" {
  value = data.confluent_kafka_cluster.basic.region
}

output "Kafka_cluster_cloud_type" {
  value = data.confluent_kafka_cluster.basic.cloud
}

output "Kafka_cluster_cloud_availability" {
  value = data.confluent_kafka_cluster.basic.availability
}

output "Kafka_cluster_env_id" {
  value = data.confluent_kafka_cluster.basic.environment[0].id
}

output "Ksql_cluster_name" {
  value = confluent_ksql_cluster.example.display_name
}

output "Ksql_cluster_id" {
  value = confluent_ksql_cluster.example.id
}

output "Ksql_cluster_env_id" {
  value = confluent_ksql_cluster.example.environment[0].id
}

output "Ksql_cluster_kafka_cluster_id" {
  value = confluent_ksql_cluster.example.kafka_cluster[0].id
}

output "Schema_registry_url" {
  value = confluent_schema_registry_cluster.essentials.rest_endpoint
}

output "Schema_registry_id" {
  value = confluent_api_key.app-ksql-cluster-api-key.id
}

output "Schema_registry_secret" {
  value = confluent_api_key.app-ksql-cluster-api-key.secret
  sensitive = true
}