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

output "Topic_ingestion_name" {
  value = confluent_kafka_topic.data_ingestion_topic.topic_name
}

output "Topic_change_name" {
  value = confluent_kafka_topic.data_change_topic.topic_name
}

output "Topic_connect_name" {
  value = confluent_kafka_topic.connection_topic.topic_name
}

output "Cluster_api_id" {
  value = confluent_api_key.app_manager_kafka_api_key.id
}

output "Cluster_api_secret" {
  value = confluent_api_key.app_manager_kafka_api_key.secret
  sensitive = true
}
