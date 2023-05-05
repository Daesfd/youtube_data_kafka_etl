output "confluent_api_key" {
  value = var.confluent_cloud_api_key
}

output "confluent_api_secret" {
  value = var.confluent_cloud_api_secret
  sensitive = true
}

output "kafka_cluster_id" {
  value = var.confluent_cluster_id
}