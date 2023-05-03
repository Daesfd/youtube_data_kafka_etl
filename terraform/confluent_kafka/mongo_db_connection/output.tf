output "Environment_name" {
  value = data.confluent_environment.Development.display_name
}

output "Environment_id" {
  value = data.confluent_environment.Development.id
}

output "Kafka_cluster_name" {
  value = data.confluent_kafka_cluster.basic.display_name
}

output "Kafka_cluster_id" {
  value = data.confluent_kafka_cluster.basic.id
}

output "Connector_name" {
  value = confluent_connector.mongo-db-sink.config_nonsensitive.name
}

output "Connector_env_id" {
  value = confluent_connector.mongo-db-sink.environment[0].id
}

output "Connector_kafka_cluster_id" {
  value = confluent_connector.mongo-db-sink.kafka_cluster[0].id
}

output "Connector_topic_name" {
  value = confluent_connector.mongo-db-sink.config_nonsensitive.topics
}
