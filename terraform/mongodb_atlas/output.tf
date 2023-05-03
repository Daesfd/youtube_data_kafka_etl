output "project_name" {
  value = mongodbatlas_project.yt_kafka_project.name
}

output "cluster_name" {
  value = mongodbatlas_cluster.yt_stream_cluster.name
}

output "cluster_cloud_type" {
  value = mongodbatlas_cluster.yt_stream_cluster.backing_provider_name
}

output "cluster_region" {
  value = mongodbatlas_cluster.yt_stream_cluster.provider_region_name
}

output "cluster_size" {
  value = mongodbatlas_cluster.yt_stream_cluster.provider_instance_size_name
}

output "connection_string" {
  value = mongodbatlas_cluster.yt_stream_cluster.connection_strings[0]["standard_srv"]
}
